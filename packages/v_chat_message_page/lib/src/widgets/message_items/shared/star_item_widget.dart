// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarItemWidget extends StatelessWidget {
  final bool isStar;

  const StarItemWidget({
    super.key,
    required this.isStar,
  });

  @override
  Widget build(BuildContext context) {
    if (!isStar) return const SizedBox.shrink();
    return const Icon(
      CupertinoIcons.star_fill,
      color: Colors.green,
      size: 15,
    );
  }
}
