// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:v_platform/v_platform.dart';

class DragDropIfWeb extends StatefulWidget {
  final Widget child;
  final Function(List<VPlatformFile> files) onDragDone;

  const DragDropIfWeb({
    super.key,
    required this.child,
    required this.onDragDone,
  });

  @override
  State<DragDropIfWeb> createState() => _DragDropIfWebState();
}

class _DragDropIfWebState extends State<DragDropIfWeb> {
  final controller = Completer<DropzoneViewController>();
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    if (VPlatforms.isWeb) {
      return KeyboardListener(
        focusNode: FocusNode(),
        child: Stack(
          children: [
            DropzoneView(
              operation: DragOperation.all,
              cursor: CursorType.grabbing,
              onCreated: (DropzoneViewController ctrl) {
                controller.complete(ctrl);
              },
              onError: (String? ev) {
                if (kDebugMode) {
                  print('Error: $ev');
                }
              },
              onHover: () {
                setState(() {
                  isHovering = true;
                });
              },
              onDropFiles: (List<DropzoneFileInterface>? files) async {
                isHovering = false;
                setState(() {});
                if (files == null) return;
                final controller = await this.controller.future;
                final draggedFiles = <VPlatformFile>[];
                for (final file in files) {
                  final fileBytes = await controller.getFileData(file);
                  final fileName = await controller.getFilename(file);
                  print(fileName);
                  draggedFiles.add(
                    VPlatformFile.fromBytes(
                      name: fileName,
                      bytes: fileBytes,
                    ),
                  );
                }

                widget.onDragDone(draggedFiles);
              },
              onLeave: () {
                isHovering = false;
                setState(() {});
              },
            ),
            widget.child,
            Container(
              color: isHovering ? Colors.blue.withValues(alpha: .5) : null,
            )
          ],
        ),
      );
    }
    return widget.child;
  }
}
