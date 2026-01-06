import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:super_up/app/core/widgets/s_app_button.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/package.dart';
import 'package:super_up/app/modules/annonces/presentation/payment_page.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
import 'package:super_up_core/super_up_core.dart';

class CreditPayBottomSheet extends StatelessWidget {
  const CreditPayBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final CreditProvider creditProvider = GetIt.I<CreditProvider>();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // small handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Acheter des crédits Whizpee',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // description
          const SizedBox(height: 5),
          const Text(
            'Sélectionnez un forfait de crédits pour publier vos annonces sur Whizpee.',
          ),
          const SizedBox(height: 15),

          ValueListenableBuilder<AppState<List<Package>>>(
            valueListenable: creditProvider.packagesList,
            builder: (context, state, child) {
              if (state.isLoading) {
                return Column(
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(height: 30),
                  ],
                );
              }
              if (state.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          state.errorModel!.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red.shade500, fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      IconButton(
                          onPressed: () {
                            creditProvider.fetchPackages();
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 30,
                          )),
                      SizedBox(height: 30),
                    ],
                  ),
                );
              }
              if ((state.data ?? []).isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: [
                        Text(
                          'Aucun forfait de crédits disponible.',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            creditProvider.fetchPackages();
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 30,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              }
              final List<Package> packages = state.data ?? [];

              return Column(children: [
                ...List.generate(packages.length, (index) {
                  final package = packages[index];
                  return PackageItem(
                    package: package,
                  );
                }),
                SizedBox(height: 20),
                // AppButton(text: "Continue", onPressed: () {})
              ]);
            },
          ),

          /// packages list
        ],
      ),
    );
  }
}

class PackageItem extends StatelessWidget {
  const PackageItem(
      {super.key, required this.package, this.isSelected = false});

  final Package package;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: () {
          context.toPage(PaymentPage(package: package));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text("${package.name} (${package.credits} crédits)"),
        subtitle: Text(package.description),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${package.amount.toInt()} XAF",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class NewPackgeItems extends StatelessWidget {
  const NewPackgeItems({
    super.key,
    required this.package,
    this.isSelected = false,
    this.onTap,
  });
  final Function(Package package)? onTap;
  final Package package;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(package);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 275),
        transformAlignment: Alignment.bottomCenter,
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.iconGrayColor : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.iconGrayColor.withOpacity(0.3)
                      : null,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Payer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 0.9,
                        color: isSelected ? AppColors.typingColor : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${package.amount.toInt()} XAF ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              isSelected ? AppColors.typingColor : Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      package.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 0.9,
                        color: isSelected ? AppColors.typingColor : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 5)
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 275),
              transformAlignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.iconGrayColor
                    : Colors.grey.shade700.withOpacity(0.7),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              height: 50,
              child: Center(
                child: Text(
                  "${package.credits} \nCredits",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 0.9,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
