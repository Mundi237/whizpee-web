// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:sidebarx/sidebarx.dart';

class HomeController extends ValueNotifier<int> {
  SidebarXItem get currentTab {
    return tabs[sidebarXController.selectedIndex];
  }

  final tabs = <SidebarXItem>[
    SidebarXItem(
      icon: Icons.home,
      label: S.current.dashboard,
    ),
    SidebarXItem(
      icon: Icons.people,
      label: S.current.users,
    ),
    SidebarXItem(
      icon: Icons.notification_add,
      label: S.current.notification,
    ),
    SidebarXItem(
      icon: Icons.settings,
      label: S.current.settings,
    ),
    // const SidebarXItem(
    //   icon: Icons.exit_to_app,
    //   label: 'Logout',
    // ),
  ];
  final sidebarXController = SidebarXController(
    selectedIndex: 0,
    extended: true,
  );

  HomeController(super._value) {
    sidebarXController.addListener(() {
      value = sidebarXController.selectedIndex;
    });
  }
}
