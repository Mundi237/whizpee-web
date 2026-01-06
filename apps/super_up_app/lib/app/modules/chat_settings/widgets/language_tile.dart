import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../home/mobile/settings_tab/views/sheet_for_choose_language.dart';
import '../../home/mobile/settings_tab/widgets/settings_list_item_tile.dart';

class LanguageTile extends StatefulWidget {
  const LanguageTile({
    super.key,
    this.translateTo,
    required this.roomId,
  });

  final String? translateTo;
  final String roomId;

  @override
  State<LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<LanguageTile> {
  late String? transTo;

  @override
  void initState() {
    super.initState();
    transTo = widget.translateTo;
  }

  late final roomId = widget.roomId;
  final nativeApi = VChatController.I.nativeApi;

  @override
  Widget build(BuildContext context) {
    final isTransEnable = transTo != null;
    return SettingsListItemTile(
      color: Colors.green,
      icon: CupertinoIcons.t_bubble,
      onTap: onChooseLanguage,
      title:S.of(context).translate,
      subtitle: isTransEnable ? transTo!.text : null,
      additionalInfo: CupertinoSwitch(
        value: isTransEnable,
        onChanged: (value) => value ? onChooseLanguage() : onStopTrans(),
      ),
      trailing: const SizedBox.shrink(),
    );
  }

  Future onStopTrans() async {
    await nativeApi.remote.room.stopRoomAutoTranslate(
      roomId: roomId,
    );
    await nativeApi.local.room.updateTransTo(
      roomId: roomId,
      transTo: null,
    );
    transTo = null;
    setState(() {});
  }

  Future _changeRoomLanguageApi(String tr) async {
    try {
      await nativeApi.remote.room.transTo(
        roomId: roomId,
        transTo: tr,
      );
    } catch (err) {
      VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: err.toString());
      print(err);
    }
  }

  Future<void> onChooseLanguage() async {
    final res = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForChooseLanguage(),
    ) as ModelSheetItem?;
    if (res == null) {
      return;
    }
    final lan = res.id.toString();

    await _changeRoomLanguageApi(lan.toString());
    transTo = lan.toString();
    await nativeApi.local.room.updateTransTo(
      roomId: roomId,
      transTo: lan.toString(),
    );
    setState(() {});
  }
}
