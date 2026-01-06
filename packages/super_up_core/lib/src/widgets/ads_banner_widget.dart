// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
 import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class AdsBannerWidget extends StatefulWidget {
  final String? adsId;
  final bool isEnableAds;

  const AdsBannerWidget({
    super.key,
    required this.adsId,
    required this.isEnableAds,
  });

  @override
  State<StatefulWidget> createState() {
    return _AdsBannerWidgetState();
  }

  /// Loads an interstitial ad.
  static void loadAd(
    String? adId, {
    required bool enableAds,
  }) async {
    if (!enableAds) return;
    if (VPlatforms.isMobile && !AppAuth.myProfile.isPrime && adId != null) {
      // await InterstitialAd.load(
      //   adUnitId: adId,
      //   request: const AdRequest(),
      //   adLoadCallback: InterstitialAdLoadCallback(
      //     // Called when an ad is successfully received.
      //     onAdLoaded: (ad) async {
      //       ad.fullScreenContentCallback = FullScreenContentCallback(
      //         // Called when the ad showed the full screen content.
      //         onAdShowedFullScreenContent: (ad) {},
      //         // Called when an impression occurs on the ad.
      //         onAdImpression: (ad) {},
      //         // Called when the ad failed to show full screen content.
      //         onAdFailedToShowFullScreenContent: (ad, err) {
      //           // Dispose the ad here to free resources.
      //           ad.dispose();
      //         },
      //         // Called when the ad dismissed full screen content.
      //         onAdDismissedFullScreenContent: (ad) {
      //           // Dispose the ad here to free resources.
      //           ad.dispose();
      //         },
      //         // Called when a click is recorded for an ad.
      //         onAdClicked: (ad) {},
      //       );
      //       await ad.show();
      //       debugPrint('$ad loaded.');
      //       // Keep a reference to the ad so you can show it later.
      //     },
      //     // Called when an ad request failed.
      //     onAdFailedToLoad: (LoadAdError error) {
      //       debugPrint('InterstitialAd failed to load: $error');
      //     },
      //   ),
      // );
    }
  }
}

class _AdsBannerWidgetState extends State<AdsBannerWidget> {
  // BannerAd? _bannerAd;
  // BannerAdListener? _listener;
  // bool _bannerReady = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   if (VPlatforms.isMobile &&
  //       !AppAuth.myProfile.isPrime &&
  //       widget.adsId != null &&
  //       widget.isEnableAds) {
  //     _listener = BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _bannerReady = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, err) async {
  //         if (_bannerReady) return;
  //         _bannerAd!.load();
  //       },
  //     );
  //     _init();
  //   }
  // }
  //
  // Future<void> _init() {
  //   _bannerAd = CustomBannerAd(
  //     listener: _listener!,
  //     adUnitId: widget.adsId!,
  //   );
  //   return _bannerAd!.load();
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   _bannerAd?.dispose();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   if (_bannerReady && !kIsWeb) {
  //     return SizedBox(
  //       width: MediaQuery.of(context).size.width,
  //       height: _bannerAd!.size.height.toDouble(),
  //       child: AdWidget(
  //         ad: _bannerAd!,
  //       ),
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// class CustomBannerAd extends BannerAd {
//   CustomBannerAd({
//     required super.listener,
//     required super.adUnitId,
//   }) : super(
//           request: const AdRequest(),
//           size: const AdSize(width: 400, height: 60),
//         );
// }
