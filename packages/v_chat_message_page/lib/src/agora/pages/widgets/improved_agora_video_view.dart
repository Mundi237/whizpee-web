// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';

import '../../core/call_state.dart';

class ImprovedAgoraVideoView extends StatefulWidget {
  const ImprovedAgoraVideoView({
    super.key,
    required this.viewAspectRatio,
    required this.user,
    this.showUserInfo = true,
    this.borderRadius = 12.0,
  });

  final double viewAspectRatio;
  final AgoraUser user;
  final bool showUserInfo;
  final double borderRadius;

  @override
  State<ImprovedAgoraVideoView> createState() => _ImprovedAgoraVideoViewState();
}

class _ImprovedAgoraVideoViewState extends State<ImprovedAgoraVideoView>
    with SingleTickerProviderStateMixin {
  late AnimationController _statusAnimationController;
  late Animation<double> _statusOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _statusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _statusOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statusAnimationController,
      curve: Curves.easeInOut,
    ));

    _statusAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.viewAspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _getBorderColor(),
            width: 1.5,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2A2A),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius - 1.5),
          child: Stack(
            children: [
              // Video content or placeholder
              _buildVideoContent(context),

              // Status indicators overlay
              if (widget.showUserInfo) _buildStatusOverlay(context),

              // Audio/Video status indicators
              _buildMediaStatusIndicators(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    final isVideoEnabled = widget.user.isVideoEnabled ?? false;

    if (isVideoEnabled && widget.user.view != null) {
      return Positioned.fill(
        child: widget.user.view!,
      );
    } else {
      return _buildVideoPlaceholder(context);
    }
  }

  Widget _buildVideoPlaceholder(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3A3A3A),
            Color(0xFF2A2A2A),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha:0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha:0.2),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                color: Colors.white.withValues(alpha:0.8),
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.user.name != null) ...[
              Text(
                widget.user.name!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            Text(
              _getVideoStatusText(context),
              style: TextStyle(
                color: Colors.white.withValues(alpha:0.6),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverlay(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      right: 8,
      child: FadeTransition(
        opacity: _statusOpacityAnimation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.user.name != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha:0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha:0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  widget.user.name!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            _buildConnectionQualityIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaStatusIndicators(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: FadeTransition(
        opacity: _statusOpacityAnimation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAudioStatusIndicator(),
            const SizedBox(width: 6),
            _buildVideoStatusIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioStatusIndicator() {
    final isAudioEnabled = widget.user.isAudioEnabled ?? false;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isAudioEnabled
            ? Colors.green.withValues(alpha:0.8)
            : Colors.red.withValues(alpha:0.8),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha:0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isAudioEnabled ? Icons.mic : Icons.mic_off,
        color: Colors.white,
        size: 14,
      ),
    );
  }

  Widget _buildVideoStatusIndicator() {
    final isVideoEnabled = widget.user.isVideoEnabled ?? false;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isVideoEnabled
            ? Colors.blue.withValues(alpha:0.8)
            : Colors.grey.withValues(alpha:0.8),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha:0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isVideoEnabled ? Icons.videocam : Icons.videocam_off,
        color: Colors.white,
        size: 14,
      ),
    );
  }

  Widget _buildConnectionQualityIndicator() {
    // This could be extended to show actual connection quality
    // For now, we'll show a generic connected indicator
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha:0.8),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha:0.3),
          width: 1,
        ),
      ),
      child: const Icon(
        Icons.signal_cellular_4_bar,
        color: Colors.white,
        size: 12,
      ),
    );
  }

  Color _getBorderColor() {
    final isAudioEnabled = widget.user.isAudioEnabled ?? false;
    final isVideoEnabled = widget.user.isVideoEnabled ?? false;

    if (isVideoEnabled && isAudioEnabled) {
      return Colors.green.withValues(alpha:0.6);
    } else if (isAudioEnabled) {
      return Colors.blue.withValues(alpha:0.6);
    } else {
      return Colors.red.withValues(alpha:0.6);
    }
  }

  String _getVideoStatusText(BuildContext context) {
    final isVideoEnabled = widget.user.isVideoEnabled ?? false;

    if (!isVideoEnabled) {
      return S.of(context).audioCall;
    }

    return S.of(context).videoCallMessages;
  }

  @override
  void dispose() {
    _statusAnimationController.dispose();
    super.dispose();
  }
}

class VideoLayoutManager {
  static Widget buildOptimalLayout({
    required List<AgoraUser> users,
    required double aspectRatio,
    required BuildContext context,
    bool showUserInfo = true,
  }) {
    if (users.isEmpty) {
      return const SizedBox.shrink();
    }

    if (users.length == 1) {
      return _buildSingleUserLayout(users.first, aspectRatio, showUserInfo);
    } else if (users.length == 2) {
      return _buildTwoUserLayout(users, aspectRatio, showUserInfo);
    } else {
      return _buildMultiUserGrid(users, aspectRatio, showUserInfo);
    }
  }

  static Widget _buildSingleUserLayout(
    AgoraUser user,
    double aspectRatio,
    bool showUserInfo,
  ) {
    return ImprovedAgoraVideoView(
      viewAspectRatio: aspectRatio,
      user: user,
      showUserInfo: showUserInfo,
    );
  }

  static Widget _buildTwoUserLayout(
    List<AgoraUser> users,
    double aspectRatio,
    bool showUserInfo,
  ) {
    return Column(
      children: users
          .map((user) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ImprovedAgoraVideoView(
                    viewAspectRatio: aspectRatio,
                    user: user,
                    showUserInfo: showUserInfo,
                  ),
                ),
              ))
          .toList(),
    );
  }

  static Widget _buildMultiUserGrid(
    List<AgoraUser> users,
    double aspectRatio,
    bool showUserInfo,
  ) {
    final crossAxisCount = _calculateGridColumns(users.length);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ImprovedAgoraVideoView(
          viewAspectRatio: aspectRatio,
          user: users[index],
          showUserInfo: showUserInfo,
        );
      },
    );
  }

  static int _calculateGridColumns(int userCount) {
    if (userCount <= 1) return 1;
    if (userCount <= 4) return 2;
    if (userCount <= 9) return 3;
    return 4;
  }
}
