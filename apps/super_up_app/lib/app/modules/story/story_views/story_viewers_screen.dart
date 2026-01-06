// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/api_service/story/story_api_service.dart';
import 'package:super_up/app/core/models/story/story_viewer_model.dart';
import 'package:super_up/app/modules/peer_profile/views/peer_profile_view.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class StoryViewersController
    extends SLoadingController<List<StoryViewerModel>> {
  final String storyId;
  final _api = GetIt.I.get<StoryApiService>();

  StoryViewersController(this.storyId) : super(SLoadingState([]));

  @override
  void onInit() async {
    loadViewers();
  }

  Future<void> loadViewers() async {
    setStateLoading();

    vSafeApiCall(
      request: () async {
        return await _api.getStoryViews(storyId: storyId);
      },
      onSuccess: (viewers) {
        value.data = viewers;
        setStateSuccess();
      },
      onError: (exception) {
        print('Error loading story viewers: $exception');
        if (exception is Error) {
          print('StackTrace: ${exception.stackTrace}');
        }
        setStateError(exception.toString());
      },
    );
  }

  @override
  void onClose() {
    // Clean up resources if needed
  }
}

class StoryViewersScreen extends StatefulWidget {
  final String storyId;

  const StoryViewersScreen({
    super.key,
    required this.storyId,
  });

  @override
  State<StoryViewersScreen> createState() => _StoryViewersScreenState();
}

class _StoryViewersScreenState extends State<StoryViewersScreen> {
  late final StoryViewersController controller;

  @override
  void initState() {
    super.initState();
    controller = StoryViewersController(widget.storyId);
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).storyViewers),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<SLoadingState<List<StoryViewerModel>>>(
          valueListenable: controller,
          builder: (context, state, child) {
            return VAsyncWidgetsBuilder(
              loadingState: state.loadingState,
              onRefresh: controller.loadViewers,
              errorWidget: () {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.withValues(alpha: 0.7),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).failedToLoadViewers,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: controller.loadViewers,
                        icon: const Icon(Icons.refresh),
                        label: Text(S.of(context).retry),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loadingWidget: () {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CupertinoActivityIndicator(radius: 16),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).loadingViewers,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
              successWidget: () {
                final viewers = state.data;
                if (viewers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context).noViewersYet,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewers.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  itemBuilder: (context, index) {
                    final viewer = viewers[index];
                    return ListTile(
                      onTap: () {
                        context.toPage(
                          PeerProfileView(peerId: viewer.viewerInfo.id),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      leading: VCircleAvatar(
                        vFileSource: VPlatformFile.fromUrl(
                          networkUrl: viewer.viewerInfo.userImage,
                        ),
                        radius: 24,
                      ),
                      title: Text(
                        viewer.viewerInfo.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        format(
                          viewer.viewedAtLocal,
                          locale: Localizations.localeOf(context).languageCode,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
