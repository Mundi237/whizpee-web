// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class LocationMessageItem extends StatelessWidget {
  final VLocationMessage message;

  const LocationMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.isDark ? Colors.grey[900]?.withValues(alpha:0.4) : Colors.grey[50],
        border: Border.all(
          color: Colors.blue.withValues(alpha:0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          await VStringUtils.lunchMap(
            latitude: message.data.latLng.latitude,
            longitude: message.data.latLng.longitude,
            title: message.data.linkPreviewData.title ?? '',
            description: message.data.linkPreviewData.description,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: CupertinoListTile(
          leadingSize: 60,
          leadingToTitle: 12,
          padding: const EdgeInsets.all(16),
          leading: Stack(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.blue.withValues(alpha:0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha:0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.location_solid,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(
                      color: context.isDark ? Colors.grey[900]! : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.map_fill,
                    color: Colors.white,
                    size: 8,
                  ),
                ),
              ),
            ],
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  message.data.linkPreviewData.title.toString()  ,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.blue.withValues(alpha:0.1),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha:0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.location,
                      size: 12,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'GPS',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              if (message.data.linkPreviewData.description.isNotEmpty)
                Text(
                  message.data.linkPreviewData.description.toString(),
                  style: TextStyle(
                    color: context.isDark ? Colors.grey[300] : Colors.grey[600],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.withValues(alpha:0.1),
                  border: Border.all(
                    color: Colors.green.withValues(alpha:0.3),
                    width: 1,
                  ),
                ),
                child:   Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.hand_point_left,
                      size: 14,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                       "📍",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
