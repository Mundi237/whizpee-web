// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:textless/textless.dart';

import 'package:v_chat_input_ui/src/recorder/recorders.dart';
import 'package:v_chat_input_ui/src/v_widgets/extension.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_platform/v_platform.dart';

import '../models/message_voice_data.dart';

class RecordWidget extends StatefulWidget {
  final Duration maxTime;
  final VoidCallback onMaxTime;

  const RecordWidget({
    super.key,
    required this.onCancel,
    required this.maxTime,
    required this.onMaxTime,
  });

  final VoidCallback onCancel;

  @override
  State<RecordWidget> createState() => RecordWidgetState();
}

class RecordWidgetState extends State<RecordWidget> {
  final _stopWatchTimer = StopWatchTimer();
  String _currentTime = "00:00";
  int _recordMilli = 0;
  AppRecorder? _recorder;
  StreamSubscription? _rawTime;
  StreamSubscription? _minuteTime;

  @override
  void initState() {
    super.initState();
    _recorder = PlatformRecorder();
    _rawTime = _stopWatchTimer.rawTime.listen((value) {
      _recordMilli = value;
      _currentTime = StopWatchTimer.getDisplayTime(
        value,
        hours: false,
        milliSecond: false,
      );
      if (mounted) {
        setState(() {});
      }
    });
    _minuteTime = _stopWatchTimer.minuteTime.listen((value) {
      if (value == widget.maxTime.inMinutes) {
        pause();
        // widget.onMaxTime();
      }
    });
    _start();
  }

  void startCounterUp() {
    if (_stopWatchTimer.isRunning) {
      _stopCounter();
    }
    _stopWatchTimer.onStartTimer();
  }

  Future<void> _stopCounter() async {
    _stopWatchTimer.onResetTimer();
    _stopWatchTimer.onStopTimer();
    _recordMilli = 0;
  }

  Future<void> pause() async {
    _stopWatchTimer.onStopTimer();
    await _recorder?.pause();
  }

  Future<String> _getDir() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    // Use timestamp-based naming for voice recordings as they are temporary
    // and will be processed immediately after recording
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return join(appDirectory.path, 'voice_${timestamp}.aac');
  }

  Future<bool> _start() async {
    if (VPlatforms.isDeskTop) return false;
    if (VPlatforms.isWeb) {
      await _recorder!.start();
    } else {
      final path = await _getDir();
      await _recorder!.start(path);
    }
    await Future.delayed(Duration(milliseconds: 200));
    final isRecording = await _recorder!.isRecording();
    if (isRecording) {
      startCounterUp();
      return true;
    }
    return false;
  }

  Future<MessageVoiceData> stopRecord() async {
    _stopWatchTimer.onStopTimer();
    await Future.delayed(const Duration(milliseconds: 10));
    final path = await _recorder!.stop();
    if (path != null) {
      List<int>? bytes;
      late final XFile? xFile;
      if (VPlatforms.isWeb) {
        xFile = XFile(path);
        bytes = await xFile.readAsBytes();
      }
      final uri = Uri.parse(path);
      final data = MessageVoiceData(
        duration: _recordMilli,
        fileSource: VPlatforms.isWeb
            ? VPlatformFile.fromBytes(
                name: "voice_recording.wav",
                bytes: bytes!,
              )
            : VPlatformFile.fromPath(
                fileLocalPath: uri.path,
              ),
      );
      //await close();
      return data;
    }
    throw "record path is null here ! while stop the record";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentTime.text.black
                  .color(context.isDark ? Colors.white : Colors.black54),
              const SizedBox(
                width: 15,
              ),
              // if (_recorder is MobileRecorder)
              //   Expanded(
              //     child: AudioWaveforms(
              //       size: Size(MediaQuery.of(context).size.width, 40.0),
              //       recorderController: (_recorder as MobileRecorder).recorder,
              //     ),
              //   )
              // else
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // close();
                  widget.onCancel();
                },
                child: context.vInputTheme.trashIcon,
              ),
              // constGestureDetector(
              //   child: Icon(
              //     Icons.pause_circle_outline,
              //     size: 30,
              //     color: Colors.grey,
              //   ),
              // ),
              const SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  Future<void> close() async {
    _stopCounter();
    await _recorder?.stop();
    _stopWatchTimer.dispose();
    _rawTime?.cancel();
    _minuteTime?.cancel();
    await _recorder?.close();
  }
}
