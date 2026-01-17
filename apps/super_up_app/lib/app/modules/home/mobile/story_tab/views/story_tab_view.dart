// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/home/mobile/story_tab/views/widgets/story_widget.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:super_up/app/core/widgets/app_header_logo.dart';

import '../../../../../core/models/story/story_model.dart';
import '../../../../story/story_view_page/story_view_page.dart';
import '../controllers/story_tab_controller.dart';
import 'package:s_translation/generated/l10n.dart';

class StoryTabView extends StatefulWidget {
  const StoryTabView({super.key});

  @override
  State<StoryTabView> createState() => _StoryTabViewState();
}

class _StoryTabViewState extends State<StoryTabView>
    with SingleTickerProviderStateMixin {
  late final StoryTabController controller;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<StoryTabController>();
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
              // Floating glassmorphism circles
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
                  controller.getStories();
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Premium Header with AppHeaderLogo
                    SliverToBoxAdapter(
                      child: AppHeaderLogo(
                        icon: Icons.auto_stories_rounded,
                        title: S.of(context).stories,
                        actions: [
                          // Add new story button
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              controller.toCreateStory(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryGreen,
                                    AppTheme.primaryGreen
                                        .withValues(alpha: 0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primaryGreen,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // My Story Section
                    SliverToBoxAdapter(
                      child: _buildMyStorySection(),
                    ),
                    // Recent Updates Header
                    SliverToBoxAdapter(
                      child: _buildRecentUpdatesHeader(),
                    ),
                    // Stories List
                    SliverToBoxAdapter(
                      child: _buildStoriesList(),
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

  Widget _buildMyStorySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ValueListenableBuilder<SLoadingState<StoryTabState>>(
        valueListenable: controller,
        builder: (_, value, __) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: StoryWidget(
                  isMe: true,
                  toCreateStory: () {
                    HapticFeedback.lightImpact();
                    controller.toCreateStory(context);
                  },
                  isLoading: value.data.isMyStoriesLoading,
                  onTap: (storyModel) {
                    if (storyModel.stories.isEmpty) return;
                    HapticFeedback.selectionClick();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StoryViewpage(
                          storyModel: storyModel,
                          onComplete: (current) {},
                          onDelete: (storyId) async {
                            controller.removeStoryFromLocalState(storyId);
                            await controller.refreshStoriesAfterOperation();
                          },
                        ),
                      ),
                    );
                  },
                  storyModel: value.data.myStories,
                  onLongTap: (UserStoryModel storyModel) {},
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentUpdatesHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.update_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            S.of(context).recentUpdate,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesList() {
    return ValueListenableBuilder<SLoadingState<StoryTabState>>(
      valueListenable: controller,
      builder: (_, value, __) {
        return VAsyncWidgetsBuilder(
          loadingState: value.loadingState,
          onRefresh: controller.getStories,
          loadingWidget: () => _buildLoadingState(),
          errorWidget: () => _buildErrorState(),
          successWidget: () {
            if (value.data.allStories.isEmpty) {
              return _buildEmptyState();
            }

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
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return StoryWidget(
                        isMe: false,
                        onLongTap: (storyModel) {},
                        onTap: (storyModel) {
                          if (storyModel.stories.isEmpty) return;
                          HapticFeedback.selectionClick();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StoryViewpage(
                                storyModel: storyModel,
                                onComplete: _onStoryComplete,
                                onDelete: storyModel.userData.isMe
                                    ? (storyId) async {
                                        controller
                                            .removeStoryFromLocalState(storyId);
                                        await controller
                                            .refreshStoriesAfterOperation();
                                      }
                                    : null,
                              ),
                            ),
                          );
                        },
                        storyModel: value.data.allStories[index],
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    itemCount: value.data.allStories.length,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              color: AppTheme.primaryGreen,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Chargement des stories...',
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
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
              'Impossible de charger les stories',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.getStories();
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
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
                Icons.auto_stories_outlined,
                size: 48,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune story disponible',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Soyez le premier à partager une story !',
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

  Future _onStoryComplete(UserStoryModel current) async {
    final all = controller.data.allStories;
    final index = all.indexOf(current);
    if (index == -1) return;

    final nextIndex = index + 1;
    if (nextIndex >= all.length) {
      return;
    }

    final nextStory = all[nextIndex];
    if (nextStory.stories.isEmpty) {
      return;
    }

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoryViewpage(
          storyModel: nextStory,
          onComplete: _onStoryComplete,
          onDelete: nextStory.userData.isMe
              ? (storyId) async {
                  controller.removeStoryFromLocalState(storyId);
                  await controller.refreshStoriesAfterOperation();
                }
              : null,
        ),
      ),
    );
  }
}
