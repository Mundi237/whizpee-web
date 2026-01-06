// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

final unAuthStream450Error = OneTimeStream<bool>();

class OneTimeStream<T> {
  StreamController<T>? _controller;
  bool _hasEmitted = false;

  OneTimeStream() {
    _controller = StreamController<T>();
  }

  Stream<T> get stream => _controller!.stream;

  void add(T value) {
    _controller!.sink.add(value);
    _hasEmitted = true;
  }

  void dispose() {
    _controller!.close();
  }
}
