import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:s_translation/generated/l10n.dart';



class TrimmerView extends StatefulWidget {
  final File file;

  const TrimmerView(this.file, {super.key});

  @override
  TrimmerViewState createState() => TrimmerViewState();
}

class TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (String? outputPath) {
        setState(() {
          _progressVisibility = false;
          _value = outputPath;
        });
      },
    );

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          S.of(context).videoTrimmer,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(seconds: 10),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => _isPlaying = value),
                  ),
                ),
                TextButton(
                  child: _progressVisibility
                      ? const Text("Saving...")
                      : const Text("SAVE"),
                  onPressed: _progressVisibility
                      ? null
                      : () async {
                          final outputPath = await _saveVideo();
                          if (outputPath != null) {
                            Navigator.of(context).pop(outputPath);
                          }
                        },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
    _trimmer.dispose();
  }
}
