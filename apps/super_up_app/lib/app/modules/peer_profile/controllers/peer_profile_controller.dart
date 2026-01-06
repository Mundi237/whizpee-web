// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/api_service/api_service.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../core/app_config/app_config_controller.dart';
import '../../report/views/report_page.dart';
import '../mobile/sheet_for_create_group_from_profile.dart';
import '../states/peer_profile_state.dart';

class PeerProfileController extends SLoadingController<PeerProfileModel?> {
  final String peerId;
  final _profileApiService = GetIt.I<ProfileApiService>();

  PeerProfileController(this.peerId) : super(SLoadingState(null));

  @override
  void onClose() {}

  @override
  void onInit() {
    getProfileData();
    AdsBannerWidget.loadAd(
      VPlatforms.isAndroid
          ? SConstants.androidInterstitialId
          : SConstants.iosInterstitialId,
      enableAds: VAppConfigController.appConfig.enableAds,
    );
  }

  void getProfileData() async {
    await vSafeApiCall<PeerProfileModel>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return _profileApiService.peerProfile(peerId);
      },
      onSuccess: (response) async {
        value.data = response;
        setStateSuccess();
      },
      onError: (exception) {
        setStateError();
      },
    );
  }

  void openFullImage(BuildContext context) {
    context.toPage(
      VImageViewer(
        showDownload: true,
        platformFileSource: VPlatformFile.fromUrl(
            networkUrl: data!.searchUser.baseUser.userImage),
        downloadingLabel: S.of(context).downloading,
        successfullyDownloadedInLabel: S.of(context).successfullyDownloadedIn,
      ),
    );
  }

  bool isOpeningChat = false;
  bool isBlockingChat = false;

  bool get isLoading => isOpeningChat || isBlockingChat;

  void openChatWith(BuildContext context) async {
    vSafeApiCall(
      onLoading: () {
        isOpeningChat = true;
        notifyListeners();
      },
      request: () async {
        await VChatController.I.roomApi.openChatWith(
          peerId: peerId,
        );
      },
      onSuccess: (response) {
        isOpeningChat = false;
        notifyListeners();
      },
      onError: (exception) {
        isOpeningChat = false;
        notifyListeners();
      },
    );
  }

  Future<int?> _showBlockDialog(BuildContext context) async {
    if (value.data!.isMeBanner) {
      return 1;
    }
    final res = await VAppAlert.showAskYesNoDialog(
      title: S.of(context).areYouSure,
      content: S.of(context).aboutToBlockUserWithConsequences,
      context: context,
    );
    return res;
  }

  void updateBlock(BuildContext context) async {
    final res = await _showBlockDialog(context);

    if (res != 1) return;
    vSafeApiCall(
      onLoading: () {
        isBlockingChat = true;
        notifyListeners();
      },
      request: () async {
        if (data!.isMeBanner) {
          await VChatController.I.blockApi.unBlockUser(peerId: peerId);
          value.data = value.data!.copyWith(isMeBanner: false);
          notifyListeners();
        } else {
          await VChatController.I.blockApi.blockUser(peerId: peerId);
          value.data = value.data!.copyWith(isMeBanner: true);
          notifyListeners();
        }
      },
      onSuccess: (response) {
        isBlockingChat = false;
        notifyListeners();
      },
      onError: (exception) {
        isBlockingChat = false;
        notifyListeners();
      },
    );
  }

  void reportToAdmin(BuildContext context) async {
    context.toPage(ReportPage(userId: value.data!.searchUser.baseUser.id));
  }

  void createGroupWith(BuildContext context) async {
    final groupRoom = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SheetForCreateGroupFromProfile(
        peer: data!.searchUser.baseUser,
      ),
    ) as VRoom?;
    if (groupRoom == null) {
      return;
    }
    VChatController.I.vNavigator.messageNavigator
        .toMessagePage(context, groupRoom);
  }

  final adUnitId = VPlatforms.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';
}
