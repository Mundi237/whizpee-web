// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s_translation/generated/l10n.dart';

/// A widget that displays video compression progress with a progress bar,
/// estimated time, and cancel button.
class VideoCompressionProgress extends StatefulWidget {
  const VideoCompressionProgress({
    super.key,
    required this.progress,
    required this.onCancel,
    this.title = 'Compressing Video',
  });

  /// Current progress value between 0.0 and 1.0
  final double progress;

  /// Callback when cancel button is pressed
  final VoidCallback onCancel;

  /// Title to display above the progress
  final String title;

  @override
  State<VideoCompressionProgress> createState() =>
      _VideoCompressionProgressState();
}

class _VideoCompressionProgressState extends State<VideoCompressionProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildProgressIndicator(context),
          const SizedBox(height: 16),
          _buildProgressText(context),
          const SizedBox(height: 24),
          _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              Icons.video_settings,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).compressingVideo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ) ??
                    const TextStyle(),
                child: Text(
                  S.of(context).analyzingVideoAndPreparingCompression,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 8,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              tween: Tween<double>(
                begin: 0,
                end: widget.progress,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              tween: IntTween(
                begin: 0,
                end: (widget.progress * 100).toInt(),
              ),
              builder: (context, value, _) => Text(
                '$value%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _getEstimatedTimeText(context),
                key: ValueKey(_getEstimatedTimeText(context)),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressText(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        _getProgressDescription(context),
        key: ValueKey(_getProgressDescription(context)),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.mediumImpact();
            widget.onCancel();
          },
          icon: const Icon(Icons.cancel_outlined),
          label: Text(S.of(context).cancelCompression),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onLongPress: () {
            setState(() => _isPressed = true);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted) setState(() => _isPressed = false);
            });
          },
        ),
      ),
    );
  }

  String _getProgressDescription(BuildContext context) {
    if (widget.progress < 0.3) {
      return S.of(context).analyzingVideoAndPreparingCompression;
    } else if (widget.progress < 0.7) {
      return S.of(context).compressingVideoWait;
    } else if (widget.progress < 0.9) {
      return S.of(context).finalizingCompression;
    } else {
      return S.of(context).almostDone;
    }
  }

  String _getEstimatedTimeText(BuildContext context) {
    if (widget.progress <= 0) return S.of(context).calculating;

    final remainingProgress = 1.0 - widget.progress;
    if (remainingProgress <= 0) return S.of(context).finishing;

    // Simple estimation based on current progress
    if (widget.progress < 0.1) return S.of(context).estimating;

    final estimatedSeconds =
        (remainingProgress / widget.progress) * 30; // Rough estimate

    if (estimatedSeconds < 60) {
      return '~${estimatedSeconds.toInt()}s ${S.of(context).remaining}';
    } else {
      final minutes = (estimatedSeconds / 60).toInt();
      return '~${minutes}m ${S.of(context).remaining}';
    }
  }
}
