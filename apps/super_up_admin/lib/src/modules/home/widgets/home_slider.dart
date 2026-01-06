// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:super_up_admin/src/modules/home/widgets/slider_colors.dart';

class HomeSlider extends StatefulWidget {
  final List<SidebarXItem> items;

  const HomeSlider({
    super.key,
    required SidebarXController controller,
    required this.items,
  }) : _controller = controller;

  final SidebarXController _controller;

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget._controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: actionColor.withValues(alpha: 0.37),
          ),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withValues(alpha: 0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
          color: canvasColor,
        ),
      ),
      footerDivider: divider,
      headerBuilder: (context, extended) {
        return Column(
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset('assets/logo.png'),
              ),
            ),
            if (extended)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  S.of(context).admin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            divider,
            const SizedBox(height: 10),
          ],
        );
      },
      items: widget.items,
    );
  }


}
