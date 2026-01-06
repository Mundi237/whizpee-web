import 'dart:convert';

import 'package:v_chat_sdk_core/src/local_db/tables/contacts_table.dart';

class VContact {
  final String contactId;
  final String displayName;
  final String phone;

//<editor-fold desc="Data Methods">
  const VContact({
    required this.contactId,
    required this.displayName,
    required this.phone,
  });

  @override
  String toString() {
    return 'VContact{ contactId: $contactId, displayName: $displayName, phone : $phone,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'contactId': contactId,
      'displayName': displayName,
      'phone': phone,
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      ContactsTable.columnPhone: phone,
      ContactsTable.columnLocalId: contactId,
      ContactsTable.columnName: displayName,
    };
  }

  VContact.fromLocalMap(Map<String, dynamic> map)
      : phone = map[ContactsTable.columnPhone] as String,
        displayName = map[ContactsTable.columnName] as String,
        contactId = map[ContactsTable.columnLocalId] as String;

  factory VContact.fromMap(Map<String, dynamic> map) {
    return VContact(
      contactId: map['contactId'] as String,
      displayName: map['displayName'] as String,
      phone: map['phone'] as String,
    );
  }

//</editor-fold>
}

class VCreateContactDto {
  final List<VContact> contacts;
  final String countryCode;

//<editor-fold desc="Data Methods">
  const VCreateContactDto({
    required this.contacts,
    required this.countryCode,
  });

  @override
  String toString() {
    return 'VContactDto{ contacts: $contacts, countryCode: $countryCode,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'contacts': contacts
          .map(
            (e) => e.toMap(),
          )
          .toList(),
      'countryCode': countryCode,
    };
  }

//</editor-fold>
}

class VDeleteContactDto {
  final List<String> contacts;
  final String countryCode;

//<editor-fold desc="Data Methods">
  const VDeleteContactDto({
    required this.contacts,
    required this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'phones': contacts,
      'countryCode': countryCode,
    };
  }
}
