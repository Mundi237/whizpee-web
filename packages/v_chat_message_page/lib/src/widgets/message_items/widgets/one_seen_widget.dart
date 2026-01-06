import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_message_page.dart';
import '../../../page/one_time_seen/one_time_seen_page.dart';

class OneSeenWidget extends StatelessWidget {
  const OneSeenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        S.of(context).messageHasBeenViewed.text.black.italic.color(Colors.red),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

class ClickToSeenWidget extends StatelessWidget {
  final VBaseMessage message;
  final VMessageLocalization language;

  const ClickToSeenWidget({
    super.key,
    required this.message,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.toPage(
          OneTimeSeenPage(
            message: message,
            language: language,
          ),
        );
      },
      child: S.of(context).clickToSee.text.black.italic.color(Colors.red),
    );
  }
}
