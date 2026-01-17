// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
import 'package:super_up/app/core/widgets/app_header_logo.dart';
import 'package:super_up/app/modules/home/mobile/calls_tab/controllers/calls_tab_controller.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import 'call_item.dart';

class CallsTabView extends StatefulWidget {
  const CallsTabView({super.key});

  @override
  State<CallsTabView> createState() => _CallsTabViewState();
}

class _CallsTabViewState extends State<CallsTabView>
    with SingleTickerProviderStateMixin {
  late final CallsTabController controller;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<CallsTabController>();
    controller.onInit();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;

    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0D0D0D),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF2D1B4E),
                  ]
                : [
                    const Color(0xFF000000),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF3D2257),
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background glassmorphism circles
              Positioned(
                top: -100,
                right: -100,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 280 + (30 * _floatController.value),
                      height: 280 + (30 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGreen.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -120,
                left: -80,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 300 - (30 * _floatController.value),
                      height: 300 - (30 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Main content
              RefreshIndicator(
                onRefresh: () async {
                  HapticFeedback.mediumImpact();
                  controller.getCalls();
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Premium Header with AppHeaderLogo
                    SliverToBoxAdapter(
                      child: AppHeaderLogo(
                        icon: Icons.call_rounded,
                        title: S.of(context).calls,
                        actions: [
                          // Clear calls button
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              controller.clearCalls(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red.shade400,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ads Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: AdsBannerWidget(
                          adsId: VPlatforms.isAndroid
                              ? SConstants.androidBannerAdsUnitId
                              : SConstants.iosBannerAdsUnitId,
                          isEnableAds: VAppConfigController.appConfig.enableAds,
                        ),
                      ),
                    ),
                    // Calls List
                    SliverToBoxAdapter(
                      child: _buildCallsList(),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: ValueListenableBuilder<SLoadingState<List<VCallHistory>>>(
            valueListenable: controller,
            builder: (_, value, __) {
              return VAsyncWidgetsBuilder(
                loadingState: value.loadingState,
                onRefresh: controller.getCalls,
                loadingWidget: () => _buildLoadingState(),
                errorWidget: () => _buildErrorState(),
                successWidget: () {
                  if (value.data.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return CallItem(
                        callHistory: value.data[index],
                        onLongPress: () =>
                            controller.onLongPress(context, value.data[index]),
                        onPress: () {
                          VChatController.I.roomApi.openChatWith(
                            peerId: value.data[index].caller.id,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    itemCount: value.data.length,
                  );
                },
              );
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: AppTheme.primaryGreen,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Chargement des appels...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red.shade400,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Impossible de charger les appels',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.getCalls();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.call_outlined,
                size: 48,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun appel récent',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vos appels récents apparaîtront ici',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
