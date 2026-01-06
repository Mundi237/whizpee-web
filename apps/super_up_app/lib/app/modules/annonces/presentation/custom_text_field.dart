// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? prefixText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.prefixText,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: white.withOpacity(0.5),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(color: white),
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
                        child: Text(prefixText!),
                      ),
                    ),
                  )
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
