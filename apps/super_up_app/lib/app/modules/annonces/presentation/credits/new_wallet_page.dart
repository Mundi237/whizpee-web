import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:super_up/app/modules/annonces/providers/wallet_provider.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/packages_list_page.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/purchase_credits_page.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/transactions_history_page.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/withdrawal_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class NewWalletPage extends StatefulWidget {
  const NewWalletPage({super.key});

  @override
  State<NewWalletPage> createState() => _NewWalletPageState();
}

class _NewWalletPageState extends State<NewWalletPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletProvider = GetIt.I<WalletProvider>();
      walletProvider.fetchBalance();
      walletProvider.fetchTransactionStats();
      walletProvider.fetchTransactions(type: 'all');
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = GetIt.I<WalletProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            walletProvider.fetchBalance(),
            walletProvider.fetchTransactionStats(),
            walletProvider.fetchTransactions(type: 'all'),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeader(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceCard(walletProvider),
                    const SizedBox(height: 20),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildStatsCard(walletProvider),
                    const SizedBox(height: 20),
                    _buildRecentTransactionsSection(walletProvider),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[700]!,
            Colors.purple[700]!,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              VCircleAvatar(
                radius: 30,
                vFileSource: VPlatformFile.fromUrl(
                  networkUrl: AppAuth.myProfile.baseUser.userImage,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mon Portefeuille',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppAuth.myProfile.baseUser.fullName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.toPage(const TransactionsHistoryPage());
                },
                icon: const Icon(Icons.history, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletProvider walletProvider) {
    return ValueListenableBuilder(
      valueListenable: walletProvider.balance,
      builder: (context, value, child) {
        if (value.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (value.hasError) {
          return Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    value.errorModel?.error ?? 'Erreur de chargement',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => walletProvider.fetchBalance(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        final balance = value.data;
        final credits = balance?.credits ?? 0;
        final totalPurchased = balance?.totalPurchased ?? 0;
        final totalSpent = balance?.totalSpent ?? 0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[800]!],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Solde disponible',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.stars, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            'Crédits',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$credits',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8, left: 8),
                      child: Text(
                        'crédits',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildBalanceInfo(
                        'Achetés',
                        totalPurchased,
                        Icons.add_circle_outline,
                        Colors.green[300]!,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBalanceInfo(
                        'Dépensés',
                        totalSpent,
                        Icons.remove_circle_outline,
                        Colors.red[300]!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceInfo(
      String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            label: 'Acheter',
            icon: Icons.add_circle,
            color: Colors.green,
            onTap: () => context.toPage(const PurchaseCreditsPage()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            label: 'Forfaits',
            icon: Icons.card_giftcard,
            color: Colors.blue,
            onTap: () => context.toPage(const PackagesListPage()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            label: 'Retirer',
            icon: Icons.arrow_circle_up,
            color: Colors.red,
            onTap: () => context.toPage(const WithdrawalPage()),
          ),
        ),
      ],
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

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistiques',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Transactions',
                        '${stats.totalTransactions}',
                        Icons.receipt_long,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Achats',
                        '${stats.totalPurchases}',
                        Icons.shopping_bag,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Dépenses',
                        '${stats.totalSpendings}',
                        Icons.payments,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Bonus',
                        '${stats.totalBonuses}',
                        Icons.card_giftcard,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.blue[700]),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection(WalletProvider walletProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transactions récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.toPage(const TransactionsHistoryPage());
              },
              child: const Text('Voir tout'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder(
          valueListenable: walletProvider.transactions,
          builder: (context, value, child) {
            if (value.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!value.hasNotNullData || value.data!.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long,
                            size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'Aucune transaction',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final recentTransactions = value.data!.take(5).toList();

            return Column(
              children: recentTransactions.map((transaction) {
                final isPurchase = transaction.isPurchase;
                final isBonus = transaction.isBonus;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPurchase
                          ? Colors.green[50]
                          : isBonus
                              ? Colors.amber[50]
                              : Colors.red[50],
                      child: Icon(
                        isPurchase
                            ? Icons.add
                            : isBonus
                                ? Icons.card_giftcard
                                : Icons.remove,
                        color: isPurchase
                            ? Colors.green[700]
                            : isBonus
                                ? Colors.amber[700]
                                : Colors.red[700],
                      ),
                    ),
                    title: Text(
                      transaction.description ?? 'Transaction',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm')
                          .format(transaction.createdAt),
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      '${isPurchase || isBonus ? '+' : '-'}${transaction.credits}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isPurchase
                            ? Colors.green[700]
                            : isBonus
                                ? Colors.amber[700]
                                : Colors.red[700],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
