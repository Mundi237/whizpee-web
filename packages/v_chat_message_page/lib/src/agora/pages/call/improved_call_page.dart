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
    final isDark = VThemeListener.I.isDarkMode;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      const Color(0xFF7B5FBD),
                      const Color(0xFF6B4DB0),
                      const Color(0xFF5A3DA3),
                      const Color(0xFF4A2D96),
                    ]
                  : [
                      const Color(0xFF8B6FCD),
                      const Color(0xFF7B5FBD),
                      const Color(0xFF6B4DB0),
                      const Color(0xFF5A3DA3),
                    ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ValueListenableBuilder<CallState>(
                valueListenable: _callController,
                builder: (context, callState, child) {
                  return Stack(
                    children: [
                      // Video overlay for video calls (behind everything)
                      if (widget.callData.isVideoEnable &&
                          callState.users.isNotEmpty)
                        _buildVideoOverlay(context, callState, isTablet),
                      // Main content (on top)
                      Column(
                        children: [
                          _buildBackButton(context, isTablet),
                          const Spacer(),
                          if (!widget.callData.isVideoEnable ||
                              callState.users.isEmpty)
                            _buildCenterContent(context, callState, isTablet),
                          const Spacer(),
                          _buildCallActions(context, callState, isTablet),
                        ],
                      ),
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

  Widget _buildBackButton(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24.0 : 16.0,
        vertical: isTablet ? 20.0 : 12.0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: isTablet ? 24 : 20,
              ),
            ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Text(
            'Retour',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterContent(
      BuildContext context, CallState callState, bool isTablet) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Large avatar with pulse animation
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
                      color: Colors.white.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: VCircleAvatar(
                    vFileSource: VPlatformFile.fromUrl(
                      networkUrl: widget.callData.peerUser.userImage,
                    ),
                    radius: isTablet ? 80 : 70,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: isTablet ? 32 : 24),
        // Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            widget.callData.peerUser.fullName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 32 : 26,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        // Status
        if (callState.status == VCallStatus.inCall)
          _buildCallTimer(context, isTablet)
        else
          _buildCallStatus(context, callState, isTablet),
      ],
    );
  }

  Widget _buildCallTimer(BuildContext context, bool isTablet) {
    return StreamBuilder<int>(
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
              width: isTablet ? 10 : 8,
              height: isTablet ? 10 : 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: isTablet ? 10 : 8),
            Text(
              displayTime,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 18 : 16,
                letterSpacing: 1,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCallStatus(
      BuildContext context, CallState callState, bool isTablet) {
    String statusText;

    switch (callState.status) {
      case VCallStatus.ring:
        statusText = 'Demande...';
        break;
      case VCallStatus.inCall:
        statusText = S.of(context).inCall;
        break;
      case VCallStatus.rejected:
        statusText = S.of(context).callNotAllowed;
        break;
      default:
        statusText = 'Demande...';
    }

    return Text(
      statusText,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.85),
        fontWeight: FontWeight.w400,
        fontSize: isTablet ? 18 : 16,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildVideoOverlay(
      BuildContext context, CallState callState, bool isTablet) {
    final users = callState.users;

    if (users.isEmpty || !widget.callData.isVideoEnable) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) =>
                setState(() => _videoAspectRatio = isPortrait ? 2 / 3 : 3 / 2),
          );
          return _buildVideoLayoutByUserCount(users, callState, isTablet);
        },
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
                color: Colors.black.withValues(alpha: 0.3),
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
                    color: Colors.black.withValues(alpha: 0.3),
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
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
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
                color: Colors.black.withValues(alpha: 0.2),
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
        horizontal: isTablet ? 40.0 : 24.0,
        vertical: isTablet ? 20.0 : 16.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.black.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: callState.isSpeakerEnabled
                ? CupertinoIcons.speaker_3
                : CupertinoIcons.speaker_1,
            label: 'haut-parleur',
            isTablet: isTablet,
            onTap: _callController.onToggleSpeaker,
          ),
          if (widget.callData.isVideoEnable)
            _buildActionButton(
              icon: callState.isVideoEnabled
                  ? Icons.videocam
                  : Icons.videocam_off,
              label: 'vidéo',
              isTablet: isTablet,
              onTap: _callController.onToggleCamera,
            ),
          _buildActionButton(
            icon: callState.isMicEnabled ? Icons.mic : Icons.mic_off,
            label: 'muet',
            isTablet: isTablet,
            onTap: _callController.onToggleMicrophone,
          ),
          _buildActionButton(
            icon: Icons.call_end,
            label: 'terminer',
            isTablet: isTablet,
            isEndCall: true,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isTablet,
    required VoidCallback onTap,
    bool isEndCall = false,
  }) {
    final buttonSize = isTablet ? 70.0 : 60.0;
    final iconSize = isTablet ? 32.0 : 28.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: isEndCall
                  ? Colors.red.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: isEndCall
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isEndCall ? Colors.red : Colors.black)
                      .withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          SizedBox(height: isTablet ? 12 : 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
