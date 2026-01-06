// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';

class SearchTextField extends StatefulWidget {
  final VoidCallback? onClose;
  final int delay;
  final Function(String value) onSearch;

  const SearchTextField({
    super.key,
    this.onClose,
    this.delay = 500,
    required this.onSearch,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      onChanged: onSearchChanged,
      onSubmitted: (t) {
        widget.onSearch(t);
      },
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
    super.dispose();
  }
}
