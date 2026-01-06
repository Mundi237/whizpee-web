// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/http/api_service/block/block_api_service.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class Block {
  final VNativeApi _vNativeApi;

  VBlockApiService get _api => _vNativeApi.remote.block;

  Block(
    this._vNativeApi,
  );

  Future<bool> blockUser({
    required String peerId,
  }) async {
    return _api.blockUser(peerId: peerId);
  }

  Future<VSingleBlockModel> checkIfThereBan({
    required String peerId,
  }) async {
    return _api.checkIfThereBan(peerId: peerId);
  }

  Future<bool> unBlockUser({
    required String peerId,
  }) async {
    return _api.unBlockUser(peerId: peerId);
  }
}
