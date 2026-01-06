// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_platform/v_platform.dart';

class VPlatformCacheImageWidget extends StatefulWidget {
  final VPlatformFile source;
  final Size? size;
  final BoxFit? fit;
  final BorderRadius? borderRadius;

  const VPlatformCacheImageWidget({
    super.key,
    required this.source,
    this.size,
    this.fit,
    this.borderRadius,
  });

  @override
  State<VPlatformCacheImageWidget> createState() =>
      _VPlatformCacheImageWidgetState();
}

class _VPlatformCacheImageWidgetState extends State<VPlatformCacheImageWidget>
    with SingleTickerProviderStateMixin {
  var imageKey = UniqueKey();
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
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
    Widget image = _getImage();
    
    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: image,
      );
    }
    return image;
  }

  Widget _getImage() {
    if (widget.source.isFromAssets) {
      return Image.asset(
        widget.source.assetsPath!,
        width: widget.size?.width,
        fit: widget.fit,
        height: widget.size?.height,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
      );
    }
    if (widget.source.isFromBytes) {
      return Image.memory(
        Uint8List.fromList(widget.source.bytes!),
        width: widget.size?.width,
        fit: widget.fit,
        height: widget.size?.height,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
      );
    }
    if (widget.source.fileLocalPath != null) {
      return Image.file(
        File(widget.source.fileLocalPath!),
        width: widget.size?.width,
        height: widget.size?.height,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: child,
          );
        },
      );
    }
    return CachedNetworkImage(
      key: imageKey,
      height: widget.size?.height,
      width: widget.size?.width,
      fit: widget.fit,
      cacheKey: widget.source.getCachedUrlKey,
      imageUrl: widget.source.fullNetworkUrl!,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeInCurve: Curves.easeOut,
      placeholder: (context, url) => _buildShimmerPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size?.width,
          height: widget.size?.height,
          decoration: BoxDecoration(
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
              stops: [
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.6).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          imageKey = UniqueKey();
        });
      },
      child: Container(
        width: widget.size?.width,
        height: widget.size?.height,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              size: 32,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black54,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to retry',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white54
                    : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class VPlatformImageProvider {
  final VPlatformFile source;

  const VPlatformImageProvider({
    required this.source,
  });

  ImageProvider getImageProvider() {
    if (source.isFromAssets) {
      return AssetImage(source.assetsPath!);
    }

    if (source.isFromBytes) {
      return MemoryImage(Uint8List.fromList(source.bytes!));
    }

    if (source.fileLocalPath != null) {
      return FileImage(File(source.fileLocalPath!));
    }

    return CachedNetworkImageProvider(
      source.fullNetworkUrl!,
      cacheKey: source.getCachedUrlKey,
    );
  }

  /// Helper method to create a widget with the image provider
  Widget buildImage({
    Size? size,
    BoxFit? fit,
    BorderRadius? borderRadius,
    Widget Function(BuildContext, ImageProvider)? imageBuilder,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    Widget image;

    if (source.fullNetworkUrl != null) {
      image = CachedNetworkImage(
        imageUrl: source.fullNetworkUrl!,
        cacheKey: source.getCachedUrlKey,
        width: size?.width,
        height: size?.height,
        fit: fit,
        imageBuilder: imageBuilder,
        placeholder: placeholder ??
                (context, url) => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        errorWidget: errorWidget ??
                (context, url, error) => Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Trigger reload if needed
                },
              ),
            ),
      );
    } else {
      image = Image(
        image: getImageProvider(),
        width: size?.width,
        height: size?.height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
        errorWidget?.call(context, '', error) ??
            Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Trigger reload if needed
                },
              ),
            ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: image,
      );
    }

    return image;
  }

  /// Extension method to easily convert to ImageProvider
  ImageProvider toImageProvider() => getImageProvider();
}

/// Extension on VPlatformFile to easily create an image provider
extension VPlatformFileImageExtension on VPlatformFile {
  ImageProvider toImageProvider() {
    return VPlatformImageProvider(source: this).getImageProvider();
  }

  Widget toImage({
    Size? size,
    BoxFit? fit,
    BorderRadius? borderRadius,
    Widget Function(BuildContext, ImageProvider)? imageBuilder,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    return VPlatformImageProvider(source: this).buildImage(
      size: size,
      fit: fit,
      borderRadius: borderRadius,
      imageBuilder: imageBuilder,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}