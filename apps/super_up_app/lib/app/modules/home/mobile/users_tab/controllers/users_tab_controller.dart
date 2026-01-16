// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/main.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../../core/utils/phone/contact_sync_service.dart';
import '../../../../peer_profile/views/peer_profile_view.dart';

class UsersTabController extends SLoadingController<List<SSearchUser>> {
  UsersTabController(this.profileApiService) : super(SLoadingState([]));
  late final contactService = GetIt.I.get<ContactSyncService>();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  bool isFinishLoadMore = false;
  bool isSearchOpen = false;
  bool _isLoadMoreActive = false;
  bool isSearchLoading = false;
  final ProfileApiService profileApiService;
  UserFilterDto _filterDto = UserFilterDto.init();

  bool get isPlatformSupportContactSync => contactService.isPlatformSupported;

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _debounce?.cancel();
  }

  @override
  void onInit() {
    getData();
  }

  Future<void> getUsersDataFromApi() async {
    await vSafeApiCall<List<SSearchUser>>(
      request: () async {
        _filterDto = UserFilterDto.init();
        isFinishLoadMore = false;
        return await profileApiService.appUsers(_filterDto);
      },
      onSuccess: (response) {
        data.clear();
        data.addAll(response);
        // Store all users for local search
        _allUsers.clear();
        _allUsers.addAll(response);
        unawaited(VAppPref.setMap("api/users", {
          "data": response.map((e) => e.toMap()).toList(),
        }));
        update();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: false,
        ignoreNetworkErrors: false,
      ),
    );
  }

  void onItemPress(SSearchUser item, BuildContext context) async {
    // Créer ou récupérer la room pour ce contact
    try {
      final room = await VChatController.I.roomApi.getPeerRoom(
        peerId: item.baseUser.id,
      );

      if (!context.mounted) return;

      // Ouvrir la conversation
      VChatController.I.vNavigator.messageNavigator
          .toMessagePage(context, room);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating/getting peer room: $e');
      }
      // En cas d'erreur, ouvrir le profil
      if (!context.mounted) return;
      context.toPage(PeerProfileView(
        peerId: item.baseUser.id,
      ));
    }
  }

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }
    final result = await vSafeApiCall<List<SSearchUser>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        _filterDto.page = _filterDto.page + 1;
        final users = await profileApiService.appUsers(_filterDto);
        return users;
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          isFinishLoadMore = true;
        }
        notifyListeners();
        _isLoadMoreActive = false;
        data.addAll(response);
        setStateSuccess();
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

  Timer? _debounce;
  List<SSearchUser> _allUsers = [];
  String _currentSearchQuery = '';

  void closeSearch() {
    isSearchOpen = false;
    searchController.clear();
    _currentSearchQuery = '';
    isFinishLoadMore = false;
    _filterDto.page = 1;
    notifyListeners();
    _restoreAllUsers();
  }

  void openSearch() {
    isSearchOpen = true;
    searchFocusNode.requestFocus();
    notifyListeners();
  }

  void _restoreAllUsers() {
    data.clear();
    data.addAll(_allUsers);
    setStateSuccess();
    update();
  }

  void _performLocalSearch(String query) {
    if (query.isEmpty) {
      _restoreAllUsers();
      return;
    }

    final filteredUsers = _allUsers.where((user) {
      final fullName = user.baseUser.fullName.toLowerCase();
      final bio = user.getUserBio?.toLowerCase() ?? '';
      final searchTerm = query.toLowerCase();

      return fullName.contains(searchTerm) || bio.contains(searchTerm);
    }).toList();

    data.clear();
    data.addAll(filteredUsers);
    setStateSuccess();
    update();
  }

  void onSearchChanged(String query) {
    _currentSearchQuery = query;

    // Perform instant local search
    _performLocalSearch(query);

    // Debounce API search for more comprehensive results
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      if (_currentSearchQuery == query) {
        await _performApiSearch(query);
      }
    });
  }

  Future<void> _performApiSearch(String query) async {
    if (query.isEmpty) {
      await getUsersDataFromApi();
      return;
    }

    await vSafeApiCall<List<SSearchUser>>(
      onLoading: () async {
        isSearchLoading = true;
        notifyListeners();
      },
      onError: (exception) {
        isSearchLoading = false;
        notifyListeners();
        // Keep local search results on API error
        if (kDebugMode) {
          print('API search error: $exception');
        }
      },
      request: () async {
        _filterDto = UserFilterDto.init();
        _filterDto.fullName = query;
        isFinishLoadMore = false;
        final users = await profileApiService.appUsers(_filterDto);
        return users;
      },
      onSuccess: (response) {
        isSearchLoading = false;
        // Only update if this is still the current search query
        if (_currentSearchQuery == query) {
          data.clear();
          data.addAll(response);
          setStateSuccess();
          update();
        }
        notifyListeners();
      },
      config: const VApiConfig(
        ignoreTimeoutErrors: true,
        ignoreNetworkErrors: true,
      ),
    );
  }

  Future getData() async {
    try {
      final oldUsers = VAppPref.getMap("api/users");
      if (oldUsers != null) {
        final list = oldUsers['data'] as List;
        value.data = list.map((e) => SSearchUser.fromMap(e)).toList();
        setStateSuccess();
        update();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    await getUsersDataFromApi();
  }

  void syncContacts() async {
    bool permissionGranted =
        await FlutterContacts.requestPermission(readonly: true);
    if (permissionGranted) {
      await contactService.initialize(navigatorKey.currentState!.context);
      value.data = [];
      update();
      getData();
      VAppAlert.showSuccessSnackBar(
        message: S.current.contactsHasBeenSynced,
        context: navigatorKey.currentState!.context,
      );
    }
  }
}
