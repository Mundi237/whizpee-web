// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/theme/app_theme_manager.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';

class BoostAnnonceBottomSheet extends StatefulWidget {
  const BoostAnnonceBottomSheet({super.key});

  @override
  State<BoostAnnonceBottomSheet> createState() =>
      _BoostAnnonceBottomSheetState();
}

class _BoostAnnonceBottomSheetState extends State<BoostAnnonceBottomSheet> {
  int selectedDays = 3;
  @override
  Widget build(BuildContext context) {
    final BoostController controller = GetIt.I.get<BoostController>();
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        // color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Titre
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Durée du boost',
              style: TextStyle(
                // color: white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Affichage de la valeur sélectionnée
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      // color: primary,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '$selectedDays ${selectedDays <= 1 ? "jour" : "jours"}',
                    style: const TextStyle(
                      // color: white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Slider(
                  value: selectedDays.toDouble(),
                  min: 0,
                  max: 30,
                  divisions: 30,
                  // activeColor: primary,
                  // thumbColor: white,
                  label:
                      '$selectedDays ${selectedDays <= 1 ? "jour" : "jours"}',
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value.round();
                    });
                  },
                ),

                // Indicateurs min/max
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0 jour',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '30 jours',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Suggestions rapides
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggestions populaires',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [1, 3, 7, 14, 30].map((days) {
                    final isSelected = selectedDays == days;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDays = days;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          // color: isSelected ? primary : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              // color: isSelected ? primary : Colors.grey.shade600,
                              ),
                        ),
                        child: Text(
                          '$days ${days <= 1 ? "jour" : "jours"}',
                          style: TextStyle(
                            // color: isSelected ? white : Colors.grey.shade300,
                            color: Colors.grey.shade300,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Boutons d'action
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        // color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ValueListenableBuilder(
                      valueListenable: controller.boostsState,
                      builder: (_, state, __) {
                        return ElevatedButton(
                          onPressed: () async {
                            final cntr = GetIt.I.get<AnnonceController>();
                            await controller.boosAnnonce(selectedDays, context);
                            if (state.hasNotNullData) {
                              cntr
                                  .publishAnnonce(
                                controller.selectedAnnonce!.id,
                              )
                                  .whenComplete(() {
                                cntr.getAnnonces(true);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            // backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state.isLoading) ...[
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      // color: white,
                                      ),
                                ),
                                SizedBox(width: 15)
                              ],
                              Text(
                                'Booster ${/*(controller.selectedBoost!.price * selectedDays).toInt()*/ "Gratuitement"} XAF',
                                style: const TextStyle(
                                  // color: white,
                                  // fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
