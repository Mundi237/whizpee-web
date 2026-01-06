// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_up_core/super_up_core.dart';

enum STextFieldState { normal, focused, error, success, disabled }

class STextFiled extends StatefulWidget {
  final String textHint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool obscureText;
  final bool autofocus;
  final int? maxLength;
  final int maxLines;
  final int? minLines;
  final bool autocorrect;
  final Widget? prefix;
  final Widget? suffix;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;
  final String? successText;
  final bool enabled;
  final FocusNode? focusNode;

  const STextFiled({
    super.key,
    required this.textHint,
    this.controller,
    this.inputType,
    this.prefix,
    this.suffix,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onTap,
    this.autofocus = false,
    this.autocorrect = true,
    this.obscureText = false,
    this.validator,
    this.errorText,
    this.successText,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<STextFiled> createState() => _STextFiledState();
}

class _STextFiledState extends State<STextFiled>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _validationError;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _obscurePassword = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (!_isFocused && widget.validator != null) {
      _validate();
    }
  }

  void _validate() {
    final value = widget.controller?.text;
    final error = widget.validator?.call(value);
    if (error != null && error != _validationError) {
      HapticFeedback.lightImpact();
      _shakeController.forward(from: 0);
    }
    setState(() {
      _validationError = error;
    });
  }

  STextFieldState get _currentState {
    if (!widget.enabled) return STextFieldState.disabled;
    if (widget.errorText != null || _validationError != null) {
      return STextFieldState.error;
    }
    if (widget.successText != null) return STextFieldState.success;
    if (_isFocused) return STextFieldState.focused;
    return STextFieldState.normal;
  }

  Color _getBorderColor(BuildContext context) {
    final isDark = context.isDark;
    switch (_currentState) {
      case STextFieldState.error:
        return isDark ? Colors.red.shade300 : Colors.red.shade700;
      case STextFieldState.success:
        return isDark ? Colors.green.shade300 : Colors.green.shade700;
      case STextFieldState.focused:
        return isDark ? Colors.blue.shade300 : Colors.blue.shade700;
      case STextFieldState.disabled:
        return isDark ? Colors.white12 : Colors.grey.shade300;
      case STextFieldState.normal:
        return isDark ? Colors.white24 : Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shakeAnimation.value, 0),
        child: child,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isFocused && widget.enabled
                  ? [
                      BoxShadow(
                        color: _getBorderColor(context).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              enabled: widget.enabled,
              focusNode: _focusNode,
              maxLength: widget.maxLength,
              minLines: widget.minLines,
              autocorrect: widget.autocorrect,
              autofocus: widget.autofocus,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              onChanged: (value) {
                widget.onChanged?.call(value);
                if (_validationError != null) {
                  _validate();
                }
              },
              controller: widget.controller,
              keyboardType: widget.inputType,
              onTap: widget.onTap,
              obscureText: _obscurePassword,
              style: TextStyle(
                fontSize: 16,
                color: widget.enabled
                    ? (isDark ? Colors.white.withOpacity(0.87) : Colors.black87)
                    : (isDark ? Colors.white38 : Colors.black38),
              ),
              decoration: InputDecoration(
                labelText: widget.textHint,
                labelStyle: TextStyle(
                  color: _getBorderColor(context),
                ),
                floatingLabelStyle: TextStyle(
                  color: _getBorderColor(context),
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: widget.prefix,
                suffixIcon: _buildSuffixIcon(),
                counterText: '',
                filled: true,
                fillColor: widget.enabled
                    ? (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50)
                    : (isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _getBorderColor(context), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _getBorderColor(context), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _getBorderColor(context), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          if (widget.errorText != null || _validationError != null) ...[
            const SizedBox(height: 6),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 14,
                    color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.errorText ?? _validationError ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.red.shade300 : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (widget.successText != null) ...[
            const SizedBox(height: 6),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: isDark ? Colors.green.shade300 : Colors.green.shade700,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.successText!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.green.shade300 : Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            key: ValueKey(_obscurePassword),
          ),
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      );
    }
    return widget.suffix;
  }
}
