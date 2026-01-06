// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/call_state.dart';
import '../widgets/agora_video_view.dart';
import '../widgets/call_actions_row.dart';
import 'call_controller.dart';

class VCallPage extends StatefulWidget {
  final VCallDto dto;

  const VCallPage({
    super.key,
    required this.dto,
  });

  @override
  State<VCallPage> createState() => _VCallPageState();
}

class _VCallPageState extends State<VCallPage> {
  //view
  late double _viewAspectRatio;
  late VCallController controller = VCallController(widget.dto);

  @override
  void initState() {
    _setUpViewPort();
    controller.context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VCircleAvatar(
                vFileSource: VPlatformFile.fromUrl(
                  networkUrl: widget.dto.peerUser.userImage,
                ),
                radius: 20,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                widget.dto.peerUser.fullName,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: ValueListenableBuilder<CallState>(
              valueListenable: controller,
              builder: (_, value, __) {
                final users = value.users;
                return Column(
                  children: [
                    if (value.status == VCallStatus.inCall)
                      StreamBuilder<int>(
                        initialData: 0,
                        stream: controller.stopWatchTimer.rawTime,
                        builder: (context, snapshot) {
                          final rawTime = snapshot.data ?? 0;
                          final displayTime = StopWatchTimer.getDisplayTime(
                            rawTime,
                            hours: false,
                            milliSecond: false,
                            minute: true,
                            second: true,
                          );
                          return Text(
                            displayTime,
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),

                    ///user view
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: OrientationBuilder(
                          builder: (context, orientation) {
                            final isPortrait =
                                orientation == Orientation.portrait;
                            if (value.users.isEmpty) {
                              return const SizedBox();
                            }

                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => setState(() => _viewAspectRatio =
                                  isPortrait ? 2 / 3 : 3 / 2),
                            );

                            if (users.length == 1) {
                              // Only local user
                              final user = users.first;
                              return AgoraAudioItemView(
                                viewAspectRatio: _viewAspectRatio,
                                user: user,
                              );
                            } else if (users.length == 2) {
                              AgoraUser? localUser;
                              AgoraUser? remoteUser;
                              for (var user in users) {
                                if (user.uid == value.currentUid) {
                                  localUser = user;
                                } else {
                                  remoteUser = user;
                                }
                              }
                              if (localUser != null && remoteUser != null) {
                                return Stack(
                                  children: [
                                    // Remote user's video in full screen
                                    Positioned.fill(
                                      child: AgoraAudioItemView(
                                        viewAspectRatio: 1,
                                        user: remoteUser,
                                      ),
                                    ),
                                    // Local user's video as small widget
                                    Positioned(
                                      top: 8.0,
                                      right: 8.0,
                                      width: 130.0,
                                      height: 170.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: AgoraAudioItemView(
                                            viewAspectRatio: _viewAspectRatio,
                                            user: localUser,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                /// Fallback: show all videos in a grid
                                return GridView.count(
                                  crossAxisCount: 1,
                                  children: users
                                      .map((user) => AgoraAudioItemView(
                                            viewAspectRatio: _viewAspectRatio,
                                            user: user,
                                          ))
                                      .toList(),
                                );
                              }
                            } else {
                              // For more than 2 users, show them in a grid
                              int crossAxisCount = users.length <= 4 ? 2 : 3;
                              return GridView.count(
                                crossAxisCount: crossAxisCount,
                                children: users
                                    .map((user) => AgoraAudioItemView(
                                          viewAspectRatio: _viewAspectRatio,
                                          user: user,
                                        ))
                                    .toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    ///actions
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: 360,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CallActionButton(
                              icon: value.isVideoEnabled
                                  ? Icons.videocam_off_rounded
                                  : Icons.videocam_rounded,
                              isEnabled: widget.dto.isVideoEnable,
                              onTap: widget.dto.isVideoEnable
                                  ? controller.onToggleCamera
                                  : null,
                            ),
                            CallActionButton(
                              icon: Icons.cameraswitch_rounded,
                              onTap: widget.dto.isVideoEnable
                                  ? controller.onSwitchCamera
                                  : null,
                              isEnabled: widget.dto.isVideoEnable,
                            ),
                            CallActionButton(
                              icon: value.isMicEnabled
                                  ? Icons.mic
                                  : Icons.mic_off,
                              isEnabled: true,
                              onTap: controller.onToggleMicrophone,
                            ),
                            CallActionButton(
                              icon: value.isSpeakerEnabled
                                  ? CupertinoIcons.speaker_3
                                  : CupertinoIcons.speaker_1,
                              onTap: controller.onToggleSpeaker,
                            ),
                            CallActionButton(
                              icon: Icons.call_end,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              radius: 30,
                              isEnabled: true,
                              backgroundColor: Colors.red,
                              iconSize: 28,
                              iconColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    controller.dispose();
    super.dispose();
  }

  List<int> _createLayout(int n) {
    int rows = (sqrt(n).ceil());
    int columns = (n / rows).ceil();

    List<int> layout = List<int>.filled(rows, columns);
    int remainingScreens = rows * columns - n;

    for (int i = 0; i < remainingScreens; i++) {
      layout[layout.length - 1 - i] -= 1;
    }
    return layout;
  }

  void _setUpViewPort() {
    if (kIsWeb) {
      _viewAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      _viewAspectRatio = 2 / 3;
    } else {
      _viewAspectRatio = 3 / 2;
    }
  }
}
