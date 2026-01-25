// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/api_service/profile/profile_api_service.dart';
import '../../../core/utils/phone/contact_sync_service.dart';

class ChooseMembersController
    extends SLoadingController<List<SSelectableUser>> {
  final txtController = TextEditingController();
  final ProfileApiService profileApiService;
  final Function(List<SBaseUser> selectedUsers) onDone;
  Timer? _debounce;
  late final contactService = GetIt.I.get<ContactSyncService>();
  final selectedUsers = <SSelectableUser>[];
  bool isFinishLoadMore = false;
  final String? groupId;
  final String? broadcastId;

  // Cache des numéros de téléphone de l'annuaire pour le filtrage
  Set<String> _phoneBookNumbers = {};
  ChooseMembersController(
    this.profileApiService,
    this.onDone,
    this.groupId,
    this.broadcastId,
  ) : super(SLoadingState(<SSelectableUser>[]));

  UserFilterDto _filterDto = UserFilterDto.init();

  @override
  void onInit() {
    _initializeAndGetData();
  }

  /// Initialise l'annuaire puis charge les données
  Future<void> _initializeAndGetData() async {
    await _initializePhoneBookNumbers();
    await getData();
  }

  /// Initialise le cache des numéros de téléphone de l'annuaire
  Future<void> _initializePhoneBookNumbers() async {
    try {
      // Essayer de récupérer les vrais contacts de l'annuaire
      final localContacts = await contactService.getContactsFromLocal();
      if (localContacts.isNotEmpty) {
        _phoneBookNumbers = localContacts
            .map((contact) => _normalizePhoneNumber(contact.phone))
            .toSet();
      }

      // Essayer aussi les contacts actuels si disponibles
      if (contactService.currentContacts.isNotEmpty) {
        _phoneBookNumbers.addAll(contactService.currentContacts
            .map((contact) => _normalizePhoneNumber(contact.phone)));
      }

      // Si toujours vide, essayer d'accéder directement via flutter_contacts
      if (_phoneBookNumbers.isEmpty && (Platform.isAndroid || Platform.isIOS)) {
        try {
          await Permission.contacts.request();
          final status = await Permission.contacts.status;

          if (status.isGranted) {
            await _tryGetContactsDirectly();
          }
        } catch (e) {
          // Erreur silencieuse si les permissions sont refusées
        }
      }
    } catch (e) {
      // Erreur silencieuse si l'initialisation échoue
    }
  }

  Future<void> getData() async {
    await vSafeApiCall<List<SSelectableUser>>(
      onLoading: () async {
        setStateLoading();
        update();
      },
      onError: (exception) {
        setStateError();
        update();
      },
      request: () async {
        _filterDto = UserFilterDto.init();
        isFinishLoadMore = false;
        if (groupId != null) {
          final users = await VChatController.I.nativeApi.remote.room
              .getAvailableGroupMembersToAdded(
            roomId: groupId!,
            filter: _filterDto,
          );

          return users.map((e) => SSelectableUser(searchUser: e)).toList();
        } else if (broadcastId != null) {
          final users = await VChatController.I.nativeApi.remote.room
              .getAvailableBroadcastMembersToAdded(
            roomId: broadcastId!,
            filter: _filterDto,
          );
          return users.map((e) => SSelectableUser(searchUser: e)).toList();
        } else {
          final users = await profileApiService.appUsers(_filterDto);
          final filteredUsers = _filterUsersByPhoneBook(users);
          return filteredUsers
              .map((e) => SSelectableUser(searchUser: e))
              .toList();
        }
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          setStateEmpty();
          return;
        }
        setStateSuccess();
        data.addAll(response);
        maintainTheUsers();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: false,
        ignoreNetworkErrors: false,
      ),
    );
  }

  void onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1500), () {
      vSafeApiCall<List<SSelectableUser>>(
        onLoading: () {
          setStateLoading();
          update();
        },
        onError: (exception) {
          setStateError();
          update();
        },
        request: () async {
          _filterDto = UserFilterDto.init();
          // Recherche par téléphone si la query ressemble à un numéro
          if (_isPhoneQuery(query)) {
            _filterDto.phone = query;
          } else {
            _filterDto.fullName = query;
          }
          isFinishLoadMore = false;
          var users = <SSearchUser>[];

          if (groupId != null) {
            users = await VChatController.I.nativeApi.remote.room
                .getAvailableGroupMembersToAdded(
              roomId: groupId!,
              filter: _filterDto,
            );
          } else if (broadcastId != null) {
            users = await VChatController.I.nativeApi.remote.room
                .getAvailableBroadcastMembersToAdded(
              roomId: broadcastId!,
              filter: _filterDto,
            );
          } else {
            users = await profileApiService.appUsers(_filterDto);
            users = _filterUsersByPhoneBook(users);
          }
          return users.map((e) => SSelectableUser(searchUser: e)).toList();
        },
        onSuccess: (response) {
          data.clear();
          if (response.isEmpty) {
            setStateEmpty();
            return;
          }
          data.addAll(response);
          maintainTheUsers();
          setStateSuccess();
        },
        config: const VApiConfig(
          ignoreTimeoutErrors: false,
          ignoreNetworkErrors: false,
        ),
      );
    });
  }

  void maintainTheUsers() {
    //i need to let the selectedUsers each user inside the selectedUsers must find the same user inside the data and set isSelected it to true founded
    Map<String, SSelectableUser> dataMap = {
      for (var v in data) v.searchUser.baseUser.id: v
    };
    for (var selectedUser in selectedUsers) {
      var foundedUser = dataMap[selectedUser.searchUser.baseUser.id];
      if (foundedUser != null) {
        foundedUser.isSelected = true;
      }
    }

    update();
  }

  @override
  void onClose() {
    txtController.dispose();
    _debounce?.cancel();
  }

  void selectUser(SSelectableUser user) {
    if (selectedUsers.length >= VChatController.I.vChatConfig.maxForward) {
      return;
    }

    final founded = data.firstWhereOrNull(
        (e) => e.searchUser.baseUser.id == user.searchUser.baseUser.id);
    founded?.isSelected = true;
    selectedUsers.add(user);
    update();
  }

  void unSelectUser(SSelectableUser user) {
    final founded = data.firstWhereOrNull(
        (e) => e.searchUser.baseUser.id == user.searchUser.baseUser.id);
    founded?.isSelected = false;
    selectedUsers.removeWhere((element) =>
        element.searchUser.baseUser.id == user.searchUser.baseUser.id);
    update();
  }

  bool get isThereSelection => selectedUsers.isNotEmpty;

  void onNext(BuildContext context) {
    if (!isThereSelection) {
      VAppAlert.showErrorSnackBar(
        message: "Choisissez au moins un membre",
        context: context,
      );
      return;
    }
    onDone(selectedUsers.toList().map((e) => e.searchUser.baseUser).toList());
  }

  bool _isLoadMoreActive = false;

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }
    final result = await vSafeApiCall<List<SSelectableUser>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        _filterDto.page = _filterDto.page + 1;
        final users = await profileApiService.appUsers(_filterDto);
        final filteredUsers = _filterUsersByPhoneBook(users);
        return filteredUsers
            .map((e) => SSelectableUser(searchUser: e))
            .toList();
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          isFinishLoadMore = true;
        }
        notifyListeners();
        _isLoadMoreActive = false;
        value.data.addAll(response);
        maintainTheUsers();
      },
      onError: (exception) {
        if (kDebugMode) {
          print(exception);
        }
        if (kDebugMode) {
          if (exception is Error) {
            print('StackTrace: ${exception.stackTrace}');
          }
        }
        _isLoadMoreActive = false;
      },
    );

    return result.when(
      success: (data) => data.isNotEmpty,
      failure: (error) => false,
    );
  }

  /// Filtre les utilisateurs pour ne garder que ceux dont le phone correspond à l'annuaire
  List<SSearchUser> _filterUsersByPhoneBook(List<SSearchUser> users) {
    // Si l'annuaire est vide, retourner tous les utilisateurs
    if (_phoneBookNumbers.isEmpty) {
      return users;
    }

    // Filtrer pour ne garder que les utilisateurs avec un phone dans l'annuaire
    final filteredUsers = users.where((user) {
      final userPhone = user.phone;

      if (userPhone == null || userPhone.isEmpty) {
        return false;
      }

      // Normaliser le numéro de l'utilisateur pour la comparaison
      final normalizedUserPhone = _normalizePhoneNumber(userPhone);

      // Vérifier si le numéro normalisé est dans l'annuaire
      return _phoneBookNumbers.contains(normalizedUserPhone);
    }).toList();

    return filteredUsers;
  }

  /// Détermine si une query de recherche ressemble à un numéro de téléphone
  bool _isPhoneQuery(String query) {
    // Considérer comme numéro si contient principalement des chiffres et commence par + ou chiffre
    final cleanQuery = query.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleanQuery.isEmpty) return false;

    // Si commence par + ou contient majoritairement des chiffres
    if (cleanQuery.startsWith('+') ||
        RegExp(r'^[0-9]+$').hasMatch(cleanQuery) ||
        (cleanQuery.length > 3 &&
            cleanQuery.replaceAll(RegExp(r'[^0-9]'), '').length /
                    cleanQuery.length >
                0.7)) {
      return true;
    }

    return false;
  }

  /// Normalise un numéro de téléphone au format uniforme 237XXXXXXX
  String _normalizePhoneNumber(String phone) {
    // Nettoyer le numéro (enlever espaces, tirets, parenthèses)
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Enlever le + si présent
    if (cleaned.startsWith('+')) {
      cleaned = cleaned.substring(1);
    }

    // Si commence par 237, c'est déjà au bon format
    if (cleaned.startsWith('237')) {
      return cleaned;
    }

    // Si commence par 6 (format local camerounais), ajouter 237
    if (cleaned.startsWith('6') && cleaned.length == 9) {
      return '237$cleaned';
    }

    // Sinon retourner tel quel
    return cleaned;
  }

  /// Essayer d'accéder directement aux contacts de l'annuaire via flutter_contacts
  Future<void> _tryGetContactsDirectly() async {
    try {
      final contacts = await FlutterContacts.getContacts(withProperties: true);

      final phoneNumbers = <String>{};
      for (final contact in contacts) {
        for (final phone in contact.phones) {
          if (phone.number.isNotEmpty) {
            // Normaliser le numéro au format 237XXXXXXX
            final normalizedNumber = _normalizePhoneNumber(phone.number);
            if (normalizedNumber.isNotEmpty) {
              phoneNumbers.add(normalizedNumber);
            }
          }
        }
      }

      if (phoneNumbers.isNotEmpty) {
        _phoneBookNumbers = phoneNumbers;
      }
    } catch (e) {
      // Erreur silencieuse si l'accès aux contacts échoue
    }
  }
}
