// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
import 'package:super_up/app/core/widgets/app_header_logo.dart';
import 'package:super_up/v_chat_v2/translations.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import '../controllers/rooms_tab_controller.dart';

class RoomsTabView extends StatefulWidget {
  const RoomsTabView({super.key});

  @override
  State<RoomsTabView> createState() => _RoomsTabViewState();
}

class _RoomsTabViewState extends State<RoomsTabView>
    with SingleTickerProviderStateMixin {
  late final RoomsTabController controller;
  late AnimationController _floatController;
  final config = VAppConfigController.appConfig;
  bool _showQuickActions = false;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<RoomsTabController>();
    controller.onInit();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    // Debug: Vérifier la configuration
    print('📋 Config allowCreateGroup: ${config.allowCreateGroup}');
    print('📋 Config allowCreateBroadcast: ${config.allowCreateBroadcast}');
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _toggleQuickActions() {
    HapticFeedback.lightImpact();
    setState(() {
      _showQuickActions = !_showQuickActions;
    });
  }

  void _onQuickAction(String action) {
    HapticFeedback.mediumImpact();
    setState(() {
      _showQuickActions = false;
    });

    switch (action) {
      case 'new_chat':
        controller.createNewChat(context);
        break;
      case 'new_group':
        controller.createNewGroup(context);
        break;
      case 'new_broadcast':
        controller.createNewBroadcast(context);
        break;
    }
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
              Column(
                children: [
                  // Premium Header with glassmorphism
                  AppHeaderLogo(
                    icon: Icons.chat_bubble_rounded,
                    title: S.of(context).chats,
                    actions: [
                      // Search button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          controller.onSearchClicked(context);
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
                            Icons.search_rounded,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Quick actions button
                      GestureDetector(
                        onTap: _toggleQuickActions,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: _showQuickActions
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.primaryGreen,
                                      AppTheme.primaryGreen
                                          .withValues(alpha: 0.8),
                                    ],
                                  )
                                : null,
                            color: _showQuickActions
                                ? null
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _showQuickActions
                                  ? AppTheme.primaryGreen
                                  : Colors.white.withValues(alpha: 0.25),
                            ),
                            boxShadow: _showQuickActions
                                ? [
                                    BoxShadow(
                                      color: AppTheme.primaryGreen
                                          .withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: AnimatedRotation(
                            turns: _showQuickActions ? 0.125 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.add_rounded,
                              color: _showQuickActions
                                  ? Colors.white
                                  : AppTheme.primaryGreen,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Connection status indicator
                  _buildConnectionStatus(),
                  // Chat list
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: VChatPage(
                            language: vRoomLanguageModel(context),
                            onCreateNewChat: () {
                              print('🔵 onCreateNewChat tapped');
                              controller.createNewChat(context);
                            },
                            onCreateNewBroadcast: () {
                              print('🔵 onCreateNewBroadcast tapped');
                              controller.createNewBroadcast(context);
                            },
                            onSearchClicked: () {
                              print('🔵 onSearchClicked tapped');
                              controller.onSearchClicked(context);
                            },
                            onCreateNewGroup: () {
                              print('🔵 onCreateNewGroup tapped');
                              controller.createNewGroup(context);
                            },
                            appBar: null,
                            showDisconnectedWidget: false,
                            controller: controller.vRoomController,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Floating Quick Actions
              if (_showQuickActions) _buildFloatingQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return StreamBuilder<VSocketStatusEvent>(
      stream: VChatController.I.nativeApi.streams.socketStatusStream,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.isConnected) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.withValues(alpha: 0.1),
                Colors.orange.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.orange.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(Colors.orange.shade400),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    S.of(context).connecting,
                    style: TextStyle(
                      color: Colors.orange.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0);
      },
    );
  }

  Widget _buildFloatingQuickActions() {
    return Positioned(
      top: 120,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.15),
              Colors.white.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFloatingAction(
                  icon: Icons.person_add_rounded,
                  label: 'Nouveau chat',
                  onTap: () => _onQuickAction('new_chat'),
                ),
                if (config.allowCreateGroup) ...[
                  const SizedBox(height: 12),
                  _buildFloatingAction(
                    icon: Icons.group_add_rounded,
                    label: 'Créer un groupe',
                    onTap: () => _onQuickAction('new_group'),
                  ),
                ],
                if (config.allowCreateBroadcast) ...[
                  const SizedBox(height: 12),
                  _buildFloatingAction(
                    icon: Icons.campaign_rounded,
                    label: 'Diffusion',
                    onTap: () => _onQuickAction('new_broadcast'),
                  ),
                ],
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 200.ms)
          .scale(begin: const Offset(0.8, 0.8))
          .slideX(begin: 0.3, end: 0),
    );
  }

  Widget _buildFloatingAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryGreen,
                    AppTheme.primaryGreen.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isPrimary ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary
                ? AppTheme.primaryGreen
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : AppTheme.primaryGreen,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isPrimary
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
