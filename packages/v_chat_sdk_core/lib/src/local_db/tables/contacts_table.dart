// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:sqflite/sqflite.dart';

abstract class ContactsTable {
  static const tableName = 'contacts_';
  static const columnPhone = '${tableName}phone';
  static const columnName = '${tableName}name';
  static const columnLocalId = '${tableName}local_id';

  static Future<void> recreateTable(Transaction db) async {
    await db.execute(
      '''
          drop table if exists $tableName
        ''',
    );
    await ContactsTable.createTable(db);
  }

  static Future<void> createTable(Transaction db) async {
    await db.execute(
      '''
          create table $tableName (
            $columnPhone       TEXT PRIMARY KEY UNIQUE ,
            $columnName     TEXT,
            $columnLocalId TEXT
       )        
          ''',
    );

  }
}
