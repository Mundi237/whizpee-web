// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqlite_api.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_api_cache_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_contacts_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/api_cache/api_cache_memory_imp.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/api_cache/api_cache_sql_imp.dart';
import 'package:v_chat_sdk_core/src/local_db/core/imp/contacts/contacts_memory_imp.dart';
import 'package:v_chat_sdk_core/src/models/api_cache_model.dart';
import 'package:v_platform/v_platform.dart';

import '../../../v_chat_sdk_core.dart';
import '../../local_db/core/imp/contacts/contacts_sql_imp.dart';

class NativeLocalContact {
  late final BaseLocalContactsRepo _baseLocalContactsRepo;

  NativeLocalContact(Database? database) {
    if (VPlatforms.isWeb) {
      _baseLocalContactsRepo = ContactMemoryImp();
    } else {
      _baseLocalContactsRepo = ContactSqlImp(database!);
    }
  }

  Future<int> insert(List<VContact> model) async {
    return _baseLocalContactsRepo.insert(model);
  }

  Future<void> deleteOne(String phone) async {
    return _baseLocalContactsRepo.deleteOne(phone);
  }

  Future reCreateTable() async {
    return _baseLocalContactsRepo.reCreateTable();
  }

  Future<List<VContact>> getAll() async {
    return _baseLocalContactsRepo.getAll();
  }
}
