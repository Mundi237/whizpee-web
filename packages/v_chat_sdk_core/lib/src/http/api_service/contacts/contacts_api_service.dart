// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/http/api_service/call/call_api.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'contacts_api.dart';

class VContactsApiService {
  VContactsApiService._();

  static ContactsApi? _contactsApi;

  Future<void> createContacts({
    required VCreateContactDto contact,
  }) async {
    final res = await _contactsApi!.createContacts(contact.toMap());
    throwIfNotSuccess(res);
  }

  Future<void> updateContacts({
    required VCreateContactDto contact,
  }) async {
    final res = await _contactsApi!.updateContacts(contact.toMap());
    throwIfNotSuccess(res);
  }

  Future<void> deleteContacts({
    required VDeleteContactDto contact,
  }) async {
    final res = await _contactsApi!.deleteContacts(contact.toMap());
    throwIfNotSuccess(res);
  }

  static VContactsApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _contactsApi ??= ContactsApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VContactsApiService._();
  }
}
