// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class CallItem extends StatelessWidget {
  final VCallHistory callHistory;
  final VoidCallback onPress;
  final VoidCallback onLongPress;

  const CallItem({
    super.key,
    required this.callHistory,
    required this.onPress,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isIncomingCall = callHistory.caller.id != VAppConstants.myId;
    final callColor = _getCallColor(isIncomingCall);
    final callIcon = _getCallIcon(isIncomingCall);
    final backgroundColor = _getBackgroundColor(isIncomingCall);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.isDark
            ? Colors.grey[900]?.withOpacity(0.3)
            : Colors.grey[50],
      ),
      child: InkWell(
        onTap: onPress,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: CupertinoListTile(
          leadingSize: 50,
          leading: Stack(
            children: [
              VCircleAvatar(
                vFileSource: VPlatformFile.fromUrl(
                    networkUrl: callHistory.caller.userImage),
                radius: 25,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                    border: Border.all(
                      color: context.isDark ? Colors.grey[900]! : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    callIcon,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          trailing: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: callColor.withOpacity(0.1),
              border: Border.all(
                color: callColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              callHistory.withVideo
                  ? PhosphorIcons.videoCamera(PhosphorIconsStyle.fill)
                  : CupertinoIcons.phone_fill,
              color: callColor,
              size: 20,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          additionalInfo: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: callColor.withOpacity(0.1),
            ),
            child: Text(
              format(
                callHistory.startAtDate,
                locale: Localizations.localeOf(context).languageCode,
              ),
              style: TextStyle(
                fontSize: 11,
                color: callColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  callHistory.caller.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                callIcon,
                color: callColor,
                size: 14,
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: _getStatusColor().withOpacity(0.1),
                ),
                child: Text(
                  transCallStatus(callHistory, context),
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (callHistory.callStatus == VCallStatus.finished &&
                  callHistory.endAt != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    _formatDuration(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCallColor(bool isIncomingCall) {
    if (isIncomingCall) {
      // Green for incoming calls
      return Colors.green;
    } else {
      // Blue for outgoing calls
      return Colors.blue;
    }
  }

  Color _getBackgroundColor(bool isIncomingCall) {
    if (isIncomingCall) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  IconData _getCallIcon(bool isIncomingCall) {
    if (isIncomingCall) {
      // Arrow pointing down-left for incoming calls
      return CupertinoIcons.arrow_down_left;
    } else {
      // Arrow pointing up-right for outgoing calls
      return CupertinoIcons.arrow_up_right;
    }
  }

  Color _getStatusColor() {
    switch (callHistory.callStatus) {
      case VCallStatus.finished:
        return Colors.green;
      case VCallStatus.rejected:
      case VCallStatus.canceled:
        return Colors.red;
      case VCallStatus.timeout:
        return Colors.orange;
      case VCallStatus.ring:
      case VCallStatus.inCall:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDuration() {
    if (callHistory.endAt == null || callHistory.createdAt == null) {
      return '';
    }

    final duration = callHistory.endAt!.difference(callHistory.createdAt!);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String transCallStatus(VCallHistory call, BuildContext context) {
    switch (call.callStatus) {
      case VCallStatus.ring:
        return S.of(context).ring;

      case VCallStatus.timeout:
        return S.of(context).timeout;
      case VCallStatus.finished:
        return S.of(context).finished;
      case VCallStatus.rejected:
        return S.of(context).rejected;
      case VCallStatus.canceled:
        return S.of(context).cancel;

      case VCallStatus.offline:
        return S.of(context).offline;

      case VCallStatus.serverRestart:
        return S.of(context).serverRestart;
      case VCallStatus.inCall:
        return S.of(context).inCall;
    }
  }
}
