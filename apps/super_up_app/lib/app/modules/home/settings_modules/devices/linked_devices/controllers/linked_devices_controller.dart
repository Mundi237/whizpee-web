// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:super_up/app/core/api_service/api_service.dart';
import 'package:super_up/app/core/models/user_device_model.dart';
import 'package:super_up/main.dart';
import 'package:super_up_core/super_up_core.dart';
import '../views/sheet_for_device_status.dart';

class LinkedDevicesController
    extends SLoadingController<List<UserDeviceModel>> {
  final _profileApi = GetIt.I.get<ProfileApiService>();
  final _authApi = GetIt.I.get<AuthApiService>();

  LinkedDevicesController() : super(SLoadingState([]));

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  void getData() async {
    await vSafeApiCall<List<UserDeviceModel>>(
      onLoading: () async {
        setStateLoading();
        update();
      },
      onError: (exception) {
        setStateError();
        update();
      },
      request: () async {
        return _profileApi.getMyDevices();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: false,
        ignoreNetworkErrors: false,
      ),
    );
  }

  Future<void> linkDevice(BuildContext context) async {
    String? res = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: BarcodeAppBar(
        appBarTitle: S.of(context).linkByQrCode,
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 2000,
      cameraFace: CameraFace.back,
      scanType: ScanType.qr,
    );
    if (res == null) return;
    try {
      VAppAlert.showLoading(context: navigatorKey.currentState!.context);
      await _authApi.verifyWebScanQr(res);
      await Future.delayed(Duration(seconds: 4));
      navigatorKey.currentState!.context.pop();
      getData();
      VAppAlert.showSuccessSnackBar(
        context: navigatorKey.currentState!.context,
        message: S.current.success,
      );
    } catch (err) {
      navigatorKey.currentState!.context.pop();
      VAppAlert.showErrorSnackBar(
        context: navigatorKey.currentState!.context,
        message: err.toString(),
      );
    }
  }

  Future<void> onDeviceTap(
      BuildContext context, UserDeviceModel deviceModel) async {
    await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SheetForDeviceStatus(
        deviceModel: deviceModel,
      ),
    );
    getData();
  }
}
