// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_api_cache_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_contacts_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/api_cache_table.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/contacts_table.dart';
import 'package:v_chat_sdk_core/src/models/api_cache_model.dart';
import 'package:v_chat_sdk_core/src/models/contacts/v_contact.dart';

class ContactMemoryImp extends BaseLocalContactsRepo {
  @override
  Future<int> insert(List<VContact> model) async {
    return 1;
  }

  @override
  Future<List<VContact>> getAll() async {
    return [];
  }

  @override
  Future<void> deleteOne(String phone) async {
    return;
  }

  @override
  Future reCreateTable() async {
    return;
  }
}
