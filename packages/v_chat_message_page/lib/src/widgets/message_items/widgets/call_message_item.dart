// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class CallMessageItem extends StatelessWidget {
  final VCallMessage message;
  final String audioCallLabel;
  final String callStatusLabel;

  const CallMessageItem({
    super.key,
    required this.message,
    required this.audioCallLabel,
    required this.callStatusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final callColor = _getCallColor();
    final statusColor = _getStatusColor();
    final callIcon = _getCallIcon();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.isDark
            ? Colors.grey[900]?.withValues(alpha: 0.4)
            : Colors.grey[50],
        border: Border.all(
          color: callColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (message.data.callStatus == VMessageCallStatus.ring) {
            VChatController.I.vNavigator.callNavigator.toCall(
              context,
              VCallDto(
                isVideoEnable: message.data.withVideo,
                roomId: message.roomId,
                peerUser: SBaseUser(
                  id: message.roomId,
                  fullName: S.of(context).group,
                  userImage: "",
                ),
                isCaller: message.isMeSender,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: CupertinoListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  message.senderName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                callIcon,
                color: callColor,
                size: 16,
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: statusColor.withValues(alpha: 0.1),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: _getSub(context),
                  ),
                  if (message.data.callStatus == VMessageCallStatus.ring) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.phone,
                            size: 12,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            S.of(context).clickToJoin,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          leading: Stack(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      callColor,
                      callColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: callColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  message.data.withVideo
                      ? PhosphorIcons.videoCamera(PhosphorIconsStyle.fill)
                      : PhosphorIcons.phoneCall(),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              if (message.data.callStatus == VMessageCallStatus.ring)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(
                        color:
                            context.isDark ? Colors.grey[900]! : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      CupertinoIcons.bell_fill,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _getSub(BuildContext context) {
    if (message.data.duration != null) {
      return Text(
        "${message.data.duration.toString()}s",
        style: TextStyle(
          color: _getStatusColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text(
      callStatusLabel.toString(),
      style: TextStyle(
        color: _getStatusColor(),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Color _getCallColor() {
    switch (message.data.callStatus) {
      case VMessageCallStatus.ring:
        return Colors.green;
      case VMessageCallStatus.finished:
        return Colors.blue;
      case VMessageCallStatus.rejected:
      case VMessageCallStatus.canceled:
        return Colors.red;
      case VMessageCallStatus.timeout:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor() {
    switch (message.data.callStatus) {
      case VMessageCallStatus.ring:
        return Colors.green;
      case VMessageCallStatus.finished:
        return Colors.blue;
      case VMessageCallStatus.rejected:
      case VMessageCallStatus.canceled:
        return Colors.red;
      case VMessageCallStatus.timeout:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCallIcon() {
    if (message.isMeSender) {
      // Outgoing call - arrow pointing up-right
      return CupertinoIcons.arrow_up_right;
    } else {
      // Incoming call - arrow pointing down-left
      return CupertinoIcons.arrow_down_left;
    }
  }
}
