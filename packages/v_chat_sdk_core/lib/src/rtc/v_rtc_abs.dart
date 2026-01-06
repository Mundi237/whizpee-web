// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// An abstract base class for providing push notification services.
abstract class VRtcAbs {
  const VRtcAbs();

  /// Initializes the push provider.
  Future<bool> init(Object? data);
  Future<void> release(Object? data);
  Future<void> onToggleCamera(Object? data);
  Future<void> onToggleMicrophone(Object? data);
  Future<void> onToggleSpeaker(Object? data);
  Future<void> onSwitchCamera(Object? data);

  // Method to emit the call timer
  Stream<Duration> onCallTimer(Object? data);


}