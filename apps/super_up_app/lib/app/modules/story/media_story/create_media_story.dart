import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';

import '../../../core/api_service/story/story_api_service.dart';
import '../../../core/models/story/create_story_dto.dart';
import '../../../core/utils/enums.dart';

class CreateMediaStory extends StatefulWidget {
  final VBaseMediaRes media;

  const CreateMediaStory({super.key, required this.media});

  @override
  State<CreateMediaStory> createState() => _CreateMediaStoryState();
}

class _CreateMediaStoryState extends State<CreateMediaStory> {
  final _txtController = TextEditingController();
  final _api = GetIt.I.get<StoryApiService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: S.of(context).createStory.text.color(Colors.white),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                VPlatformCacheImageWidget(
                  source: widget.media.getVPlatformFile(),
                  size: const Size(500, 500),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        placeholder: S.of(context).writeACaption,
                        controller: _txtController,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        placeholderStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CupertinoButton(
                      onPressed: uploadMediaStory,
                      child: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void uploadMediaStory() async {
    await vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: context);
      },
      request: () async {
        final dto = CreateStoryDto(
          storyType: StoryType.image,
          content: StoryType.image.name,
          caption: _txtController.text.isEmpty ? null : _txtController.text,
          image: widget.media.getVPlatformFile(),
          attachment: (widget.media as VMediaImageRes).data.toMap(),
        );
        return _api.createStory(dto);
      },
      onSuccess: (response) {
        context.pop();
        context.pop();
        VAppAlert.showSuccessSnackBar(
          context: context,
          message: S.of(context).storyCreatedSuccessfully,
        );
      },
      onError: (exception) {
        context.pop();
        VAppAlert.showErrorSnackBar(
          context: context,
          message: exception.toString(),
        );
      },
    );
  }
}
