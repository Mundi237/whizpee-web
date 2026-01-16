// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class ChatsSearchController extends SLoadingController<List<VRoom>> {
  ChatsSearchController() : super(SLoadingState([]));
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  // Filtre par type de room
  VRoomType? selectedRoomType;

  void setRoomTypeFilter(VRoomType? type) {
    selectedRoomType = type;
    // Relancer la recherche avec le filtre
    onSearch(searchController.text);
  }

  @override
  void onInit() {
    searchFocusNode.requestFocus();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
  }

  void onSearch(String query) async {
    if (query.isEmpty && selectedRoomType == null) {
      value.data = [];
      return;
    }
    vSafeApiCall<List<VRoom>>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        final results = await VChatController.I.nativeApi.local.room
            .searchRoom(text: query);

        // Appliquer le filtre par type si défini
        if (selectedRoomType != null) {
          return results.where((room) {
            switch (selectedRoomType) {
              case VRoomType.s:
                return room.roomType.isSingle;
              case VRoomType.g:
                return room.roomType.isGroup;
              case VRoomType.b:
                return room.roomType.isBroadcast;
              case VRoomType.a:
                return room.isCta;
              default:
                return true;
            }
          }).toList();
        }

        return results;
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      onError: (exception) {
        setStateError();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: true,
        ignoreNetworkErrors: true,
      ),
    );
  }

  void onRoomItemPress(VRoom vRoom, BuildContext context) {
    VChatController.I.vNavigator.messageNavigator.toMessagePage(
      context,
      vRoom,
    );
  }
}
