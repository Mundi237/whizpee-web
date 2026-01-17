// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:loadmore/loadmore.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_platform/v_platform.dart';

import '../../../core/api_service/profile/profile_api_service.dart';
import '../controllers/choose_members_controller.dart';

class ChooseMembersView extends StatefulWidget {
  final VoidCallback onCloseSheet;
  final Function(List<SBaseUser> selectedUsers) onDone;
  final String? groupId;
  final String? broadcastId;
  final int maxCount;

  const ChooseMembersView({
    super.key,
    required this.onCloseSheet,
    required this.onDone,
    this.groupId,
    this.broadcastId,
    required this.maxCount,
  });

  @override
  State<ChooseMembersView> createState() => _ChooseMembersViewState();
}

class _ChooseMembersViewState extends State<ChooseMembersView>
    with SingleTickerProviderStateMixin {
  late final ChooseMembersController controller;
  late AnimationController _floatController;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    controller = ChooseMembersController(
      GetIt.I.get<ProfileApiService>(),
      widget.onDone,
      widget.groupId,
      widget.broadcastId,
    );
    controller.onInit();

    _floatController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
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
                  // Selected members preview
                  _buildSelectedMembersPreview(),
                  // Members list
                  Expanded(
                    child: _buildMembersList(),
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
              widget.onCloseSheet();
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
                Icons.close_rounded,
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
                          Icons.group_add_rounded,
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
                              S.of(context).appMembers,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Sélectionnez jusqu\'à ${widget.maxCount} membres',
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
          const SizedBox(width: 16),
          // Next button
          ValueListenableBuilder<SLoadingState<List<SSelectableUser>>>(
            valueListenable: controller,
            builder: (_, value, ___) {
              final hasSelection = controller.isThereSelection;
              return GestureDetector(
                onTap: hasSelection
                    ? () {
                        HapticFeedback.mediumImpact();
                        controller.onNext(context);
                      }
                    : null,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: hasSelection ? 20 : 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: hasSelection
                        ? LinearGradient(
                            colors: [
                              AppTheme.primaryGreen,
                              AppTheme.primaryGreen.withValues(alpha: 0.8),
                            ],
                          )
                        : null,
                    color: hasSelection
                        ? null
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasSelection
                          ? AppTheme.primaryGreen
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                    boxShadow: hasSelection
                        ? [
                            BoxShadow(
                              color:
                                  AppTheme.primaryGreen.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.of(context).next,
                        style: TextStyle(
                          color: hasSelection
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hasSelection) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${controller.selectedUsers.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
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
              controller: controller.txtController,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                controller.onSearchChanged(value);
              },
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText:
                    controller.contactService.getSearchLabelForUsersSearch(),
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

  Widget _buildSelectedMembersPreview() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        if (!controller.isThereSelection) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryGreen.withValues(alpha: 0.1),
                AppTheme.primaryGreen.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people_rounded,
                        color: AppTheme.primaryGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Membres sélectionnés (${controller.selectedUsers.length}/${widget.maxCount})',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final selectedUser = controller.selectedUsers[index];
                        return Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.primaryGreen
                                          .withValues(alpha: 0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: VCircleAvatar(
                                    vFileSource: VPlatformFile.fromUrl(
                                      networkUrl: selectedUser
                                          .searchUser.baseUser.userImage,
                                    ),
                                    radius: 25,
                                  ),
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      controller.unSelectUser(selectedUser);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 60,
                              child: Text(
                                selectedUser.searchUser.baseUser.fullName
                                    .split(" ")
                                    .first,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: controller.selectedUsers.length,
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

  Widget _buildMembersList() {
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
          child: ValueListenableBuilder<SLoadingState<List<SSelectableUser>>>(
            valueListenable: controller,
            builder: (_, value, ___) => VAsyncWidgetsBuilder(
              loadingState: value.loadingState,
              onRefresh: controller.getData,
              successWidget: () {
                if (value.data.isEmpty) {
                  return _buildEmptyState();
                }

                return LoadMore(
                  onLoadMore: controller.onLoadMore,
                  isFinish: controller.isFinishLoadMore,
                  textBuilder: (status) => "",
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
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
                      final item = value.data[index];
                      return _buildMemberItem(item, index);
                    },
                    itemCount: value.data.length,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildMemberItem(SSelectableUser item, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (item.isSelected == false) {
          controller.selectUser(item);
        } else {
          controller.unSelectUser(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isSelected
              ? AppTheme.primaryGreen.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isSelected
                ? AppTheme.primaryGreen.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.08),
            width: item.isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.isSelected
                          ? AppTheme.primaryGreen.withValues(alpha: 0.5)
                          : Colors.white.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: VCircleAvatar(
                    vFileSource: VPlatformFile.fromUrl(
                      networkUrl: item.searchUser.baseUser.userImage,
                    ),
                    radius: 24,
                  ),
                ),
                if (item.isSelected)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.searchUser.baseUser.fullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: item.isSelected
                          ? AppTheme.primaryGreen
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${item.searchUser.baseUser.fullName.toLowerCase().replaceAll(' ', '')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: item.isSelected
                          ? AppTheme.primaryGreen.withValues(alpha: 0.7)
                          : Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            // Custom checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.isSelected
                    ? AppTheme.primaryGreen
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isSelected
                      ? AppTheme.primaryGreen
                      : Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: item.isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ).animate().fadeIn(
            duration: 300.ms,
            delay: Duration(milliseconds: index * 50),
          ),
    );
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
              Icons.people_outline_rounded,
              size: 48,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun contact trouvé',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Essayez de rechercher avec d\'autres termes',
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
