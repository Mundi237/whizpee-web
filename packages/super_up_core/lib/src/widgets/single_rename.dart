// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/src/widgets/s_text_filed.dart';
import 'package:textless/textless.dart';

class VSingleRename extends StatefulWidget {
  final String appbarTitle;
  final String subTitle;
  final String? oldValue;
  final int? maxLength;
  final String? Function(String?)? validator;

  const VSingleRename({
    super.key,
    required this.appbarTitle,
    required this.subTitle,
    this.oldValue,
    this.maxLength,
    this.validator,
  });

  @override
  State<VSingleRename> createState() => _VSingleRenameState();
}

class _VSingleRenameState extends State<VSingleRename> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasChanges = false;
  bool _isValid = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.oldValue != null) {
      _controller.text = widget.oldValue!;
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final newValue = _controller.text.trim();
    final oldValue = widget.oldValue?.trim() ?? '';
    final hasChanges = newValue != oldValue;
    
    String? error;
    if (widget.validator != null) {
      error = widget.validator!(_controller.text);
    }
    
    if (_hasChanges != hasChanges || _errorText != error) {
      setState(() {
        _hasChanges = hasChanges;
        _isValid = error == null;
        _errorText = error;
      });
    }
  }

  void _handleSave() {
    if (_controller.text.trim().isEmpty) {
      HapticFeedback.heavyImpact();
      setState(() {
        _errorText = 'Please enter a value';
        _isValid = false;
      });
      return;
    }
    
    if (!_isValid) {
      HapticFeedback.heavyImpact();
      return;
    }
    
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _hasChanges && _isValid && _controller.text.trim().isNotEmpty;
    
    return Scaffold(
      appBar: AppBar(
        title: widget.appbarTitle.text,
        actions: [
          AnimatedOpacity(
            opacity: canSave ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: canSave ? _handleSave : null,
              child: Row(
                children: [
                  if (canSave)
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                    ),
                  const SizedBox(width: 4),
                  Text(
                    S.of(context).ok,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.blue.shade300
                          : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.subTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              STextFiled(
                autocorrect: true,
                inputType: TextInputType.text,
                autofocus: true,
                controller: _controller,
                focusNode: _focusNode,
                textHint: widget.oldValue ?? 'Enter new value',
                maxLength: widget.maxLength,
                errorText: _errorText,
                validator: widget.validator,
              ),
              const SizedBox(height: 16),
              if (_controller.text.isNotEmpty) ...[
                AnimatedOpacity(
                  opacity: _hasChanges ? 1.0 : 0.6,
                  duration: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      Icon(
                        _hasChanges ? Icons.edit : Icons.check,
                        size: 16,
                        color: _hasChanges
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? Colors.orange.shade300
                                : Colors.orange.shade700)
                            : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.green.shade300
                                : Colors.green.shade700),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _hasChanges
                              ? 'Unsaved changes'
                              : 'No changes',
                          style: TextStyle(
                            fontSize: 13,
                            color: _hasChanges
                                ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.orange.shade300
                                    : Colors.orange.shade700)
                                : (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.green.shade300
                                    : Colors.green.shade700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    widget.maxLength != null
                        ? '${_controller.text.length}/${widget.maxLength}'
                        : '${_controller.text.length} characters',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white38
                          : Colors.black38,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
