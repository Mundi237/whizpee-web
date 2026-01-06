// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_platform/v_platform.dart';

import '../../super_up_core.dart';

class SUserItem extends StatelessWidget {
  final SBaseUser baseUser;
  final String? subtitle;
  final Widget? trailing;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final bool hasBadge;
  final bool showOnlineStatus;
  final bool isOnline;

  const SUserItem({
    super.key,
    required this.baseUser,
    this.onLongPress,
    this.hasBadge = false,
    this.trailing,
    this.onTap,
    this.subtitle,
    this.showOnlineStatus = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return _AnimatedPressable(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.resolveFrom(context).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CupertinoListTile(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leadingSize: 60,
          leading: _buildAvatar(),
          title: Text(
            baseUser.fullName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          additionalInfo: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showOnlineStatus)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline ? Colors.green : Colors.grey,
                    boxShadow: isOnline
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                ),
              trailing ??
                  Icon(
                    context.isRtl
                        ? CupertinoIcons.chevron_back
                        : CupertinoIcons.chevron_forward,
                    color: CupertinoColors.tertiaryLabel.resolveFrom(context),
                    size: 18,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    Widget avatar = VCircleAvatar(
      vFileSource: VPlatformFile.fromUrl(networkUrl: baseUser.userImage),
      radius: 30,
    );

    if (hasBadge) {
      avatar = VCircleVerifiedAvatar(
        vFileSource: VPlatformFile.fromUrl(networkUrl: baseUser.userImage),
        radius: 30,
      );
    }

    if (showOnlineStatus && isOnline) {
      return Stack(
        children: [
          avatar,
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return avatar;
  }
}

class _AnimatedPressable extends StatefulWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const _AnimatedPressable({
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<_AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<_AnimatedPressable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null && widget.onLongPress == null) {
      return widget.child;
    }

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap != null
          ? () {
              HapticFeedback.selectionClick();
              widget.onTap!();
            }
          : null,
      onLongPress: widget.onLongPress != null
          ? () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}
