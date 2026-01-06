// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/call_state.dart';
import '../widgets/improved_agora_video_view.dart';
import '../widgets/improved_call_actions_row.dart';
import 'call_controller.dart';

class ImprovedVCallPage extends StatefulWidget {
  final VCallDto callData;

  const ImprovedVCallPage({
    super.key,
    required this.callData,
  });

  @override
  State<ImprovedVCallPage> createState() => _ImprovedVCallPageState();
}

class _ImprovedVCallPageState extends State<ImprovedVCallPage>
    with TickerProviderStateMixin {
  late double _videoAspectRatio;
  late VCallController _callController;
  late AnimationController _pulseAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeUI();
    _callController = VCallController(widget.callData)..context = context;
  }

  void _initializeUI() {
    _setupViewport();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    _pulseAnimationController.repeat(reverse: true);
    _fadeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF0A0A0A),
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ValueListenableBuilder<CallState>(
                valueListenable: _callController,
                builder: (context, callState, child) {
                  return Column(
                    children: [
                      _buildCallHeader(context, callState, isTablet),
                      Expanded(
                        child: _buildVideoLayout(context, callState, isTablet),
                      ),
                      _buildCallActions(context, callState, isTablet),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCallHeader(
      BuildContext context, CallState callState, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32.0 : 20.0,
        vertical: isTablet ? 24.0 : 16.0,
      ),
      child: Column(
        children: [
          _buildUserInfo(context, isTablet),
          const SizedBox(height: 12),
          if (callState.status == VCallStatus.inCall)
            _buildCallTimer(context)
          else
            _buildCallStatus(context, callState),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha:0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: VCircleAvatar(
                  vFileSource: VPlatformFile.fromUrl(
                    networkUrl: widget.callData.peerUser.userImage,
                  ),
                  radius: isTablet ? 32 : 28,
                ),
              ),
            );
          },
        ),
        SizedBox(width: isTablet ? 24 : 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.callData.peerUser.fullName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 26 : 22,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                widget.callData.isVideoEnable
                    ? S.of(context).videoCallMessages
                    : S.of(context).voiceCallMessages,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      fontSize: isTablet ? 16 : 14,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCallTimer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.withValues(alpha:0.4), width: 1.5),
      ),
      child: StreamBuilder<int>(
        initialData: 0,
        stream: _callController.stopWatchTimer.rawTime,
        builder: (context, snapshot) {
          final rawTime = snapshot.data ?? 0;
          final displayTime = StopWatchTimer.getDisplayTime(
            rawTime,
            hours: false,
            milliSecond: false,
            minute: true,
            second: true,
          );
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                displayTime,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCallStatus(BuildContext context, CallState callState) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (callState.status) {
      case VCallStatus.ring:
        statusText = S.of(context).makeCall;
        statusColor = Colors.blue;
        statusIcon = Icons.call;
        break;
      case VCallStatus.inCall:
        statusText = S.of(context).inCall;
        statusColor = Colors.green;
        statusIcon = Icons.call;
        break;
      case VCallStatus.rejected:
        statusText = S.of(context).callNotAllowed;
        statusColor = Colors.red;
        statusIcon = Icons.call_end;
        break;
      default:
        statusText = S.of(context).makeCall;
        statusColor = Colors.blue;
        statusIcon = Icons.call;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withValues(alpha:0.4), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoLayout(
      BuildContext context, CallState callState, bool isTablet) {
    final users = callState.users;

    return Padding(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      child: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          if (users.isEmpty) {
            return _buildEmptyVideoState(context, isTablet);
          }

          // Update aspect ratio based on orientation
          WidgetsBinding.instance.addPostFrameCallback(
            (_) =>
                setState(() => _videoAspectRatio = isPortrait ? 2 / 3 : 3 / 2),
          );

          return _buildVideoLayoutByUserCount(users, callState, isTablet);
        },
      ),
    );
  }

  Widget _buildEmptyVideoState(BuildContext context, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.callData.isVideoEnable ? Icons.videocam : Icons.call,
              size: isTablet ? 80 : 64,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).makeCall,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white54,
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoLayoutByUserCount(
      Set<AgoraUser> users, CallState callState, bool isTablet) {
    if (users.length == 1) {
      return _buildSingleUserLayout(users.first, isTablet);
    } else if (users.length == 2) {
      return _buildTwoUsersLayout(users, callState, isTablet);
    } else {
      return _buildMultipleUsersLayout(users, isTablet);
    }
  }

  Widget _buildSingleUserLayout(AgoraUser user, bool isTablet) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTablet ? 600 : double.infinity,
          maxHeight: isTablet ? 450 : double.infinity,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImprovedAgoraVideoView(
              viewAspectRatio: _videoAspectRatio,
              user: user,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoUsersLayout(
      Set<AgoraUser> users, CallState callState, bool isTablet) {
    AgoraUser? localUser;
    AgoraUser? remoteUser;

    for (var user in users) {
      if (user.uid == callState.currentUid) {
        localUser = user;
      } else {
        remoteUser = user;
      }
    }

    if (localUser != null && remoteUser != null) {
      return Stack(
        children: [
          // Remote user's video in full screen
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ImprovedAgoraVideoView(
                  viewAspectRatio: 1,
                  user: remoteUser,
                ),
              ),
            ),
          ),
          // Local user's video as floating widget
          Positioned(
            top: isTablet ? 16 : 12,
            right: isTablet ? 16 : 12,
            width: isTablet ? 160 : 120,
            height: isTablet ? 200 : 150,
            child: GestureDetector(
              onTap: () => _swapVideoPositions(localUser!, remoteUser!),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImprovedAgoraVideoView(
                    viewAspectRatio: _videoAspectRatio,
                    user: localUser,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Fallback to grid layout
    return _buildGridLayout(users.toList(), 1);
  }

  Widget _buildMultipleUsersLayout(Set<AgoraUser> users, bool isTablet) {
    final userList = users.toList();
    final crossAxisCount = _calculateGridColumns(userList.length);
    return _buildGridLayout(userList, crossAxisCount);
  }

  Widget _buildGridLayout(List<AgoraUser> users, int crossAxisCount) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _videoAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImprovedAgoraVideoView(
              viewAspectRatio: _videoAspectRatio,
              user: users[index],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallActions(
      BuildContext context, CallState callState, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32.0 : 20.0,
        vertical: isTablet ? 28.0 : 24.0,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: isTablet ? 20 : 16,
        children: [
          if (widget.callData.isVideoEnable) ...[
            _buildVideoToggleButton(callState, isTablet),
            _buildCameraSwitchButton(callState, isTablet),
          ],
          _buildMicrophoneToggleButton(callState, isTablet),
          _buildSpeakerToggleButton(callState, isTablet),
          _buildEndCallButton(isTablet),
        ],
      ),
    );
  }

  Widget _buildVideoToggleButton(CallState callState, bool isTablet) {
    return ImprovedCallActionButton(
      icon: callState.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
      isEnabled: widget.callData.isVideoEnable,
      onTap:
          widget.callData.isVideoEnable ? _callController.onToggleCamera : null,
      backgroundColor: callState.isVideoEnabled
          ? Colors.white.withValues(alpha:0.95)
          : Colors.red.withValues(alpha:0.9),
      iconColor: callState.isVideoEnabled ? Colors.black87 : Colors.white,
      radius: isTablet ? 32 : 28,
      iconSize: isTablet ? 28 : 24,
    );
  }

  Widget _buildCameraSwitchButton(CallState callState, bool isTablet) {
    return ImprovedCallActionButton(
      icon: Icons.cameraswitch,
      onTap:
          widget.callData.isVideoEnable ? _callController.onSwitchCamera : null,
      isEnabled: widget.callData.isVideoEnable && callState.isVideoEnabled,
      backgroundColor: Colors.white.withValues(alpha:0.95),
      iconColor: Colors.black87,
      radius: isTablet ? 32 : 28,
      iconSize: isTablet ? 28 : 24,
    );
  }

  Widget _buildMicrophoneToggleButton(CallState callState, bool isTablet) {
    return ImprovedCallActionButton(
      icon: callState.isMicEnabled ? Icons.mic : Icons.mic_off,
      isEnabled: true,
      onTap: _callController.onToggleMicrophone,
      backgroundColor: callState.isMicEnabled
          ? Colors.white.withValues(alpha:0.95)
          : Colors.red.withValues(alpha:0.9),
      iconColor: callState.isMicEnabled ? Colors.black87 : Colors.white,
      radius: isTablet ? 32 : 28,
      iconSize: isTablet ? 28 : 24,
    );
  }

  Widget _buildSpeakerToggleButton(CallState callState, bool isTablet) {
    return ImprovedCallActionButton(
      icon: callState.isSpeakerEnabled
          ? CupertinoIcons.speaker_3
          : CupertinoIcons.speaker_1,
      onTap: _callController.onToggleSpeaker,
      backgroundColor: callState.isSpeakerEnabled
          ? Colors.blue.withValues(alpha:0.9)
          : Colors.white.withValues(alpha:0.95),
      iconColor: callState.isSpeakerEnabled ? Colors.white : Colors.black87,
      radius: isTablet ? 32 : 28,
      iconSize: isTablet ? 28 : 24,
    );
  }

  Widget _buildEndCallButton(bool isTablet) {
    return ImprovedCallActionButton(
      icon: Icons.call_end,
      onTap: () => Navigator.pop(context),
      radius: isTablet ? 36 : 32,
      isEnabled: true,
      backgroundColor: Colors.red,
      iconSize: isTablet ? 32 : 28,
      iconColor: Colors.white,
    );
  }

  void _swapVideoPositions(AgoraUser localUser, AgoraUser remoteUser) {
    // This method can be extended to swap video positions if needed
    // Currently just provides visual feedback through the gesture
  }

  int _calculateGridColumns(int userCount) {
    if (userCount <= 1) return 1;
    if (userCount <= 4) return 2;
    if (userCount <= 9) return 3;
    return 4;
  }

  void _setupViewport() {
    if (kIsWeb) {
      _videoAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      _videoAspectRatio = 2 / 3;
    } else {
      _videoAspectRatio = 3 / 2;
    }
  }

  @override
  void dispose() {
    _pulseAnimationController.dispose();
    _fadeAnimationController.dispose();
    _callController.dispose();
    super.dispose();
  }
}
