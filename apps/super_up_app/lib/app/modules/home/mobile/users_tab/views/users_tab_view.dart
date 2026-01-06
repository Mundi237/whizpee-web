// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loadmore/loadmore.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../core/app_config/app_config_controller.dart';
import '../controllers/users_tab_controller.dart';

class UsersTabView extends StatefulWidget {
  const UsersTabView({super.key});

  @override
  State<UsersTabView> createState() => _UsersTabViewState();
}

class _UsersTabViewState extends State<UsersTabView> {
  late final UsersTabController controller;

  @override
  void initState() {
    super.initState();
    controller = GetIt.I.get<UsersTabController>();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
              largeTitle: Text(
                S.of(context).users,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: CupertinoColors.systemBackground.resolveFrom(context),
                child: Column(
                  children: [
                    _buildSearchBar(context),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              AdsBannerWidget(
                adsId: VPlatforms.isAndroid
                    ? SConstants.androidBannerAdsUnitId
                    : SConstants.iosBannerAdsUnitId,
                isEnableAds: VAppConfigController.appConfig.enableAds,
              ),
              Expanded(
                child: ValueListenableBuilder<SLoadingState<List<SSearchUser>>>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    return VAsyncWidgetsBuilder(
                      loadingState: value.loadingState,
                      onRefresh: controller.getUsersDataFromApi,
                      successWidget: () {
                        if (controller.data.isEmpty) {
                          return _buildEmptyState(context);
                        }
                        return RefreshIndicator(
                          onRefresh: controller.getUsersDataFromApi,
                          child: LoadMore(
                            onLoadMore: controller.onLoadMore,
                            isFinish: controller.isFinishLoadMore,
                            textBuilder: (status) => "",
                            child: ListView.builder(
                              cacheExtent: 300,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              itemBuilder: (context, index) {
                                final item = controller.data[index];
                                return SUserItem(
                                  onTap: () =>
                                      controller.onItemPress(item, context),
                                  baseUser: item.baseUser,
                                  hasBadge: item.hasBadge,
                                  subtitle: item.getUserBio,
                                  showOnlineStatus: false,
                                  isOnline: false,
                                );
                              },
                              itemCount: controller.data.length,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CupertinoSearchTextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            placeholder: S.of(context).searchUsers,
            style: TextStyle(
              color: CupertinoColors.label.resolveFrom(context),
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            if (controller.isSearchLoading && controller.searchController.text.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CupertinoActivityIndicator(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).searching,
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }



  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.person_2,
            size: 80,
            color: CupertinoColors.tertiaryLabel.resolveFrom(context),
          ),
          const SizedBox(height: 16),
          Text(
            controller.searchController.text.isNotEmpty
                ? S.of(context).noUsersFound
                : S.of(context).noUsers,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
          Text(
            controller.searchController.text.isNotEmpty
                ? S.of(context).tryDifferentSearch
                : S.of(context).usersWillAppearHere,
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
