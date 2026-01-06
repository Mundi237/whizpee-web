// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_platform/v_platform.dart';

import '../../super_up_core.dart';

class VImagePicker extends StatefulWidget {
  final bool withCrop;
  final bool isFromCamera;
  final void Function(VPlatformFile file) onDone;
  final void Function(String error)? onError;
  final int size;
  final VPlatformFile initImage;
  final Color? accentColor;
  final bool enableHapticFeedback;

  const VImagePicker({
    super.key,
    this.withCrop = true,
    this.isFromCamera = false,
    required this.onDone,
    this.onError,
    required this.initImage,
    this.size = 70,
    this.accentColor,
    this.enableHapticFeedback = true,
  });

  @override
  State<VImagePicker> createState() => _VImagePickerState();
}

class _VImagePickerState extends State<VImagePicker>
    with SingleTickerProviderStateMixin {
  late VPlatformFile current;
  bool _isLoading = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    current = widget.initImage;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ??
        Theme.of(context).primaryColor;

    return SizedBox(
      height: widget.size.toDouble(),
      width: widget.size.toDouble(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image container with animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              ),
            ),
            child: Container(
              key: ValueKey(current.getCachedUrlKey),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: VPlatformCacheImageWidget(
                source: current,
                borderRadius: BorderRadius.circular(widget.size.toDouble()),
                fit: BoxFit.cover,
                size: Size.fromHeight(widget.size.toDouble()),
              ),
            ),
          ),

          // Camera button with pulse animation
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: _isLoading ? 1.0 : _pulseAnimation.value,
                child: child,
              ),
              child: GestureDetector(
                onTapDown: (_) {
                  if (widget.enableHapticFeedback) {
                    HapticFeedback.selectionClick();
                  }
                },
                onTap: _isLoading ? null : _getImage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isLoading
                        ? Colors.grey
                        : accentColor,
                    boxShadow: _isLoading
                        ? []
                        : [
                            BoxShadow(
                              color: accentColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isLoading
                        ? SizedBox(
                            width: 19,
                            height: 19,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.white,
                              ),
                            ),
                          )
                        : Icon(
                            widget.isFromCamera
                                ? Icons.camera_alt
                                : Icons.photo_library,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.white,
                            size: 19,
                          ),
                  ),
                ),
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getImage() async {
    if (_isLoading) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      VPlatformFile? image;

      if (!widget.withCrop) {
        image = await VAppPick.getImage(
          isFromCamera: widget.isFromCamera,
        );
      } else {
        image = await VAppPick.getCroppedImage(
          isFromCamera: widget.isFromCamera,
          context: context,
        );
      }

      if (image != null && mounted) {
        if (widget.enableHapticFeedback) {
          HapticFeedback.heavyImpact();
        }

        setState(() {
          current = image!;
          _isLoading = false;
        });

        widget.onDone(image);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (widget.enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        widget.onError?.call(e.toString());
      }
    }
  }
}
