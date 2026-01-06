// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_room_page/src/room/room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'room_provider.dart';

/// Controller class for RoomItem widget.
/// This class is responsible for handling the business logic of RoomItem widget
/// and utilizes RoomProvider for data management. */ class RoomItemController {
/// Instance of RoomProvider for data management final RoomProvider _provider;
/// The current BuildContext object final BuildContext context;
class RoomItemController {
  final RoomProvider _provider;
  final BuildContext context;

  RoomItemController(
    this._provider,
    this.context,
  );

  ModelSheetItem<VRoomItemClickRes> _muteItem() {
    return ModelSheetItem(
      title: S.of(context).mute,
      id: VRoomItemClickRes.mute,
      iconData: const Icon(
        Icons.notifications_off,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _unMuteItem() {
    return ModelSheetItem(
      title: S.of(context).unMute,
      id: VRoomItemClickRes.unMute,
      iconData: const Icon(
        Icons.notifications,
      ),
    );
  }

  ModelSheetItem<VRoomItemClickRes> _deleteItem() {
    return ModelSheetItem(
      title: S.of(context).delete,
      iconData: const Icon(Icons.delete),
      id: VRoomItemClickRes.delete,
    );
  }

  ModelSheetItem<VRoomItemClickRes> _reportItem() {
    return ModelSheetItem(
      title: S.of(context).report,
      id: VRoomItemClickRes.report,
      iconData: const Icon(
        Icons.report_gmailerrorred,
        color: Colors.red,
      ),
    );
  }

  // ModelSheetItem<VRoomItemClickRes> _unBlockItem() {
  //   return ModelSheetItem(
  //     title: language.unBlock,
  //     id: VRoomItemClickRes.unBlock,
  //     iconData: const Icon(
  //       Icons.security,
  //       color: Colors.red,
  //     ),
  //   );
  // }
  //
  // ModelSheetItem<VRoomItemClickRes> _blockItem() {
  //   return ModelSheetItem(
  //     title: language.block,
  //     id: VRoomItemClickRes.block,
  //     iconData: const Icon(
  //       Icons.block,
  //       color: Colors.red,
  //     ),
  //   );
  // }

  ModelSheetItem<VRoomItemClickRes> _leaveItem() {
    return ModelSheetItem(
      title: S.of(context).leaveGroup,
      id: VRoomItemClickRes.leave,
      iconData: const Icon(
        Icons.exit_to_app,
        color: Colors.red,
      ),
    );
  }

  Future openForSingle(VRoom room) async {
    final l = <ModelSheetItem>[
      if (room.isMuted) _unMuteItem() else _muteItem(),
      _deleteItem(),
      _reportItem(),
    ];
    final res = await VAppAlert.showModalSheetWithActions(
      content: l,
      context: context,
      cancelLabel: S.of(context).cancel,
    );

    if (res == null) return;
    _process(
      res.id,
      room,
    );
  }

  Future _process(Object res, VRoom room) async {
    switch (res as VRoomItemClickRes) {
      case VRoomItemClickRes.mute:
        await _mute(room);
        break;
      case VRoomItemClickRes.unMute:
        await _unMute(room);
        break;
      case VRoomItemClickRes.delete:
        await _delete(room);
        break;
      case VRoomItemClickRes.report:
        _report(room);
        break;
      case VRoomItemClickRes.leave:
        _groupLeave(room);
        break;
    }
  }

  Future openForGroup(VRoom room) async {
    final res = await VAppAlert.showModalSheetWithActions(
      content: [
        if (room.isMuted) _unMuteItem() else _muteItem(),
        _leaveItem(),
        _deleteItem(),
      ],
      context: context,
      cancelLabel: S.of(context).cancel,
    );
    if (res == null) return;
    _process(
      res.id,
      room,
    );
  }

  Future openForBroadcast(
    VRoom room,
  ) async {
    final res = await VAppAlert.showModalSheetWithActions(
      content: [
        _deleteItem(),
      ],
      context: context,
      cancelLabel: S.of(context).cancel,
    );
    if (res == null) return;
    _process(res.id, room);
  }

  Future _mute(VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.mute(room.id);
      },
      onSuccess: (response) {
        //VAppAlert.showOverlaySupport(title: "Chat muted");
      },
    );
  }

  Future _unMute(VRoom room) async {
    await vSafeApiCall(
      request: () async {
        await _provider.unMute(room.id);
      },
      onSuccess: (response) {
        //VAppAlert.showOverlaySupport(title: "Chat un muted");
      },
    );
  }

  Future _delete(VRoom room) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).deleteYouCopy,
      content: S.of(context).areYouSureToPermitYourCopyThisActionCantUndo,
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await _provider.deleteRoom(room.id);
      },
      onSuccess: (response) {},
    );
  }

  Future _groupLeave(VRoom room) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).areYouSureToLeaveThisGroupThisActionCantUndo,
      content: S.of(context).leaveGroupAndDeleteYourMessageCopy,
    );
    if (res != 1) return;
    await vSafeApiCall(
      request: () async {
        await _provider.deleteRoom(room.id);
        await _provider.groupLeave(room.id);
      },
      onSuccess: (response) async {},
    );
  }

  Future openForOrder(VRoom room) async {
    final res = await VAppAlert.showModalSheetWithActions(
      content: [
        _deleteItem(),
      ],
      cancelLabel: S.of(context).cancel,
      context: context,
    );
    if (res == null) return;
    _process(res.id, room);
  }

  Future _report(VRoom room) async {
    if (VChatController.I.vChatConfig.onReportUserPress != null) {
      unawaited(VChatController.I.vChatConfig.onReportUserPress!(
        context,
        room.peerId ?? room.id,
      ));
    }
  }
}
