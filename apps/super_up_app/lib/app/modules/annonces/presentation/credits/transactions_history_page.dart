import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/credit_transaction.dart';
import 'package:super_up/app/modules/annonces/providers/wallet_provider.dart';
import 'package:super_up_core/super_up_core.dart';

class TransactionsHistoryPage extends StatefulWidget {
  const TransactionsHistoryPage({super.key});

  @override
  State<TransactionsHistoryPage> createState() =>
      _TransactionsHistoryPageState();
}

class _TransactionsHistoryPageState extends State<TransactionsHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  String _selectedType = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    _loadTransactions();
  }

  void _onTabChanged() {
    final types = ['all', 'purchase', 'spending', 'bonus'];
    setState(() {
      _selectedType = types[_tabController.index];
    });
    _loadTransactions();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    final walletProvider = GetIt.I<WalletProvider>();
    await walletProvider.fetchTransactions(type: _selectedType);
  }

  Future<void> _loadMoreTransactions() async {
    final walletProvider = GetIt.I<WalletProvider>();
    if (!walletProvider.hasMoreTransactions) return;
    await walletProvider.fetchTransactions(
      type: _selectedType,
      loadMore: true,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = GetIt.I<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des transactions'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Toutes'),
            Tab(text: 'Achats'),
            Tab(text: 'Dépenses'),
            Tab(text: 'Bonus'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildStatsCard(walletProvider),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: walletProvider.transactions,
              builder: (context, value, child) {
                if (value.isLoading && !value.hasNotNullData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (value.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          value.errorModel?.error ?? 'Erreur de chargement',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTransactions,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                if (!value.hasNotNullData || value.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune transaction',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final transactions = value.data!;

                return RefreshIndicator(
                  onRefresh: _loadTransactions,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length + (value.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == transactions.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final transaction = transactions[index];
                      return _TransactionCard(transaction: transaction);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(WalletProvider walletProvider) {
    return ValueListenableBuilder(
      valueListenable: walletProvider.stats,
      builder: (context, value, child) {
        if (!value.hasNotNullData) {
          return const SizedBox.shrink();
        }

        final stats = value.data!;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[900]!],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    label: 'Total acheté',
                    value: '${stats.totalAmountPurchased} FCFA',
                    icon: Icons.arrow_downward,
                    color: Colors.green[300]!,
                  ),
                  _StatItem(
                    label: 'Total dépensé',
                    value: '${stats.totalAmountSpent} FCFA',
                    icon: Icons.arrow_upward,
                    color: Colors.red[300]!,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    label: 'Crédits gagnés',
                    value: '${stats.totalCreditsEarned}',
                    icon: Icons.stars,
                    color: Colors.amber[300]!,
                  ),
                  _StatItem(
                    label: 'Crédits utilisés',
                    value: '${stats.totalCreditsSpent}',
                    icon: Icons.shopping_cart,
                    color: Colors.orange[300]!,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final CreditTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPurchase = transaction.isPurchase;
    final isBonus = transaction.isBonus;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isPurchase
                ? Colors.green[50]
                : isBonus
                    ? Colors.amber[50]
                    : Colors.red[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isPurchase
                ? Icons.add_circle
                : isBonus
                    ? Icons.card_giftcard
                    : Icons.remove_circle,
            color: isPurchase
                ? Colors.green[700]
                : isBonus
                    ? Colors.amber[700]
                    : Colors.red[700],
          ),
        ),
        title: Text(
          transaction.description ?? _getDefaultDescription(transaction.type),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy • HH:mm').format(transaction.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (transaction.reference != null) ...[
              const SizedBox(height: 2),
              Text(
                'Réf: ${transaction.reference}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isPurchase || isBonus ? '+' : '-'}${transaction.credits}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPurchase
                    ? Colors.green[700]
                    : isBonus
                        ? Colors.amber[700]
                        : Colors.red[700],
              ),
            ),
            Text(
              'crédits',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (transaction.amount > 0) ...[
              const SizedBox(height: 2),
              Text(
                '${transaction.amount} FCFA',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDefaultDescription(String type) {
    switch (type) {
      case 'purchase':
        return 'Achat de crédits';
      case 'spending':
      case 'expense':
        return 'Dépense de crédits';
      case 'bonus':
        return 'Bonus reçu';
      default:
        return 'Transaction';
    }
  }
}
