// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import '../../../super_up_core.dart';

class SLoadingState<T extends Object?> {
  T data;
  String? stateError;
  VChatLoadingState loadingState = VChatLoadingState.ideal;

  SLoadingState(this.data);
}
