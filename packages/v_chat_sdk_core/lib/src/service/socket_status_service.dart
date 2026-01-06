// // Copyright 2023, the hatemragab project author.
// // All rights reserved. Use of this source code is governed by a
// // MIT license that can be found in the LICENSE file.
//
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
//
// class SocketStatusService {
//   final _emitter = VEventBusSingleton.vEventBus;
//
//   void start() {
//     _emitter.on<VSocketStatusEvent>().listen((e) {
//       if (e.isConnected) {
//         _handleOnSocketConnect(e);
//       } else {
//         _handleOnSocketDisconnect(e);
//       }
//     });
//   }
//
//
//
//   void _handleOnSocketDisconnect(VSocketStatusEvent e) {}
// }
