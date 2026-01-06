// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

// import '../../../../main.dart';

class ContactSyncService {
  List<VContact> currentContacts = [];
  late String countryCode;

  bool get isPlatformSupported => VPlatforms.isMobile && AppAuth.isPhoneLogin;

  Future<void> initialize(BuildContext context) async {
    final isAsked = VAppPref.getBool(SStorageKeys.isAskForContactPerm.name);
    if (!isAsked) {
      final res = await VAppAlert.showAskYesNoDialog(
        context: context,
        title: S.of(context).syncContacts,
        content: S.of(context).acceptContactsPermissionDescription,
      );
      if (res == 1) {
        bool permissionGranted =
            await FlutterContacts.requestPermission(readonly: true);
        if (!permissionGranted) {
          VAppAlert.showErrorSnackBarWithoutContext(
            message: S.of(context).contactPermissionDenied,
          );
          return;
        }
      }
    }
    await VAppPref.setBool(SStorageKeys.isAskForContactPerm.name, true);
    countryCode = VAppPref.getStringOrNullKey(SStorageKeys.countryCode.name)!;
    final status = await Permission.contacts.status;
    if (status.isDenied) {
      return;
    }
    onContactChanged();
    FlutterContacts.addListener(onContactChanged);
  }

  Future saveContactsLocal(List<VContact> contacts) async {
    await VChatController.I.nativeApi.local.contacts.insert(currentContacts);
  }

  Future<List<VContact>> getContactsFromLocal() async {
    return await VChatController.I.nativeApi.local.contacts.getAll();
  }

  Future<void> deleteContactFromLocal(String phone) async {
    await VChatController.I.nativeApi.local.contacts.deleteOne(phone);
  }

  void dispose() {
    FlutterContacts.removeListener(onContactChanged);
  }

  void onContactChanged() async {
    currentContacts.clear();
    final contacts = await FlutterContacts.getContacts(withProperties: true);
    for (final e in contacts) {
      if (e.displayName.isEmpty) continue;
      if (e.phones.isEmpty) continue;
      for (final phone in e.phones) {
        final nPhone = phone.normalizedNumber;
        if (nPhone.length <= 8 || nPhone.length > 15) continue;
        currentContacts.add(
          VContact(
            contactId: e.id,
            displayName: e.displayName,
            phone: nPhone,
          ),
        );
      }
    }
    final res = await _detectAndSyncDeltas();
    if (res.contactsToAdd.isNotEmpty) {
      await VChatController.I.nativeApi.remote.contacts.createContacts(
        contact: VCreateContactDto(
            contacts: res.contactsToAdd, countryCode: countryCode),
      );
      await saveContactsLocal(res.contactsToAdd);
    }
    if (res.contactsToUpdate.isNotEmpty) {
      await VChatController.I.nativeApi.remote.contacts.updateContacts(
        contact: VCreateContactDto(
            contacts: res.contactsToUpdate, countryCode: countryCode),
      );
      await saveContactsLocal(res.contactsToUpdate);
    }
    if (res.contactsToDelete.isNotEmpty) {
      await VChatController.I.nativeApi.remote.contacts.deleteContacts(
          contact: VDeleteContactDto(
        contacts: res.contactsToDelete,
        countryCode: countryCode,
      ));
      for (final phone in res.contactsToDelete) {
        await deleteContactFromLocal(phone);
      }
    }
  }

  Future<_DetectModel> _detectAndSyncDeltas() async {
    //this method should detect the changes in the best way we have data in the sqlite and the new contacts in currentContacts
    //please write this method in the best way
    List<VContact> localContacts = await getContactsFromLocal();

    // Create maps from phone to VContact for efficient lookup
    Map<String, VContact> currentContactsMap = {
      for (final c in currentContacts) c.phone: c
    };
    Map<String, VContact> localContactsMap = {
      for (final c in localContacts) c.phone: c
    };
    // Lists to hold the contacts to add, update, and delete
    final model = _DetectModel();

    // Detect additions and updates
    for (final phone in currentContactsMap.keys) {
      if (!localContactsMap.containsKey(phone)) {
        // Contact is new and needs to be added
        model.contactsToAdd.add(currentContactsMap[phone]!);
      } else {
        // Contact exists, check for updates
        VContact currentContact = currentContactsMap[phone]!;
        VContact localContact = localContactsMap[phone]!;

        if (currentContact.displayName != localContact.displayName ||
            currentContact.contactId != localContact.contactId) {
          // Contact has been updated
          model.contactsToUpdate.add(currentContact);
        }
      }
    }

    // Detect deletions
    for (final phone in localContactsMap.keys) {
      if (!currentContactsMap.containsKey(phone)) {
        // Contact has been deleted
        model.contactsToDelete.add(phone);
      }
    }
    return model;
  }

  String getSearchLabelForUsersSearch() {
    if (isPlatformSupported) {
      return S.current.searchByUserNameOrFullUserEmail;
    } else {
      return S.current.searchByUserFullEmail;
    }
  }
}

class _DetectModel {
  List<VContact> contactsToAdd = [];
  List<VContact> contactsToUpdate = [];
  List<String> contactsToDelete = [];

  @override
  String toString() {
    return '_DetectModel{contactsToAdd: $contactsToAdd, contactsToUpdate: $contactsToUpdate, contactsToDelete: $contactsToDelete}';
  }
}
