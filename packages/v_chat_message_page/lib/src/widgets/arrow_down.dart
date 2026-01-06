// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class ListViewArrowDown extends StatefulWidget {
  const ListViewArrowDown({
    super.key,
    required this.onPress,
    required this.scrollController,
  });

  final VoidCallback onPress;
  final ScrollController scrollController;

  @override
  State<ListViewArrowDown> createState() => _ListViewArrowDownState();
}

class _ListViewArrowDownState extends State<ListViewArrowDown> {
  bool isShown = false;

  @override
  void initState() {
    widget.scrollController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isShown) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.isDark
              ? CupertinoColors.secondarySystemGroupedBackground.darkColor
              : CupertinoColors.secondarySystemGroupedBackground,
        ),
        child: const Icon(
          CupertinoIcons.arrow_down_circle,
          color: Colors.indigoAccent,
          size: 25,
        ),
      ),
    );
  }

  void _listener() {
    if (widget.scrollController.offset > 150.0) {
      setState(() {
        isShown = true;
      });
    } else {
      setState(() {
        isShown = false;
      });
    }
  }
}
