import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_up/app/core/models/story/story_model.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:s_translation/generated/l10n.dart';

import '../../../../../story/story_views/story_viewers_screen.dart';

class StoryWidget extends StatefulWidget {
  final UserStoryModel storyModel;
  final Function(UserStoryModel storyModel) onTap;
  final Function(UserStoryModel storyModel) onLongTap;
  final VoidCallback? toCreateStory;
  final bool isMe;
  final bool isLoading;

  const StoryWidget({
    super.key,
    required this.storyModel,
    required this.onTap,
    required this.onLongTap,
    this.toCreateStory,
    this.isMe = false,
    this.isLoading = false,
  });

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.storyModel.stories.isNotEmpty) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap(widget.storyModel);
      },
      onLongPress: () {
        HapticFeedback.heavyImpact();
        widget.onLongTap(widget.storyModel);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Row(
                children: [
                  _buildAvatar(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildUserInfo(),
                  ),
                  if (widget.isMe &&
                      !widget.isLoading &&
                      widget.storyModel.stories.isNotEmpty)
                    _buildViewersButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        // Story ring animation
        if (widget.storyModel.stories.isNotEmpty && !widget.isLoading)
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGreen.withValues(
                          alpha: 0.8 + (0.2 * _pulseController.value)),
                      Colors.purple.withValues(
                          alpha: 0.6 + (0.4 * _pulseController.value)),
                      AppTheme.primaryGreen.withValues(
                          alpha: 0.8 + (0.2 * _pulseController.value)),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
        // Avatar container
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.storyModel.stories.isEmpty
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: widget.isLoading
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryGreen,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : VCircleAvatar(
                    radius: 28,
                    vFileSource: VPlatformFile.fromUrl(
                      networkUrl: widget.storyModel.userData.userImage,
                    ),
                  ),
          ),
        ),
        // Add story button for my story
        if (widget.isMe && !widget.isLoading)
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.toCreateStory?.call();
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGreen,
                      AppTheme.primaryGreen.withValues(alpha: 0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.storyModel.userData.fullName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        if (widget.isMe)
          Row(
            children: [
              Icon(
                widget.storyModel.stories.isEmpty
                    ? Icons.add_circle_outline_rounded
                    : Icons.visibility_rounded,
                color: AppTheme.primaryGreen,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                widget.storyModel.stories.isEmpty
                    ? S.of(context).addNewStory
                    : '${widget.storyModel.stories.length} story${widget.storyModel.stories.length > 1 ? 's' : ''}',
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.white.withValues(alpha: 0.6),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                format(
                  DateTime.parse(widget.storyModel.stories.last.createdAt)
                      .toLocal(),
                  locale: Localizations.localeOf(context).languageCode,
                ),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildViewersButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StoryViewersScreen(
              storyId: widget.storyModel.stories.first.id,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'Vues',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
