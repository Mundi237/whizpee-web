import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/widgets/s_app_button.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/package_transaction.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/annonces/presentation/wallet_transactions/succes_page.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
// import 'package:super_up_core/super_up_core.dart';

class RecapPage extends StatelessWidget {
  final Map<String, String> data;
  const RecapPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final CreditProvider creditProvider = GetIt.I<CreditProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text("Confirm"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${data['title'] ?? "Transfert Credit amount"}"),
            SizedBox(height: 5),
            Text(
              data['amount'] ?? "12500 U",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.all(0),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    data['provider_image'] ?? "assets/momo.png",
                    height: 50,
                    width: 75,
                  ),
                ),
                title: Text(data['provider_name'] ?? "MTN Mobile Money"),
                subtitle: Text(data['phone'] ?? "+237673132228"),
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    RowListile(
                      title: "Amount",
                      value: data['amount'] ?? "${12500} U",
                    ),
                    Divider(),
                    RowListile(
                      title: "Transaction fees",
                      value: data['fees'] ?? "10%",
                    ),
                    Divider(),
                    RowListile(
                      title: "Service fees",
                      value: data['service_fees'] ?? "10%",
                    ),
                    Divider(),
                    RowListile(
                      title: "Phone number",
                      value: data['phone'] ?? "+237 673132228",
                    ),
                    Divider(),
                    RowListile(
                      title: "Total Amount",
                      value: data['amount'] ?? "${10000} XAF",
                    ),
                    Divider(),
                    RowListile(
                      title: "Payment methode",
                      value: data['provider_name'] ?? "MTN MOBILE MONEY",
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 100),
            ValueListenableBuilder<AppState<PackageTransaction>>(
                valueListenable: creditProvider.packageTransaction,
                builder: (context, value, child) {
                  return AppButton(
                    text: "Valider",
                    isLoading: value.isLoading,
                    onPressed: () async {
                      if (data['type'] != 'purchase') {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.85),
                          barrierDismissible: false,
                          builder: (context) => Dialog(
                            insetPadding: EdgeInsets.all(0),
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            child: SuccesPage(
                              data: {'amount': "12000 U"},
                            ),
                          ),
                        );
                        return;
                      }
                      await creditProvider.purchasePackage(onsuCess: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.85),
                          barrierDismissible: false,
                          builder: (context) => Dialog(
                            insetPadding: EdgeInsets.all(0),
                            backgroundColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            child: SuccesPage(
                              data: {
                                'amount':
                                    "${creditProvider.selectedPackage?.amount.toInt()} XAF",
                                "type": "Packages purchase"
                              },
                            ),
                          ),
                        ).then((_) {
                          Navigator.pop(context);
                        });
                      });
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}

class RowListile extends StatelessWidget {
  final String title;
  final String value;
  const RowListile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.title1TextColor,
          ),
        )
      ],
    );
  }
}
