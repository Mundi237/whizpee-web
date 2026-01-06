import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
// import 'package:pinput/pinput.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/widgets/s_app_button.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/package.dart';
import 'package:super_up/app/modules/annonces/datas/models/package_transaction.dart';
import 'package:super_up/app/modules/annonces/presentation/wallet_transactions/recap_page.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
import 'package:super_up_core/super_up_core.dart';

class PaymentPage extends StatefulWidget {
  final Package package;
  const PaymentPage({super.key, required this.package});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? provider;
  final TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? _validatePhoneNumber(String phone) {
    if (provider == 'mtn') {
      if (!mtnCamerounPattern.hasMatch(phone)) {
        return "Invalid MTN phone number";
      }
    } else if (provider == 'orange') {
      if (!orangeCamerounPattern.hasMatch(phone)) {
        return "Invalid Orange phone number";
      }
    }
    return null;
  }

  void _autoSelectProvider() {
    if (phoneController.text.length == 9) {
      if (mtnCamerounPattern.hasMatch(phoneController.text)) {
        setState(() {
          provider = 'mtn';
        });
      } else if (orangeCamerounPattern.hasMatch(phoneController.text)) {
        setState(() {
          provider = 'orange';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final CreditProvider creditProvider = GetIt.I<CreditProvider>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            widget.package.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Méthodes de paiement",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.package.description),

              SizedBox(height: 20),
              // Orange Money
              InkWell(
                onTap: () {
                  setState(() {
                    provider = 'mtn';
                  });
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3),
                    child: Row(
                      children: [
                        Icon(
                          provider != 'mtn'
                              ? Icons.radio_button_off
                              : Icons.radio_button_checked,
                          color:
                              provider == 'mtn' ? AppTheme.primaryGreen : null,
                        ),
                        SizedBox(width: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/momo.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "MTN Mobile Money",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn().slideX(delay: 500.ms),
              InkWell(
                onTap: () {
                  setState(() {
                    provider = 'orange';
                  });
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3),
                    child: Row(
                      children: [
                        Icon(
                          provider != 'orange'
                              ? Icons.radio_button_off
                              : Icons.radio_button_checked,
                          color: provider == 'orange'
                              ? AppTheme.primaryGreen
                              : null,
                        ),
                        SizedBox(width: 5),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/om.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          "Orange Money",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn().slideX(delay: 600.ms),
              SizedBox(height: 20),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: S.of(context).phone,
                    hintText: S.of(context).phone,
                    prefixIcon: Icon(
                      PhosphorIcons.phone(
                        PhosphorIconsStyle.fill,
                      ),
                      color: colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                  ),
                  onChanged: (value) => _autoSelectProvider(),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return _validatePhoneNumber(value!);
                      //S.of(context).pleaseEnterYourName;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  autofocus: true,
                  maxLength: 9,
                ).animate().fadeIn().slideX(delay: 800.ms),
              ),
              Spacer(),
              ValueListenableBuilder<AppState<PackageTransaction>>(
                valueListenable: creditProvider.packageTransaction,
                builder: (context, value, child) {
                  return AppButton(
                    text: "Payer ${widget.package.amount.toInt()} XAF",
                    isLoading: value.isLoading,
                    customLoadingWidget: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    onPressed: () {
                      if (provider == null) {
                        VAppAlert.showErrorSnackBar(
                          context: context,
                          message:
                              "Veuillez sélectionner un fournisseur de paiement.",
                        );
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        creditProvider.selecTPackage(widget.package);
                        context.toPage(
                          RecapPage(
                            data: {
                              "amount": "${widget.package.amount} XAF",
                              "provider_name": provider == "mtn"
                                  ? "MTN Mobile Money"
                                  : "Orange Money",
                              "phone": phoneController.text,
                              "provider_image": provider == 'mtn'
                                  ? "assets/momo.png"
                                  : "assets/om.png",
                              'title':
                                  "Achat du pakcage ${widget.package.name}",
                              'type': "purchase"
                            },
                          ),
                        );
                        // creditProvider.purchasePackage(widget.package.id);
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ));
  }
}

RegExp mtnCamerounPattern = RegExp(r"^(\+?237)?6(5[0-4]|[78][0-9])[0-9]{6}$");
RegExp orangeCamerounPattern = RegExp(
    r"^(237)?((655|656|657|658|659|686|687|688|689)[0-9]{6}$|(69[0-9]{7})$)");
