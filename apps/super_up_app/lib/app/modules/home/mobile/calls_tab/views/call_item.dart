// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onPress();
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              onLongPress();
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar with call direction indicator
                  Stack(
                    children: [
                      VCircleAvatar(
                        vFileSource: VPlatformFile.fromUrl(
                            networkUrl: callHistory.caller.userImage),
                        radius: 28,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                backgroundColor,
                                backgroundColor.withValues(alpha: 0.8),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: backgroundColor.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            callIcon,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Call details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and call type
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                callHistory.caller.fullName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: callColor.withValues(alpha: 0.15),
                                border: Border.all(
                                  color: callColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Icon(
                                callHistory.withVideo
                                    ? PhosphorIcons.videoCamera(
                                        PhosphorIconsStyle.fill)
                                    : Icons.call_rounded,
                                color: callColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Status and duration
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    _getStatusColor().withValues(alpha: 0.2),
                                    _getStatusColor().withValues(alpha: 0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color:
                                      _getStatusColor().withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                transCallStatus(callHistory, context),
                                style: TextStyle(
                                  color: _getStatusColor(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (callHistory.callStatus ==
                                    VCallStatus.finished &&
                                callHistory.endAt != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                child: Text(
                                  _formatDuration(),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                            const Spacer(),
                            // Date/Time
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                              child: Text(
                                format(
                                  callHistory.startAtDate,
                                  locale: Localizations.localeOf(context)
                                      .languageCode,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
