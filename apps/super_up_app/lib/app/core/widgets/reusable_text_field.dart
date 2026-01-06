// Reusable Custom TextField
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool requestFocus;
  final String? Function(String?)? validator;
  final void Function()? onSuffixIconTap;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const AppTextField({
    super.key,
    this.controller,
    this.requestFocus = false,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onSuffixIconTap,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscurePassword = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscureText;
    if (widget.requestFocus) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscurePassword,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      focusNode: focusNode,
      onTap: widget.onTap,
      style: TextStyle(color: theme.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: TextStyle(color: theme.textSecondary),
        labelStyle: TextStyle(color: theme.textSecondary),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: theme.textSecondary)
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : const SizedBox.shrink(),
        filled: true,
        fillColor: theme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryGreen),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.error),
        ),
      ),
      validator: widget.validator,
    );
  }
}
