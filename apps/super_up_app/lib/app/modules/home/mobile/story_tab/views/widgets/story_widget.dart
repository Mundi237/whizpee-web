import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up/app/core/models/story/story_model.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:s_translation/generated/l10n.dart';

import '../../../../../story/story_views/story_viewers_screen.dart';

class StoryWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        onLongTap(storyModel);
      },
      onTap: () {
        onTap(storyModel);
      },
      dense: false,
      contentPadding: const EdgeInsets.all(0),
      leading: Stack(
        children: [
          DashedCircle(
            dashes: storyModel.stories.length,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: isLoading
                  ? const CupertinoActivityIndicator(
                      radius: 15,
                    )
                  : VCircleAvatar(
                      radius: 25,
                      vFileSource: VPlatformFile.fromUrl(
                        networkUrl: storyModel.userData.userImage,
                      ),
                    ),
            ),
          ),
          if (isMe && !isLoading)
            PositionedDirectional(
              end: 0,
              bottom: 0,
              child: InkWell(
                onTap: toCreateStory,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
      title: Text(
        storyModel.userData.fullName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: isMe
          ? Text(
              S.of(context).addNewStory,
              style: const TextStyle(
                fontSize: 12,
              ),
            )
          : Text(
              format(
                DateTime.parse(storyModel.stories.last.createdAt).toLocal(),
                locale: Localizations.localeOf(context).languageCode,
              ),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
      trailing: isMe && !isLoading && storyModel.stories.isNotEmpty
          ? IconButton(
              icon: const Icon(
                Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                // Navigate to story viewers screen for the most recent story
                context.toPage(
                  StoryViewersScreen(
                    storyId: storyModel.stories.first.id,
                  ),
                );
              },
            )
          : null,
    );
  }
}
