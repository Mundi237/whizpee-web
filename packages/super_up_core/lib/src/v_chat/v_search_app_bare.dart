// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_translation/generated/l10n.dart';

class VSearchAppBare extends StatefulWidget {
  final VoidCallback onClose;
  final int delay;
  final Function(String value) onSearch;
  final bool requestFocus;
  final String searchLabel;

  const VSearchAppBare({
    super.key,
    required this.onClose,
    required this.searchLabel,
    this.delay = 500,
    required this.onSearch,
    this.requestFocus = true,
  });

  @override
  State<VSearchAppBare> createState() => _VSearchAppBareState();
}

class _VSearchAppBareState extends State<VSearchAppBare>
    with SingleTickerProviderStateMixin {
  Timer? _debounce;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late TextEditingController _searchController;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  void _onSearchTextChanged() {
    final shouldShow = _searchController.text.isNotEmpty;
    if (_showClearButton != shouldShow) {
      setState(() {
        _showClearButton = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AppBar(
        title: CupertinoSearchTextField(
          controller: _searchController,
          autofocus: widget.requestFocus,
          placeholder: widget.searchLabel,
          onChanged: onSearchChanged,
          onSubmitted: (t) {
            HapticFeedback.lightImpact();
            widget.onSearch(t);
          },
          suffixMode: OverlayVisibilityMode.editing,
          prefixInsets: const EdgeInsetsDirectional.only(start: 8),
          suffixInsets: const EdgeInsetsDirectional.only(end: 8),
        ),
        automaticallyImplyLeading: false,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: _showClearButton
                ? IconButton(
                    key: const ValueKey('clear'),
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      _searchController.clear();
                      widget.onSearch('');
                    },
                    tooltip: S.current.clear,
                  )
                : const SizedBox(key: ValueKey('empty'), width: 8),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onClose();
            },
            child: Text(
              S.current.close,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: widget.delay), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
