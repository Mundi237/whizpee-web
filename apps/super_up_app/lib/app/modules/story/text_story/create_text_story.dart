import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/api_service/story/story_api_service.dart';
import 'package:super_up/app/core/models/story/create_story_dto.dart';
import 'package:super_up/app/core/utils/enums.dart';
import 'package:super_up_core/super_up_core.dart';

class _CreateStoryState {
  Color backgroundColor = const Color(0xFFA68888);
  StoryFontType fontType = StoryFontType.normal;
}

class CreateTextStory extends StatefulWidget {
  const CreateTextStory({super.key});

  @override
  State<CreateTextStory> createState() => _CreateTextStoryState();
}

class _CreateTextStoryState extends State<CreateTextStory> {
  final state = _CreateStoryState();
  final random = Random();

  final _api = GetIt.I.get<StoryApiService>();
  final _txtController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _txtController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: state.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              dense: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  CupertinoIcons.clear,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _generateRandomColor,
                    child: const Icon(
                      Icons.color_lens,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: _randomFontType,
                    child: const Icon(
                      CupertinoIcons.f_cursive,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: CupertinoTextField(
                  controller: _txtController,
                  focusNode: _focusNode,
                  textAlign: TextAlign.center,
                  maxLines: 7,
                  minLines: 1,
                  maxLength: 200,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontStyle: state.fontType == StoryFontType.italic
                        ? FontStyle.italic
                        : null,
                    textBaseline: TextBaseline.alphabetic,
                    fontWeight: state.fontType == StoryFontType.bold
                        ? FontWeight.bold
                        : null,
                  ),
                  cursorColor: Colors.white,
                  placeholderStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 35,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    border: Border(),
                  ),
                  placeholder: S.of(context).createYourStory,
                ),
              ),
            ),
            Container(
              color: Colors.black.withValues(alpha: .5),
              child: ListTile(
                dense: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                title: S
                    .of(context)
                    .shareYourStatus
                    .text
                    .color(Colors.grey)
                    .size(14),
                trailing: InkWell(
                  onTap: uploadTextStory,
                  child: Container(
                    padding: const EdgeInsets.all(8.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _generateRandomColor() {
    final color = Color.fromRGBO(
      random.nextInt(256),
      256,
      random.nextInt(256),
      1,
    );
    state.backgroundColor = color;
    setState(() {});
  }

  void _randomFontType() {
    state.fontType =
        StoryFontType.values[random.nextInt(StoryFontType.values.length)];
    setState(() {});
  }

  void uploadTextStory() async {
    if (_txtController.text.isEmpty) return;
    await vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: context);
      },
      request: () async {
        final dto = CreateStoryDto(
          storyType: StoryType.text,
          content: _txtController.text,
          backgroundColor: state.backgroundColor.toARGB32().toRadixString(16),
          storyFontType: state.fontType,
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
