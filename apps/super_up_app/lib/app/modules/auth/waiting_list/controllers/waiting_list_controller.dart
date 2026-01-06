// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/api_service/api_service.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../home/home_controller/views/home_view.dart';
import '../../../splash/views/splash_view.dart';
import '../states/waiting_list_state.dart';

class WaitingListController extends SLoadingController<WaitingListState?> {
  final txtController = TextEditingController();

  WaitingListController() : super(SLoadingState(null));
  final _profileApi = GetIt.I.get<ProfileApiService>();

  @override
  void onClose() {
    txtController.dispose();
  }

  @override
  void onInit() {}

  Future<void> refreshProfile(BuildContext context) async {
    await vSafeApiCall<SMyProfile>(
      onError: (exception) {
        VAppAlert.showErrorSnackBar(
          message: exception.toString(),
          context: context,
        );
      },
      request: () async {
        return _profileApi.getMyProfile();
      },
      onSuccess: (SMyProfile response) async {
        if (response.registerStatus == RegisterStatus.accepted) {
          if (context.mounted) {
            VAppAlert.showSuccessSnackBar(
              message: S.of(context).congregationsYourAccountHasBeenAccepted,
              context: context,
            );
          }
          await VAppPref.setMap(SStorageKeys.myProfile.name, response.toMap());
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            context.toPage(
              const HomeView(),
              removeAll: true,
              withAnimation: true,
            );
          }
        } else {
          if (context.mounted) {
            VAppAlert.showSuccessSnackBar(
              message: S.of(context).yourAccountIsUnderReview,
              context: context,
            );
          }
        }
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: false,
        ignoreNetworkErrors: false,
      ),
    );
  }

  void logout(BuildContext context) {
    vSafeApiCall(
      onLoading: () {
        VAppAlert.showLoading(context: context);
      },
      request: () async {
        await FirebaseAuth.instance.signOut();
        await VChatController.I.profileApi.logout();
        AppAuth.setProfileNull();
        await VAppPref.clear();
      },
      onSuccess: (response) {
        VChatController.I.navigatorKey.currentContext!.toPage(
          const SplashView(),
          withAnimation: false,
          removeAll: true,
        );
        AppAuth.setProfileNull();
      },
      onError: (exception) {
        context.pop();
        VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: exception.message,
        );
      },
    );
  }
}
