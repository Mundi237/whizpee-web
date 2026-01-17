import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:super_up/app/core/api_service/story/story_api_service.dart';
import 'package:super_up/app/core/models/story/story_model.dart';
import 'package:super_up/app/modules/peer_profile/views/peer_profile_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../core/utils/enums.dart';
import '../story_views/story_viewers_screen.dart';

class StoryViewpage extends StatefulWidget {
  final UserStoryModel storyModel;
  final Function(UserStoryModel current)? onComplete;
  final Function(String storyId)? onDelete;

  const StoryViewpage({
    super.key,
    required this.storyModel,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  State<StoryViewpage> createState() => _StoryViewpageState();
}

class _StoryViewpageState extends State<StoryViewpage>
    with TickerProviderStateMixin {
  final controller = StoryController();
  final stories = <StoryItem>[];
  late StoryModel current = widget.storyModel.stories.first;
  final _api = GetIt.I.get<StoryApiService>();

  late AnimationController _headerController;
  late AnimationController _controlsController;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    _parseStories();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controlsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerController.forward();
    _controlsController.forward();
    _startHideControlsTimer();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _headerController.dispose();
    _controlsController.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        setState(() => _showControls = false);
        _headerController.reverse();
        _controlsController.reverse();
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _headerController.forward();
      _controlsController.forward();
      _startHideControlsTimer();
    } else {
      _headerController.reverse();
      _controlsController.reverse();
      _hideControlsTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Story content
            StoryView(
              onComplete: () {
                if (mounted) {
                  Navigator.of(context).pop();
                  widget.onComplete?.call(widget.storyModel);
                }
              },
              onStoryShow: (storyItem, index) {
                int pos = stories.indexOf(storyItem);
                current = widget.storyModel.stories[pos];
                unawaited(_setSeen(current.id));
                if (pos == 0) return;
                if (mounted) setState(() {});
              },
              storyItems: stories,
              controller: controller,
            ),

            // Header with user info
            AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(0, -100 * (1 - _headerController.value)),
                    child: Opacity(
                      opacity: _headerController.value,
                      child: _buildHeader(),
                    ),
                  ),
                );
              },
            ),

            // Controls overlay
            if (widget.storyModel.userData.isMe)
              AnimatedBuilder(
                animation: _controlsController,
                builder: (context, child) {
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(100 * (1 - _controlsController.value), 0),
                      child: Opacity(
                        opacity: _controlsController.value,
                        child: _buildControls(),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    if (widget.storyModel.userData.isMe) return;
                    HapticFeedback.selectionClick();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PeerProfileView(
                          peerId: widget.storyModel.userData.id,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryGreen,
                            width: 2,
                          ),
                        ),
                        child: VCircleAvatar(
                          vFileSource: VPlatformFile.fromUrl(
                            networkUrl: widget.storyModel.userData.userImage,
                          ),
                          radius: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.storyModel.userData.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            format(
                              DateTime.parse(current.createdAt),
                              locale:
                                  Localizations.localeOf(context).languageCode,
                            ),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.5, end: 0);
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        right: 20,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildControlButton(
                  icon: Icons.visibility_rounded,
                  label: 'Vues',
                  onTap: () async {
                    controller.pause();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StoryViewersScreen(
                          storyId: current.id,
                        ),
                      ),
                    );
                    if (mounted) controller.play();
                  },
                ),
                const SizedBox(height: 8),
                _buildControlButton(
                  icon: Icons.delete_rounded,
                  label: 'Supprimer',
                  color: Colors.red,
                  onTap: () async {
                    controller.pause();

                    final shouldDelete = await _showDeleteDialog();

                    if (shouldDelete && mounted) {
                      try {
                        await GetIt.I
                            .get<StoryApiService>()
                            .deleteStory(current.id);

                        if (mounted) {
                          VAppAlert.showSuccessSnackBar(
                            message: S.of(context).deleted,
                            context: context,
                          );

                          widget.onDelete?.call(current.id);
                          Navigator.of(context).pop();
                        }
                      } catch (error) {
                        if (mounted) {
                          VAppAlert.showErrorSnackBar(
                            message: S.of(context).error,
                            context: context,
                          );
                          controller.play();
                        }
                      }
                    } else if (mounted) {
                      controller.play();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.5, end: 0);
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (color ?? Colors.white).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color ?? Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delete_rounded,
                      color: Colors.red.shade400,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    S.of(context).delete,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: Text(
                S.of(context).areYouSure,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Supprimer'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future _setSeen(String id) async {
    vSafeApiCall(
      request: () async {
        await _api.setSeen(current.id);
      },
      onSuccess: (response) {},
    );
  }

  void _parseStories() {
    for (final story in widget.storyModel.stories) {
      if (story.storyType == StoryType.image) {
        stories.add(
          StoryItem.pageImage(
            url: VPlatformFile.fromUrl(networkUrl: story.att!['url']!)
                .fullNetworkUrl!,
            controller: controller,
            caption: story.caption == null
                ? null
                : Text(
                    story.caption!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
            duration: const Duration(seconds: 7),
            imageFit: BoxFit.contain,
          ),
        );
        continue;
      }
      if (story.storyType == StoryType.text) {
        stories.add(
          StoryItem.text(
            title: story.content,
            duration: const Duration(seconds: 10),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontStyle: story.fontType == StoryFontType.italic
                  ? FontStyle.italic
                  : null,
              textBaseline: TextBaseline.alphabetic,
              fontWeight:
                  story.fontType == StoryFontType.bold ? FontWeight.bold : null,
              shadows: const [
                Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black54,
                ),
              ],
            ),
            backgroundColor: story.colorValue == null
                ? AppTheme.primaryGreen
                : Color(story.colorValue!),
          ),
        );
        continue;
      }
    }
  }
}
