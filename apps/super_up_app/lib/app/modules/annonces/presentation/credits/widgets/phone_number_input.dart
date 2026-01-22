import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_up_core/super_up_core.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? selectedProvider;
  final Function(String?)? onProviderDetected;

  const PhoneNumberInput({
    super.key,
    required this.controller,
    this.selectedProvider,
    this.onProviderDetected,
  });

  String? _detectProvider(String phoneNumber) {
    if (phoneNumber.isEmpty) return null;

    // MTN prefixes: 650-654, 67X, 68X
    if (phoneNumber.startsWith('650') ||
        phoneNumber.startsWith('651') ||
        phoneNumber.startsWith('652') ||
        phoneNumber.startsWith('653') ||
        phoneNumber.startsWith('654') ||
        phoneNumber.startsWith('67') ||
        phoneNumber.startsWith('68')) {
      return 'mtn';
    }

    // Orange prefixes: 655-659, 69X
    if (phoneNumber.startsWith('655') ||
        phoneNumber.startsWith('656') ||
        phoneNumber.startsWith('657') ||
        phoneNumber.startsWith('658') ||
        phoneNumber.startsWith('659') ||
        phoneNumber.startsWith('69')) {
      return 'orange';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final providerName = selectedProvider == 'orange'
        ? 'Orange Money'
        : selectedProvider == 'mtn'
            ? 'MTN MoMo'
            : 'Mobile Money';

    final hintText =
        selectedProvider == 'orange' ? '69X XX XX XX' : '67X XX XX XX';
    final providerColor = selectedProvider == 'orange'
        ? Colors.orange.shade600
        : selectedProvider == 'mtn'
            ? Colors.yellow.shade600
            : AppTheme.primaryGreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.phone_android_rounded,
              color: providerColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Numéro de téléphone',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          onChanged: (value) {
            final detected = _detectProvider(value);
            if (detected != null && onProviderDetected != null) {
              onProviderDetected!(detected);
            }
          },
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            labelText: 'Numéro de téléphone',
            labelStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              Icons.phone_rounded,
              color: providerColor,
            ),
            prefixText: '+237 ',
            prefixStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: providerColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.red.shade600,
                width: 2,
              ),
            ),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez entrer votre numéro';
            }
            if (value.length != 9) {
              return 'Le numéro doit contenir 9 chiffres';
            }
            // Validation automatique basée sur le numéro
            final detectedProvider = _detectProvider(value);
            if (detectedProvider == null) {
              return 'Numéro invalide (doit commencer par 650-654, 655-659, 67X, 68X ou 69X)';
            }

            // Vérifier la cohérence si un provider est sélectionné
            if (selectedProvider != null &&
                selectedProvider != detectedProvider) {
              final providerName = detectedProvider == 'mtn' ? 'MTN' : 'Orange';
              return 'Ce numéro appartient à $providerName';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                providerColor.withValues(alpha: 0.15),
                providerColor.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: providerColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: providerColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selectedProvider != null
                      ? 'Numéro $providerName détecté automatiquement'
                      : 'Le mode de paiement sera détecté automatiquement',
                  style: TextStyle(
                    fontSize: 12,
                    color: providerColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
