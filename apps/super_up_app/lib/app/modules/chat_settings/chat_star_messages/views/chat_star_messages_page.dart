// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';
import '../../../../../v_chat_v2/translations.dart';
import '../../../../core/app_config/app_config_controller.dart';
import '../controllers/chat_star_messages_controller.dart';

class ChatStarMessagesPage extends StatefulWidget {
  final String? roomId;

  const ChatStarMessagesPage({
    super.key,
    this.roomId,
  });

  @override
  State<ChatStarMessagesPage> createState() => _ChatStarMessagesPageState();
}

class _ChatStarMessagesPageState extends State<ChatStarMessagesPage> {
  late final ChatStarMessagesController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatStarMessagesController(widget.roomId);
    controller.onInit();
    AdsBannerWidget.loadAd(
      VPlatforms.isAndroid
          ? SConstants.androidInterstitialId
          : SConstants.iosInterstitialId,
      enableAds: VAppConfigController.appConfig.enableAds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.vMessageTheme.scaffoldDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(S.of(context).starMessage),
        ),
        body: SafeArea(
          bottom: false,
          child: ValueListenableBuilder<SLoadingState<List<VBaseMessage>>>(
            valueListenable: controller,
            builder: (_, data, ___) => VAsyncWidgetsBuilder(
              loadingState: data.loadingState,
              onRefresh: controller.getData,
              successWidget: () {
                final value = data.data;
                return Scrollbar(
                  interactive: true,
                  thickness: 5,
                  controller: controller.scrollController,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: VPlatforms.isWeb ? 12 : 10,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    controller: controller.scrollController,
                    // key: const PageStorageKey("VListViewItems"),
                    cacheExtent: 300,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final message = value[index];
                      final language = vMessageLocalizationPageModel(
                        context,
                      );
                      return Builder(
                        key: UniqueKey(),
                        builder: (context) {
                          if (message.isDeleted) {
                            return const SizedBox.shrink();
                          }
                          final msgItem = VMessageItem(
                            language: language,
                            onLongTap: (message) =>
                                controller.onLongTab(context, message),
                            roomType: VRoomType.s,
                            message: message,
                            voiceController: (message) {
                              if (message is VVoiceMessage) {
                                return controller.voiceControllers
                                    .getVoiceController(message);
                              }
                              return null;
                            },
                          );

                          final isTopMessage =
                              _isTopMessage(value.length, index);
                          final dividerDate = _getDateDiff(
                            bigDate: message.createdAtDate,
                            smallDate: isTopMessage
                                ? message.createdAtDate
                                : (index + 1 < value.length
                                    ? value[index + 1].createdAtDate
                                    : message.createdAtDate),
                          );
                          if (dividerDate != null || isTopMessage) {
                            //set date divider
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DateDividerItem(
                                  dateTime:
                                      dividerDate ?? message.createdAtDate,
                                  today: language.today,
                                  yesterday: language.yesterday,
                                ),
                                msgItem,
                              ],
                            );
                          }
                          return msgItem;
                        },
                      );
                    },
                    itemCount: value.length,
                    // reverse: true,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  bool _isTopMessage(int listLength, int index) {
    return listLength - 1 == index;
  }

  DateTime? _getDateDiff({
    required DateTime bigDate,
    required DateTime smallDate,
  }) {
    final difference = bigDate.difference(smallDate);
    if (difference.isNegative) {
      return null;
    }
    if (difference.inHours < 24) {
      final d1 = bigDate.day;
      final d2 = smallDate.day;
      if (d1 == d2) {
        return null;
      } else {
        return bigDate;
      }
    }
    return bigDate;
  }
}
