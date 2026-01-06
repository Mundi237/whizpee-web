// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:s_translation/generated/l10n.dart';

// Constants for consistent styling
class _EnhancedVideoTrimmerConstants {
  static const double trimViewerHeight = 60.0;
  static const double borderRadius = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double animationDuration = 300.0;
}

class EnhancedVideoTrimmerView extends StatefulWidget {
  final File videoFile;

  const EnhancedVideoTrimmerView({
    super.key,
    required this.videoFile,
  });

  @override
  State<EnhancedVideoTrimmerView> createState() =>
      _EnhancedVideoTrimmerViewState();
}

class _EnhancedVideoTrimmerViewState extends State<EnhancedVideoTrimmerView>
    with TickerProviderStateMixin {
  final Trimmer _trimmer = Trimmer();

  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> _fadeAnimation;

  // Trimming state
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _isProcessing = false;
  bool _isLoading = true;

  // Video information
  Duration _trimmedDuration = Duration.zero;
  String _fileName = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideo();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: Duration(
        milliseconds: _EnhancedVideoTrimmerConstants.animationDuration.toInt(),
      ),
      vsync: this,
    );

    _scaleAnimationController = AnimationController(
      duration: Duration(
        milliseconds: _EnhancedVideoTrimmerConstants.animationDuration.toInt(),
      ),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _fadeAnimationController, curve: Curves.easeInOut),
    );

    _fadeAnimationController.forward();
    _scaleAnimationController.forward();
  }

  void _initializeVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _fileName = widget.videoFile.path.split('/').last;
      });

      await _trimmer.loadVideo(videoFile: widget.videoFile);

      setState(() {
        _isLoading = false;
        // The video_trimmer package v5.0.0 handles duration internally
        // We don't need to manually set _videoDuration
        // _endValue will be set automatically by the TrimViewer
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Failed to load video: $e');
    }
  }

  void _updateTrimmedDuration() {
    final startMs = _startValue.toInt();
    final endMs = _endValue.toInt();
    _trimmedDuration = Duration(milliseconds: endMs - startMs);
  }

  Future<void> _saveVideo() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    try {
      await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        onSave: (String? outputPath) {
          setState(() {
            _isProcessing = false;
          });

          if (outputPath != null) {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop(outputPath);
          } else {
            _showErrorDialog(S.of(context).failedToSaveTrimmedVideo);
          }
        },
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorDialog('Error saving video: $e');
    }
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }

  void _resetTrim() {
    HapticFeedback.mediumImpact();
    setState(() {
      _startValue = 0.0;
      // _endValue will be set automatically by the TrimViewer
      _updateTrimmedDuration();
    });
  }

  @override
  void dispose() {
    // Stop video playback if playing
    if (_isPlaying) {
      _trimmer.videoPlaybackControl(
        startValue: _startValue,
        endValue: _endValue,
      );
    }
    
    // Dispose animation controllers
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
    
    // Note: video_trimmer package v5.0.0+ handles internal disposal automatically
    // but we ensure playback is stopped before disposal
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isProcessing,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Stop video playback when leaving the page
          if (_isPlaying) {
            _trimmer.videoPlaybackControl(
              startValue: _startValue,
              endValue: _endValue,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: _isLoading ? _buildLoadingState() : _buildMainContent(),
        bottomNavigationBar: _buildBottomControls(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).videoTrimmer,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _fileName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _resetTrim,
          tooltip: S.of(context).resetTrim,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: _EnhancedVideoTrimmerConstants.spacingMedium),
          Text(
            'Loading video...',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildVideoSection(),
          _buildTrimSection(),
          _buildDurationInfo(),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Expanded(
      child: Container(
        margin:
            const EdgeInsets.all(_EnhancedVideoTrimmerConstants.spacingMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              _EnhancedVideoTrimmerConstants.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              _EnhancedVideoTrimmerConstants.borderRadius),
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoViewer(trimmer: _trimmer),
              _buildPlayOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayOverlay() {
    return AnimatedBuilder(
      animation: _fadeAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _isPlaying ? 0.0 : _fadeAnimationController.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(
                  _EnhancedVideoTrimmerConstants.borderRadius),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _trimmer.videoPlaybackControl(
                    startValue: _startValue,
                    endValue: _endValue,
                  );
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                child: AnimatedScale(
                  scale: _isPlaying ? 0.8 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.95),
                          Colors.white.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 3,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 5,
                          spreadRadius: -2,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 48,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrimSection() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: _EnhancedVideoTrimmerConstants.spacingMedium,
      ),
      child: Column(
        children: [
          // Timeline
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(
                  _EnhancedVideoTrimmerConstants.borderRadius),
            ),
            child: TrimViewer(
              trimmer: _trimmer,
              viewerHeight: _EnhancedVideoTrimmerConstants.trimViewerHeight,
              viewerWidth: MediaQuery.of(context).size.width -
                  (_EnhancedVideoTrimmerConstants.spacingMedium * 2),
              maxVideoLength: const Duration(seconds: 60),
              onChangeStart: (value) {
                setState(() {
                  _startValue = value;
                  _updateTrimmedDuration();
                });
                HapticFeedback.selectionClick();
              },
              onChangeEnd: (value) {
                setState(() {
                  _endValue = value;
                  _updateTrimmedDuration();
                });
                HapticFeedback.selectionClick();
              },
              onChangePlaybackState: (value) {
                setState(() {
                  _isPlaying = value;
                });
              },
            ),
          ),
          const SizedBox(height: _EnhancedVideoTrimmerConstants.spacingSmall),
          // Timeline labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(Duration(milliseconds: _startValue.toInt())),
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatDuration(Duration(milliseconds: _endValue.toInt())),
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationInfo() {
    return Container(
      margin:
          const EdgeInsets.all(_EnhancedVideoTrimmerConstants.spacingMedium),
      padding:
          const EdgeInsets.all(_EnhancedVideoTrimmerConstants.spacingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(_EnhancedVideoTrimmerConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDurationItem(
            S.of(context).original,
            _formatDuration(Duration(milliseconds: _endValue.toInt())),
            Icons.video_file_outlined,
            Colors.blue.shade400,
          ),
          Container(
            width: 2,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade600,
                  Colors.grey.shade700,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          _buildDurationItem(
            S.of(context).trimmed,
            _formatDuration(_trimmedDuration),
            Icons.content_cut_outlined,
            Colors.green.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationItem(
      String label, String duration, IconData icon, Color color) {
    return AnimatedBuilder(
      animation: _scaleAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_scaleAnimationController.value * 0.05),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: _EnhancedVideoTrimmerConstants.spacingSmall),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade900.withValues(alpha: 0.8),
            Colors.black.withValues(alpha: 0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding:
          const EdgeInsets.all(_EnhancedVideoTrimmerConstants.spacingMedium),
      child: SafeArea(
        child: Row(
          children: [
            // Cancel button
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: OutlinedButton(
                  onPressed:
                      _isProcessing ? null : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: 0.9),
                    side: BorderSide(
                      color: Colors.grey.shade500,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          _EnhancedVideoTrimmerConstants.borderRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        S.of(context).cancel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: _EnhancedVideoTrimmerConstants.spacingMedium),
            // Save button
            Expanded(
              flex: 2,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _saveVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isProcessing 
                        ? Colors.grey.shade600 
                        : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: _isProcessing ? 2 : 6,
                    shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          _EnhancedVideoTrimmerConstants.borderRadius),
                    ),
                  ),
                  child: _isProcessing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    _EnhancedVideoTrimmerConstants.spacingSmall),
                            Text(
                              S.of(context).saving,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.save_alt_rounded, size: 22),
                            const SizedBox(
                                width:
                                    _EnhancedVideoTrimmerConstants.spacingSmall),
                            Text(
                              S.of(context).save,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
