// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';

class MainBuilder extends StatelessWidget {
  final Widget? child;


  const MainBuilder({
    super.key,
    required this.child,

  });

  @override
  Widget build(BuildContext context) {
    final sizer = GetIt.I.get<AppSizeHelper>();
    if (!sizer.isWide(context)) {
      return PointerDownUnFocus(
        child: child!,
      );
    }
    return child!;
  }
}
