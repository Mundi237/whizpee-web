// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../controllers/chats_search_controller.dart';

class ChatsSearchView extends StatefulWidget {
  const ChatsSearchView({super.key});

  @override
  State<ChatsSearchView> createState() => _ChatsSearchViewState();
}

class _ChatsSearchViewState extends State<ChatsSearchView>
    with SingleTickerProviderStateMixin {
  late final ChatsSearchController controller;
  late AnimationController _floatController;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    controller = ChatsSearchController();
    controller.onInit();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    controller.onClose();
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
              Column(
                children: [
                  // Premium Header
                  _buildPremiumHeader(),
                  // Search bar
                  _buildSearchBar(),
                  // Filter chips
                  _buildFilterChips(),
                  // Results
                  Expanded(
                    child: _buildSearchResults(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppTheme.primaryGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recherche',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Trouvez vos conversations',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: _isSearchFocused
              ? AppTheme.primaryGreen.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.15),
          width: _isSearchFocused ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Focus(
            onFocusChange: (focused) {
              setState(() {
                _isSearchFocused = focused;
              });
            },
            child: TextField(
              controller: controller.searchController,
              focusNode: controller.searchFocusNode,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                controller.onSearch(value);
              },
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: S.of(context).search,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search_rounded,
                    color: _isSearchFocused
                        ? AppTheme.primaryGreen
                        : Colors.white.withValues(alpha: 0.6),
                    size: 22,
                  ),
                ),
                suffixIcon: controller.searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          controller.searchController.clear();
                          controller.onSearch('');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.clear_rounded,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 20,
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFilterChip(
            label: 'Tous',
            icon: Icons.chat_rounded,
            isSelected: controller.selectedRoomType == null,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                controller.setRoomTypeFilter(null);
              });
            },
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Contacts',
            icon: Icons.person_rounded,
            isSelected: controller.selectedRoomType == VRoomType.s,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                controller.setRoomTypeFilter(VRoomType.s);
              });
            },
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Annonces',
            icon: Icons.campaign_rounded,
            isSelected: controller.selectedRoomType == VRoomType.a,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                controller.setRoomTypeFilter(VRoomType.a);
              });
            },
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Groupes',
            icon: Icons.group_rounded,
            isSelected: controller.selectedRoomType == VRoomType.g,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                controller.setRoomTypeFilter(VRoomType.g);
              });
            },
          ),
          const SizedBox(width: 12),
          _buildFilterChip(
            label: 'Diffusions',
            icon: Icons.broadcast_on_personal_rounded,
            isSelected: controller.selectedRoomType == VRoomType.b,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                controller.setRoomTypeFilter(VRoomType.b);
              });
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppTheme.primaryGreen,
                    AppTheme.primaryGreen.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryGreen
                : Colors.white.withValues(alpha: 0.15),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
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
          child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (controller.data.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.data.length,
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                itemBuilder: (context, index) {
                  final room = controller.data[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: VRoomItem(
                          room: room,
                          onRoomItemPress: (room) {
                            HapticFeedback.mediumImpact();
                            controller.onRoomItemPress(room, context);
                          },
                          onRoomItemLongPress: (room) {
                            HapticFeedback.heavyImpact();
                          },
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                        duration: 300.ms,
                        delay: Duration(milliseconds: index * 50),
                      );
                },
              );
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            controller.searchController.text.isEmpty
                ? 'Commencez à taper pour rechercher'
                : 'Aucun résultat trouvé',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.searchController.text.isEmpty
                ? 'Recherchez dans vos conversations, contacts et groupes'
                : 'Essayez avec d\'autres mots-clés',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8));
  }
}
