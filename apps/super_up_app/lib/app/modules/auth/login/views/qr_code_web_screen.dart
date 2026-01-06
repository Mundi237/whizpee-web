import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../../core/api_service/auth/auth_api_service.dart';
import '../../../../core/api_service/profile/profile_api_service.dart';
import '../controllers/login_controller.dart';

class QrCodeWebScreen extends StatefulWidget {
  const QrCodeWebScreen({
    super.key,
  });

  @override
  State<QrCodeWebScreen> createState() => _QrCodeWebScreenState();
}

class _QrCodeWebScreenState extends State<QrCodeWebScreen> {
  Timer? autoCheckTimer;
  Timer? renewTimerTimer;
  late final LoginController controller;
  final deviceHelper = DeviceInfoHelper();
  String? qrCodeData;

  @override
  void initState() {
    controller = LoginController(
      GetIt.I.get<AuthApiService>(),
      GetIt.I.get<ProfileApiService>(),
    );
    getQrImageData(context);
    setUpAutoRenewTimer();
    _startListen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 60),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.wallet, color: Colors.green, size: 40),
                  SizedBox(width: 10),
                  Text(
                    SConstants.appName,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Log into ${SConstants.appName} Web',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
                Text(
                S.of(context).messagePrivatelyWithFriendsAndFamily
                ,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: _getQrWidget(),
              ),
              const SizedBox(height: 20),
                Text(
                S.of(context).openAppOnYourPhoneInstructions,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void setUpAutoRenewTimer() async {
    renewTimerTimer = Timer.periodic(
      Duration(seconds: 25),
      (timer) {
        getQrImageData(context);
      },
    );
  }

  void _startListen(BuildContext context) async {
    autoCheckTimer = Timer.periodic(
      Duration(seconds: 6),
      (timer) {
        if (qrCodeData == null) return;
        vSafeApiCall(
          request: () async {
            timer.cancel();
            await controller.authService.checkWebScanLogin(qrCodeData!);
            await controller.loginWithQrCode(context, qrCodeData!);
          },
          onSuccess: (response) {
            timer.cancel();
          },
          onError: (exception, trace) {
            _startListen(context);
          },
        );
      },
    );
  }

  Future<void> getQrImageData(BuildContext context) async {
    vSafeApiCall<String>(
      request: () async {
        return controller.getWebScan();
      },
      onSuccess: (response) {
        setState(() {
          qrCodeData = response;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    autoCheckTimer?.cancel();
    renewTimerTimer?.cancel();
  }

  Widget _getQrWidget() {
    if (qrCodeData == null) {
      return SizedBox(
        height: 300,
        width: 300,
        child: CircularProgressIndicator.adaptive(),
      );
    } else {
      return QrImageView(
        data: qrCodeData!,
        version: QrVersions.auto,
        size: 300.0,
      );
    }
  }
}
