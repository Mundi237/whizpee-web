// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numeral/numeral.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../core/api_service/api_service.dart';
import '../../../core/models/admin.dart';

class DashGridItemModel {
  final int value;
  final IconData iconData;
  final Widget? iconWidget;
  final String title;

  const DashGridItemModel({
    required this.value,
    required this.iconData,
    this.iconWidget,
    required this.title,
  });

  String get valueFormat {
    return value.numeral(digits: 2);
  }
}

class DashboardController extends SLoadingController<MainDashBoardModel> {
  final adminApi = GetIt.I.get<SAdminApiService>();

  final usersListItem = <DashGridItemModel>[];
  final devicesListItem = <DashGridItemModel>[];
  final countryListItem = <DashGridItemModel>[];
  final statistics = <DashGridItemModel>[];
  final messagesCounter = <DashGridItemModel>[];
  final roomCounter = <DashGridItemModel>[];

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  DashboardController()
      : super(SLoadingState<MainDashBoardModel>(MainDashBoardModel.empty()));

  Future getData() async {
    await vSafeApiCall<MainDashBoardModel>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return adminApi.getDashboard();
      },
      onSuccess: (response) {
        value.data = response;
        _setUsersListItems(response.usersData);
        _setDevicesListItems(response.usersDevices);
        _setCountries(response.usersCountries);
        _setStatistics(response.statistics);
        _setMessagesCounter(response.messagesCounter);
        _setRoomCounter(response.roomCounter);
        setStateSuccess();
      },
      onError: (exception) {},
    );
  }

  void _setUsersListItems(UserData data) {
    usersListItem.addAll(
      [
        DashGridItemModel(
          value: data.totalUsersCount,
          iconData: CupertinoIcons.person,
          title: S.current.total,
        ),
        DashGridItemModel(
          value: data.online,
          iconData: CupertinoIcons.sun_min_fill,
          title: S.current.online,
        ),
        DashGridItemModel(
          value: data.banned,
          iconData: CupertinoIcons.stop_circle_fill,
          title: S.current.blocked,
        ),
        DashGridItemModel(
          value: data.deleted,
          iconData: CupertinoIcons.delete,
          title: S.current.deleted,
        ),
        DashGridItemModel(
          value: data.allVerifiedUsersCount,
          iconData: Icons.verified,
          title: S.current.verified,
        ),
        DashGridItemModel(
          value: data.userStatusCounter['pending']!,
          iconData: CupertinoIcons.time,
          title: S.current.pending,
        ),
        DashGridItemModel(
          value: data.userStatusCounter['accepted']!,
          iconData: Icons.done,
          title: S.current.accepted,
        ),
        DashGridItemModel(
          value: data.userStatusCounter['notAccepted']!,
          iconData: CupertinoIcons.stop_circle_fill,
          title: S.current.notAccepted,
        ),
      ],
    );
  }

  void _setDevicesListItems(UserDevices response) {
    devicesListItem.addAll(
      [
        DashGridItemModel(
          value: response.web,
          iconData: Icons.desktop_mac_sharp,
          title: S.current.web,
        ),
        DashGridItemModel(
          value: response.android,
          iconData: Icons.phone_android,
          title: S.current.android,
        ),
        DashGridItemModel(
          value: response.ios,
          iconData: Icons.phone_android,
          title: S.current.ios,
        ),
        DashGridItemModel(
          value: response.mac,
          iconData: Icons.computer,
          title: S.current.macOs,
        ),
        DashGridItemModel(
          value: response.windows,
          iconData: Icons.computer,
          title: S.current.windows,
        ),
        DashGridItemModel(
          value: response.other,
          iconData: Icons.api,
          title: S.current.other,
        ),
      ],
    );
  }

  void _setCountries(List<UserCountries> response) {
    countryListItem.addAll(response.map((e) {
      return DashGridItemModel(
        value: e.count,
        title: e.country.name,
        iconData: Icons.language,
        iconWidget: Text(e.country.emoji, style: const TextStyle(fontSize: 50)),
      );
    }).toList());
  }

  void _setStatistics(Statistics s) {
    statistics.add(
      DashGridItemModel(
        value: s.visits,
        iconData: Icons.border_all_outlined,
        title: S.current.totalVisits,
      ),
    );
    statistics.add(
      DashGridItemModel(
        value: s.webVisits,
        iconData: Icons.computer,
        title: S.current.web,
      ),
    );
    statistics.add(
      DashGridItemModel(
        value: s.otherVisits,
        iconData: Icons.api,
        title: S.current.other,
      ),
    );
    statistics.add(
      DashGridItemModel(
        value: s.androidVisits,
        iconData: Icons.android,
        title: S.current.android,
      ),
    );
    statistics.add(
      DashGridItemModel(
        value: s.iosVisits,
        iconData: Icons.phone_iphone,
        title: S.current.ios,
      ),
    );
  }

  void _setMessagesCounter(MessagesCounter messagesCounter) {
    this.messagesCounter.addAll([
      DashGridItemModel(
        value: messagesCounter.messages,
        iconData: CupertinoIcons.chat_bubble_text,
        title: S.current.totalMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.textMessages,
        iconData: Icons.text_fields,
        title: S.current.textMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.imageMessages,
        iconData: Icons.image,
        title: S.current.imageMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.videoMessages,
        iconData: CupertinoIcons.videocam_circle,
        title: S.current.videoMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.voiceMessages,
        iconData: CupertinoIcons.mic,
        title: S.current.voiceMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.fileMessages,
        iconData: CupertinoIcons.folder_fill,
        title: S.current.fileMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.infoMessages,
        iconData: CupertinoIcons.info,
        title: S.current.infoMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.voiceCallMessages,
        iconData: CupertinoIcons.phone_fill,
        title: S.current.voiceCallMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.videoCallMessages,
        iconData: CupertinoIcons.videocam_circle,
        title: S.current.videoCallMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.locationMessages,
        iconData: CupertinoIcons.location,
        title: S.current.locationMessages,
      ),
      DashGridItemModel(
        value: messagesCounter.allDeletedMessages,
        iconData: CupertinoIcons.delete,
        title: S.current.allDeletedMessages,
      ),
    ]);
  }

  void _setRoomCounter(RoomCounter roomCounter) {
    this.roomCounter.addAll([
      DashGridItemModel(
        value: roomCounter.total,
        iconData: CupertinoIcons.chat_bubble_2,
        title: S.current.total,
      ),
      DashGridItemModel(
        value: roomCounter.single,
        iconData: CupertinoIcons.person,
        title: S.current.directChat,
      ),
      DashGridItemModel(
        value: roomCounter.group,
        iconData: CupertinoIcons.group,
        title: S.current.group,
      ),
      DashGridItemModel(
        value: roomCounter.broadcast,
        iconData: CupertinoIcons.speaker_2,
        title: S.current.broadcast,
      ),
    ]);
  }
}
