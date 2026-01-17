// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_up_core/super_up_core.dart';

class CustomTextField extends StatefulWidget {
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() => _isFocused = hasFocus);
    if (hasFocus) {
      _animationController.forward();
      HapticFeedback.selectionClick();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _isFocused
                        ? AppTheme.primaryGreen
                        : Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (_isFocused) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: _onFocusChange,
          child: AnimatedBuilder(
            animation: _focusAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(
                          alpha: 0.08 + (0.04 * _focusAnimation.value)),
                      Colors.white.withValues(
                          alpha: 0.04 + (0.02 * _focusAnimation.value)),
                    ],
                  ),
                  border: Border.all(
                    color: _errorText != null
                        ? Colors.red.withValues(alpha: 0.5)
                        : _isFocused
                            ? AppTheme.primaryGreen.withValues(alpha: 0.6)
                            : Colors.white.withValues(
                                alpha: 0.15 + (0.1 * _focusAnimation.value)),
                    width: _isFocused ? 2 : 1,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 8 + (4 * _focusAnimation.value),
                      sigmaY: 8 + (4 * _focusAnimation.value),
                    ),
                    child: TextFormField(
                      controller: widget.controller,
                      onTap: () {
                        if (widget.onTap != null) {
                          HapticFeedback.lightImpact();
                          widget.onTap!();
                        }
                      },
                      onChanged: (value) {
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                        // Real-time validation
                        if (widget.validator != null) {
                          final error = widget.validator!(value);
                          if (error != _errorText) {
                            setState(() => _errorText = error);
                          }
                        }
                      },
                      validator: widget.validator,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: widget.maxLines,
                      keyboardType: widget.keyboardType,
                      readOnly: widget.readOnly,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        prefixIcon: widget.prefixText != null
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Center(
                                  widthFactor: 1,
                                  child: Text(
                                    widget.prefixText!,
                                    style: TextStyle(
                                      color: AppTheme.primaryGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 15,
                        ),
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: widget.maxLines > 1 ? 16 : 18,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        suffixIcon: widget.suffixIcon != null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: widget.suffixIcon,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.red.shade400,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _errorText!,
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
