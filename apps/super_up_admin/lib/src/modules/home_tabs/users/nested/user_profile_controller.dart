// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_admin/main.dart';
import 'package:super_up_admin/src/core/api_service/api_service.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../../core/models/dash_user/peer_user_info.dart';

class InfoTile {
  final String title;
  final String value;

  InfoTile(this.title, this.value);
}

class UserProfileController extends SLoadingController<PeerUserInfo> {
  final String userID;
  final _adminApiService = GetIt.I.get<SAdminApiService>();

  UserProfileController(this.userID)
      : super(SLoadingState(PeerUserInfo.init()));
  final messages = <InfoTile>[];
  final rooms = <InfoTile>[];

  @override
  void onClose() {}

  BuildContext get context => navigatorKey.currentState!.context;

  @override
  void onInit() {
    getData();
  }

  void getData() async {
    await vSafeApiCall<PeerUserInfo>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return await _adminApiService.getUserInfo(userID);
      },
      onSuccess: (response) {
        value.data = response;
        _setMessages();
        _setRoomCounter();
        setStateSuccess();
      },
      onError:(e,s){
        print(e);
        print(s);
      }

    );
  }

  void _setMessages() {
    messages.clear();
    messages.addAll(
      [
        InfoTile(
          S.of(context).totalMessages,
          value.data.messagesCounter.messages.toString(),
        ),
        InfoTile(
          S.of(context).allDeletedMessages,
          value.data.messagesCounter.allDeletedMessages.toString(),
        ),
        InfoTile(
          S.of(context).voiceCallMessages,
          value.data.messagesCounter.voiceMessages.toString(),
        ),
        InfoTile(
          S.of(context).videoCallMessages,
          value.data.messagesCounter.videoCallMessages.toString(),
        ),
        InfoTile(
          S.of(context).fileMessages,
          value.data.messagesCounter.fileMessages.toString(),
        ),
        InfoTile(
          S.of(context).infoMessages,
          value.data.messagesCounter.infoMessages.toString(),
        ),
        InfoTile(
          S.of(context).locationMessages,
          value.data.messagesCounter.locationMessages.toString(),
        ),
        InfoTile(
          S.of(context).imageMessages,
          value.data.messagesCounter.imageMessages.toString(),
        ),
        InfoTile(
          S.of(context).videoMessages,
          value.data.messagesCounter.videoMessages.toString(),
        ),
        InfoTile(
          S.of(context).voiceMessages,
          value.data.messagesCounter.voiceMessages.toString(),
        ),
      ],
    );
  }

  void _setRoomCounter() {
    rooms.clear();
    rooms.addAll(
      [
        InfoTile(
          S.of(context).totalRooms,
          value.data.roomCounter.total.toString(),
        ),
        InfoTile(
          S.of(context).directRooms,
          value.data.roomCounter.single.toString(),
        ),
        InfoTile(
          S.of(context).group,
          value.data.roomCounter.group.toString(),
        ),
        InfoTile(
          S.of(context).broadcast,
          value.data.roomCounter.broadcast.toString(),
        ),
      ],
    );
  }

  void blockUser(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).userAction,
      content: S.of(context).areYouSure,
    );
    if (res != 1) return;
    await vSafeApiCall(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        if (value.data.user.banTo != null) {
          return await _adminApiService.updateUserData(userID, {
            "banTo": null,
          });
        }
        return await _adminApiService.updateUserData(userID, {
          "banTo": DateTime.now().toUtc().toIso8601String(),
        });
      },
      onSuccess: (response) {},
      onError: (exception) {},
    );
    getData();
  }

  void deleteUser(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).userAction,
      content: S.of(context).areYouSure,
    );
    if (res != 1) return;
    await vSafeApiCall(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        if (value.data.user.deletedAt != null) {
          return await _adminApiService.updateUserData(userID, {
            "deletedAt": null,
          });
        }
        return await _adminApiService.updateUserData(userID, {
          "deletedAt": DateTime.now().toUtc().toIso8601String(),
        });
      },
      onSuccess: (response) {},
      onError: (exception) {},
    );
    getData();
  }

  primeUser(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).userAction,
      content: S.of(context).areYouSure,
    );
    if (res != 1) return;
    await vSafeApiCall(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        if (value.data.user.isPrime) {
          return await _adminApiService.updateUserData(userID, {
            "isPrime": false,
          });
        }
        return await _adminApiService.updateUserData(userID, {
          "isPrime": true,
        });
      },
      onSuccess: (response) {},
      onError: (exception) {},
    );
    getData();
  }

  hasBadgeUser(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).userAction,
      content: S.of(context).areYouSure,
    );
    if (res != 1) return;
    await vSafeApiCall(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        if (value.data.user.hasBadge) {
          return await _adminApiService.updateUserData(userID, {
            "hasBadge": false,
          });
        }
        return await _adminApiService.updateUserData(userID, {
          "hasBadge": true,
        });
      },
      onSuccess: (response) {},
      onError: (exception) {},
    );
    getData();
  }

  acceptUser(BuildContext context) async {
    final res = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).userAction,
      content: S.of(context).areYouSure,
    );
    if (res != 1) return;
    await vSafeApiCall(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return await _adminApiService.updateUserData(userID, {
          "registerStatus": "accepted",
        });
      },
      onSuccess: (response) {},
      onError: (exception) {},
    );
    getData();
  }
}
