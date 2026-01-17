import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/pricing.dart';
import 'package:super_up/app/modules/annonces/providers/wallet_provider.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/purchase_credits_page.dart';
import 'package:super_up_core/super_up_core.dart';

class PackagesListPage extends StatefulWidget {
  const PackagesListPage({super.key});

  @override
  State<PackagesListPage> createState() => _PackagesListPageState();
}

class _PackagesListPageState extends State<PackagesListPage> {
  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    final walletProvider = GetIt.I<WalletProvider>();
    await walletProvider.fetchPricing();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = GetIt.I<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forfaits de crédits'),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: walletProvider.pricing,
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (value.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    value.errorModel?.error ?? 'Erreur de chargement',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadPackages,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (!value.hasNotNullData || value.data!.packages.isEmpty) {
            return const Center(
              child: Text('Aucun forfait disponible'),
            );
          }

          final packages = value.data!.packages;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return _PackageCard(
                package: package,
                onTap: () {
                  context.toPage(
                    PurchaseCreditsPage(
                      mode: PurchaseMode.byPackage,
                      selectedPackage: package,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.toPage(const PurchaseCreditsPage());
        },
        icon: const Icon(Icons.add),
        label: const Text('Achat personnalisé'),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final CreditPackage package;
  final VoidCallback onTap;

  const _PackageCard({
    required this.package,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasBonus = package.bonusCredits > 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: hasBonus
                ? LinearGradient(
                    colors: [
                      Colors.blue[700]!,
                      Colors.purple[700]!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      package.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: hasBonus ? Colors.white : null,
                      ),
                    ),
                  ),
                  if (hasBonus)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${package.bonusCredits}',
                            style: const TextStyle(
                              color: Colors.white,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${package.credits} crédits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: hasBonus ? Colors.white : Colors.grey[700],
                        ),
                      ),
                      if (hasBonus) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Bonus: +${package.bonusCredits} crédits',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${package.amount}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: hasBonus ? Colors.white : Colors.blue[700],
                        ),
                      ),
                      Text(
                        'FCFA',
                        style: TextStyle(
                          fontSize: 14,
                          color: hasBonus ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (hasBonus) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Total: ${package.totalCredits} crédits',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
