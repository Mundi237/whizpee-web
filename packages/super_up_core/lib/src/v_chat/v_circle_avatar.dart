// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';
import 'package:badges/badges.dart' as badges;

class VCircleAvatar extends StatefulWidget {
  final int radius;
  final VPlatformFile vFileSource;
  final BoxBorder? border;

  const VCircleAvatar({
    super.key,
    this.radius = 28,
    required this.vFileSource,
    this.border,
  });

  @override
  State<VCircleAvatar> createState() => _VCircleAvatarState();
}

class _VCircleAvatarState extends State<VCircleAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vFileSource.fullNetworkUrl != null) {
      return CachedNetworkImage(
        imageUrl: widget.vFileSource.fullNetworkUrl!,
        cacheKey: widget.vFileSource.getCachedUrlKey,
        imageBuilder: (context, imageProvider) => Container(
          width: widget.radius * 2.0,
          height: widget.radius * 2.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: widget.border,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      );
    }

    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: double.tryParse(widget.radius.toString()),
      backgroundImage: getImageProvider(),
      child: widget.border != null
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: widget.border,
              ),
            )
          : null,
    );
  }

  Widget _buildShimmerPlaceholder() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: widget.radius * 2.0,
          height: widget.radius * 2.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: widget.border,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: GradientRotation(_shimmerAnimation.value),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: widget.radius * 2.0,
      height: widget.radius * 2.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: widget.border,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade300,
      ),
      child: Icon(
        Icons.person,
        size: widget.radius.toDouble(),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade600
            : Colors.grey.shade500,
      ),
    );
  }

  ImageProvider getImageProvider() {
    if (widget.vFileSource.fullNetworkUrl != null) {
      return CachedNetworkImageProvider(widget.vFileSource.fullNetworkUrl!);
    }

    if (widget.vFileSource.assetsPath != null) {
      return AssetImage(widget.vFileSource.assetsPath!);
    }
    if (widget.vFileSource.isFromBytes) {
      return MemoryImage(widget.vFileSource.uint8List);
    }

    if (widget.vFileSource.isFromPath) {
      return FileImage(File(widget.vFileSource.fileLocalPath!));
    } else {
      return CachedNetworkImageProvider(widget.vFileSource.fullNetworkUrl!);
    }
  }
}

class VCircleVerifiedAvatar extends StatelessWidget {
  final int radius;
  final VPlatformFile vFileSource;

  const VCircleVerifiedAvatar({
    super.key,
    this.radius = 28,
    required this.vFileSource,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VCircleAvatar(
          vFileSource: vFileSource,
          radius: radius,
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: const badges.Badge(
              badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
              badgeContent: Icon(
                Icons.check,
                color: Colors.white,
                size: 7,
              ),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.twitter,
                badgeColor: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
