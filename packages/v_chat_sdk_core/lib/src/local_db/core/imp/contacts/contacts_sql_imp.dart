// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';
import 'package:v_chat_sdk_core/src/local_db/core/abstraction/base_local_contacts_repo.dart';
import 'package:v_chat_sdk_core/src/local_db/tables/contacts_table.dart';
import 'package:v_chat_sdk_core/src/models/contacts/v_contact.dart';

class ContactSqlImp extends BaseLocalContactsRepo {
  final Database _database;

  ContactSqlImp(this._database);

  final _table = ContactsTable.tableName;

  @override
  Future<int> insert(List<VContact> model) async {
    final batch = _database.batch();
    for (final e in model) {
      batch.insert(
        _table,
        e.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    return 1;
  }

  @override
  Future<List<VContact>> getAll() async {
    final maps = await _database.query(_table);
    return maps.map((e) => VContact.fromLocalMap(e)).toList();
  }

  @override
  Future<void> deleteOne(String phone) async {
    await _database.delete(
      _table,
      where: "${ContactsTable.columnPhone} =?",
      whereArgs: [phone],
    );
  }

  @override
  Future reCreateTable() async {
    return _database.transaction((txn) => ContactsTable.recreateTable(txn));
  }
}
