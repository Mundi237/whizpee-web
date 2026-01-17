import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? selectedProvider;

  const PhoneNumberInput({
    super.key,
    required this.controller,
    this.selectedProvider,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone',
        hintText:
            selectedProvider == 'orange' ? '69X XX XX XX' : '67X XX XX XX',
        prefixIcon: const Icon(Icons.phone),
        prefixText: '+237 ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        helperText:
            'Entrez votre numéro ${selectedProvider == 'orange' ? 'Orange Money' : selectedProvider == 'mtn' ? 'MTN MoMo' : 'Mobile Money'}',
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
        if (selectedProvider == 'orange') {
          final validOrangePrefixes = ['69', '655', '656', '657', '658', '659'];
          final isValid =
              validOrangePrefixes.any((prefix) => value.startsWith(prefix));
          if (!isValid) {
            return 'Numéro Orange invalide (69x, 655-659)';
          }
        }
        if (selectedProvider == 'mtn') {
          final validMtnPrefixes = ['67', '650', '651', '652', '653', '654'];
          final isValid =
              validMtnPrefixes.any((prefix) => value.startsWith(prefix));
          if (!isValid) {
            return 'Numéro MTN invalide (67x, 650-654)';
          }
        }
        return null;
      },
    );
  }
}
