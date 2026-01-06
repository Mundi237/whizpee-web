// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/api_cache_model.dart';
import 'package:v_chat_sdk_core/src/models/contacts/v_contact.dart';

abstract class BaseLocalContactsRepo {
  Future<int> insert(List<VContact> model);

  Future<List<VContact>> getAll();

  Future<void> deleteOne(String phone);

  Future<void> reCreateTable();
}
