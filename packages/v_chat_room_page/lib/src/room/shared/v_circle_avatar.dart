// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VCircleAvatar extends StatelessWidget {
  final int radius;
  final String fullUrl;

  const VCircleAvatar({
    super.key,
    this.radius = 28,
    required this.fullUrl,
  });

  bool _isDefaultImage() {
    return fullUrl.contains('default_user_image.png') ||
        fullUrl.contains('default_chat_image.png') ||
        fullUrl.contains('default_group_image.png') ||
        fullUrl.contains('default_broadcast_image.png');
  }

  IconData _getDefaultIcon() {
    if (fullUrl.contains('default_group_image.png')) {
      return Icons.group;
    } else if (fullUrl.contains('default_broadcast_image.png')) {
      return Icons.campaign;
    }
    return Icons.person;
  }

  @override
  Widget build(BuildContext context) {
    // Si c'est une image par défaut, afficher une icône
    if (_isDefaultImage()) {
      return CircleAvatar(
        radius: double.tryParse(radius.toString()),
        backgroundColor: Colors.grey,
        child: Icon(
          _getDefaultIcon(),
          size: radius.toDouble(),
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    // Vérifier si l'URL est valide
    if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
      return CircleAvatar(
        radius: double.tryParse(radius.toString()),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Icon(
          Icons.person,
          size: radius.toDouble(),
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    // Charger l'image depuis le réseau
    return CircleAvatar(
      foregroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      radius: double.tryParse(radius.toString()),
      backgroundImage: CachedNetworkImageProvider(fullUrl),
    );
  }
}
