import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';
import 'package:super_up/app/modules/annonces/presentation/boost_annonce_bootom_sheet.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces, Boost;

class BoostAnnoncementScreen extends StatefulWidget {
  final Annonces annonces;
  const BoostAnnoncementScreen({super.key, required this.annonces});

  @override
  State<BoostAnnoncementScreen> createState() => _BoostAnnoncementScreenState();
}

class _BoostAnnoncementScreenState extends State<BoostAnnoncementScreen> {
  // bool _isWaitingForPayment = false;
  // bool? _isSuccess;
  TextEditingController titleController = TextEditingController();

  @override
  initState() {
    final BoostController controller = GetIt.I.get<BoostController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getBoosts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BoostController controller = GetIt.I.get<BoostController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            // color: white
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Booster l\'annonce',
          style: TextStyle(
            // color: white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder<AppState<List<Boost>>>(
            valueListenable: controller.boostsListState,
            builder: (context, state, child) {
              if (state.isLoading) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: 200),
                      CircularProgressIndicator(
                          // color: primary,
                          ),
                    ],
                  ),
                );
              }
              if (state.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 200),
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
                            controller.getBoosts();
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 30,
                          ))
                    ],
                  ),
                );
              }
              if ((state.data ?? []).isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 200.0),
                    child: Column(
                      children: [
                        Text(
                          'Aucune annonce ne correspond à vos filtres.',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                            onPressed: () {
                              controller.getBoosts();
                            },
                            icon: Icon(
                              Icons.refresh,
                              size: 30,
                            ))
                      ],
                    ),
                  ),
                );
              }

              final List<Boost> boosts = state.data!;
              return ListView.builder(
                itemCount: boosts.length,
                itemBuilder: (listContext, index) {
                  final boost = boosts[index];
                  return BuoostComponent(
                    boost: boost,
                    onTap: _showBoostDayNumbers,
                  );
                },
              );
            }),
      ),
    );
  }

  void _showBoostDayNumbers(Boost boost) {
    final BoostController controller = GetIt.I.get<BoostController>();
    controller.changeBoost(boost);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (builderContext) {
        return BoostAnnonceBottomSheet();
        // return StatefulBuilder(
        //   builder: (context, setState) {

        //   },
        // );
      },
    );
  }

  void showSuccessPaymentBottom() {}
  // void _showPaymentOptions() {
  //   final BoostController controller = GetIt.I.get<BoostController>();
  //   if (controller.selectedBoost == null) return;
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     isDismissible: !_isWaitingForPayment,
  //     builder: (builderContext) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return Container(
  //           width: double.infinity,
  //           height: 290,
  //           decoration: const BoxDecoration(
  //             color: bgColor,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20),
  //               topRight: Radius.circular(20),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: _isWaitingForPayment
  //                 ? PaymentWaittingComponent(
  //                     title:
  //                         'Composez le #150# sur votre téléphone pour procéder au paiement',
  //                   )
  //                 : _isSuccess != null
  //                     ? StatusPaymentComponent(
  //                         isSuccess: _isSuccess ?? false,
  //                       )
  //                     : Column(
  //                         children: [
  //                           Text(
  //                             'Paiement de',
  //                             style: TextStyle(
  //                               color: white.withValues(alpha: 0.5),
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           Text(
  //                             formatToFCFA(selectedDays *
  //                                 (controller.selectedBoost?.price ?? 0)),
  //                             style: const TextStyle(
  //                               color: white,
  //                               fontSize: 32,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           const Spacer(),
  //                           _buildTextField(
  //                             controller: titleController,
  //                             hint: 'Numéro mobile money',
  //                             label: '',
  //                             prefixText: '+237 ',
  //                           ),
  //                           const SizedBox(height: 20),
  //                           Row(
  //                             children: [
  //                               Expanded(
  //                                 child: ElevatedButton(
  //                                   onPressed: () async {
  //                                     setState(() {
  //                                       _isWaitingForPayment = true;
  //                                     });
  //                                     // Navigator.of(context).pop();
  //                                     // Navigator.of(context).pop();
  //                                     // Navigator.of(context).pop();
  //                                     // Navigator.of(context).pop();
  //                                   },
  //                                   style: ElevatedButton.styleFrom(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         vertical: 16),
  //                                     backgroundColor: primary,
  //                                     shape: RoundedRectangleBorder(
  //                                       borderRadius: BorderRadius.circular(12),
  //                                     ),
  //                                   ),
  //                                   child: const Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.monetization_on,
  //                                         size: 28,
  //                                         color: Colors.white,
  //                                       ),
  //                                       SizedBox(width: 10),
  //                                       Text(
  //                                         'Payer',
  //                                         style: TextStyle(
  //                                           color: white,
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.bold,
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           const SizedBox(height: 30),
  //                         ],
  //                       ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? prefixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            // color: white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onTap: onTap,
          style: const TextStyle(
              // color: white
              ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixText != null
                ? SizedBox(
                    width: 16,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(prefixText),
                    )))
                : null,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.grey.shade900,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class PaymentWaittingComponent extends StatelessWidget {
  final String title;
  const PaymentWaittingComponent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ]),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              // color: white
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class StatusPaymentComponent extends StatelessWidget {
  final bool isSuccess;
  const StatusPaymentComponent({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSuccess ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              isSuccess ? Icons.check : Icons.close,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isSuccess ? 'Le paiement a réussi' : 'Le paiement a échoué',
          style: TextStyle(
            // color: white.withValues(alpha: 0.7),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class BuoostComponent extends StatelessWidget {
  final void Function(Boost boost) onTap;
  const BuoostComponent({super.key, required this.boost, required this.onTap});

  final Boost boost;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        boost.title,
        style: const TextStyle(
          // color: white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        boost.description,
        style: const TextStyle(color: Colors.white70),
      ),
      onTap: () {
        onTap(boost);
      },
    );
  }
}

// final List<BoostOption> _boostOptions = [
//   BoostOption(
//     level: 'TOP',
//     description: 'Soyez en haut, restez visible. Visibilité maximale.',
//     amount: 15000,
//   ),
//   BoostOption(
//     level: 'VVIP',
//     description: 'Un traitement royal pour votre annonce.',
//     amount: 10000,
//   ),
//   BoostOption(
//     level: 'PREMIUM',
//     description: 'Encadré spécial + badge + remontée auto.',
//     amount: 5000,
//   ),
//   BoostOption(
//     level: 'VIP',
//     description: 'Badge VIP + remontée régulière.',
//     amount: 2500,
//   ),
//   BoostOption(
//     level: 'GOLD',
//     description: 'Badge doré, excellent rapport qualité/prix.',
//     amount: 1000,
//   ),
//   BoostOption(
//     level: 'SILVER',
//     description: 'Gratuit, affiché sans boost.',
//     amount: 500,
//   ),
// ];

String formatToFCFA(num value, {bool showCurrency = true, int decimals = 1}) {
  if (value == 0) {
    return showCurrency ? "0 FCFA" : "0";
  }

  String suffix = "";
  double formattedValue = value.toDouble();

  // Déterminer le suffixe et diviser la valeur
  if (value.abs() >= 1000000000) {
    // Milliards
    formattedValue = value / 1000000000;
    suffix = "B";
  } else if (value.abs() >= 1000000) {
    // Millions
    formattedValue = value / 1000000;
    suffix = "M";
  } else if (value.abs() >= 1000) {
    // Milliers
    formattedValue = value / 1000;
    suffix = "k";
  }

  // Formater le nombre
  String formattedString;

  if (suffix.isNotEmpty) {
    // Pour les nombres avec suffixe, utiliser les décimales si nécessaire
    if (formattedValue == formattedValue.roundToDouble()) {
      // Nombre entier
      formattedString = formattedValue.round().toString();
    } else {
      // Nombre décimal
      formattedString = formattedValue.toStringAsFixed(decimals);
      // Supprimer les zéros inutiles à la fin
      formattedString = formattedString.replaceAll(RegExp(r'\.?0+$'), '');
    }
    formattedString += suffix;
  } else {
    // Pour les nombres < 1000, ajouter des espaces comme séparateurs de milliers
    formattedString = _addThousandSeparators(value.round());
  }

  return showCurrency ? "$formattedString FCFA" : formattedString;
}

/// Ajoute des espaces comme séparateurs de milliers
/// Exemple: 1234567 → "1 234 567"
String _addThousandSeparators(int value) {
  String str = value.abs().toString();
  String result = '';

  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      result += ' ';
    }
    result += str[i];
  }

  return value < 0 ? '-$result' : result;
}

