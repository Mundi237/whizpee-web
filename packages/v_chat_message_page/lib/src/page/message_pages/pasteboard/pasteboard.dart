// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:universal_html/html.dart';
import 'package:v_platform/v_platform.dart';

import 'file_convertor.dart';

abstract class IPasteboard {
  StreamSubscription<ClipboardEvent> pasteBoardListener(
    void Function(List<VPlatformFile> event) onData,
  );
}

class Pasteboard implements IPasteboard {
  Pasteboard(this.fileConvertor);

  final IFileConvertor fileConvertor;

  Future<VPlatformFile> _getVPlatformFileFromHtmlFile(File file) async {
    final result = await fileConvertor.htmlFileToBytes(file);
    return VPlatformFile.fromBytes(name: file.name, bytes: result);
  }

  @override
  StreamSubscription<ClipboardEvent> pasteBoardListener(
    void Function(List<VPlatformFile> event) onData,
  ) {
    return document.onPaste.listen((x) async {
      if (x.clipboardData == null ||
          x.clipboardData!.items == null ||
          x.clipboardData!.items!.length == null) {
        return;
      }
      final result = await _onClipboardEvent(x);
      onData(result);
    });
  }

  Future<List<VPlatformFile>> _onClipboardEvent(ClipboardEvent e) async {
    try {
      final clipboardItems = e.clipboardData!.items;
      final clipboardFiles = <File>[];
      for (var i = 0; i < clipboardItems!.length!; i++) {
        clipboardFiles.add(clipboardItems[i].getAsFile()!);
      }
      final data = await Future.wait(
          clipboardFiles.map((e) => _getVPlatformFileFromHtmlFile(e)).toList());
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
