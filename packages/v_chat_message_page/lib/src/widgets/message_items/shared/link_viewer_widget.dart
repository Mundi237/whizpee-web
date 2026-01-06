import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_chat_message_page/src/theme/theme.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class LinkViewerWidget extends StatelessWidget {
  final VLinkPreviewData? data;
  final bool isMeSender;

  const LinkViewerWidget({
    super.key,
    required this.data,
    required this.isMeSender,
  });

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();
    return InkWell(
      onTap: () async {
        await launchUrl(
          Uri.parse(data!.link),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 250,
        ),
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          color: isMeSender
              ? context.vMessageTheme.senderReplyColor
              : context.vMessageTheme.receiverReplyColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: GestureDetector(
          onLongPress: null,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalDivider(
                    color: Colors.green,
                    thickness: 3,
                    width: 2,
                    indent: 2,
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  _getImage(),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data!.title.text
                            .color(CupertinoColors.systemGreen)
                            .maxLine(2)
                            .overflowEllipsis,
                        data!.description.text
                            .maxLine(2)
                            .size(12)
                            .thin
                            .overflowEllipsis,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getImage() {
    if (data!.image == null) {
      return const SizedBox.shrink();
    }
    return CachedNetworkImage(
      imageUrl: data!.image!,
      width: 50,
      height: 50,
    );
  }
}