/// Version alternative avec plus d'options de personnalisation
String formatToFCFAAdvanced(
  num value, {
  bool showCurrency = true,
  int decimals = 1,
  bool useCommaAsDecimalSeparator = true,
  String currencySymbol = "FCFA",
  bool currencyBefore = false,
}) {
  if (value == 0) {
    String currency = showCurrency
        ? (currencyBefore ? "$currencySymbol " : " $currencySymbol")
        : "";
    return currencyBefore ? "${currency}0" : "0$currency";
  }

  String suffix = "";
  double formattedValue = value.toDouble();

  // Déterminer le suffixe et diviser la valeur
  if (value.abs() >= 1000000000) {
    formattedValue = value / 1000000000;
    suffix = "B";
  } else if (value.abs() >= 1000000) {
    formattedValue = value / 1000000;
    suffix = "M";
  } else if (value.abs() >= 1000) {
    formattedValue = value / 1000;
    suffix = "k";
  }

  // Formater le nombre
  String formattedString;

  if (suffix.isNotEmpty) {
    if (formattedValue == formattedValue.roundToDouble()) {
      formattedString = formattedValue.round().toString();
    } else {
      formattedString = formattedValue.toStringAsFixed(decimals);
      formattedString = formattedString.replaceAll(RegExp(r'\.?0+$'), '');

      // Remplacer le point par une virgule si demandé
      if (useCommaAsDecimalSeparator) {
        formattedString = formattedString.replaceAll('.', ',');
      }
    }
    formattedString += suffix;
  } else {
    formattedString = _addThousandSeparators(value.round());
  }

  // Ajouter la devise
  if (showCurrency) {
    if (currencyBefore) {
      return "$currencySymbol $formattedString";
    } else {
      return "$formattedString $currencySymbol";
    }
  }

  return formattedString;
}
