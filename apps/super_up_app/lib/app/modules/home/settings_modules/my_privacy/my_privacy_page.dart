import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/api_service/profile/profile_api_service.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../mobile/settings_tab/widgets/settings_list_item_tile.dart';

class MyPrivacyPage extends StatefulWidget {
  const MyPrivacyPage({super.key});

  @override
  State<MyPrivacyPage> createState() => _MyPrivacyPageState();
}

class _MyPrivacyPageState extends State<MyPrivacyPage> {
  UserPrivacy _userPrivacy = AppAuth.myProfile.userPrivacy;
  final _profileApi = GetIt.instance.get<ProfileApiService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            largeTitle: Text(S.of(context).myPrivacy),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              S.of(context).configureYourAccountPrivacy.text.color(Colors.grey),
              CupertinoListSection(
                dividerMargin: 0,
                topMargin: 10,
                additionalDividerMargin: 0,
                margin: EdgeInsets.zero,
                hasLeading: false,
                children: [
                  SettingsListItemTile(
                    color: Colors.amber,
                    title:S.of(context).enableSearchByEmail,
                    subtitle: S
                        .of(context)
                        .yourProfileAppearsInPublicSearchAndAddingForGroups
                        .text,
                    icon: Icons.search,
                    trailing: CupertinoSwitch(
                      value: _userPrivacy.publicSearch,
                      onChanged: _onUpdatePublicSearch,
                    ),
                  ),

                  SettingsListItemTile(
                    color: Colors.red,
                    title: S.of(context).calls,
                    subtitle:S.of(context).acceptCallsFromUsers.text,
                    icon: Icons.phone,
                    trailing: CupertinoSwitch(
                      value: _userPrivacy.acceptCalls,
                      onChanged: _onUpdateAcceptCals,
                    ),
                  ),
                  SettingsListItemTile(
                    color: Colors.green,
                    title: S.of(context).yourLastSeen,
                    subtitle: S.of(context).yourLastSeenInChats.text,
                    icon: Icons.last_page_rounded,
                    trailing: CupertinoSwitch(
                      value: _userPrivacy.lastSeen,
                      onChanged: _onUpdateLastSeen,
                    ),
                  ),
                  // SettingsListItemTile(
                  //   color: Colors.blue,
                  //   title: S.of(context).startNewChatWithYou,
                  //   subtitle: S.of(context).soon.text,
                  //   // onTap: _onUpdateStartChat,
                  //   icon: CupertinoIcons.chat_bubble_text,
                  // ),
                  // SettingsListItemTile(
                  //   color: Colors.black26,
                  //
                  //   title: S.of(context).yourStory,
                  //   subtitle: S.of(context).soon.text,
                  //   //  onTap: _onUpdateShowStory,
                  //   icon: Icons.history_toggle_off_rounded,
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onUpdatePublicSearch(bool value) async {
    _userPrivacy = _userPrivacy.copyWith(publicSearch: value);
    await _updateLocalProfile();
  }
  Future<void> _onUpdateAcceptCals(bool value) async {
    _userPrivacy = _userPrivacy.copyWith(acceptCalls: value);
    await _updateLocalProfile();
  }
  Future<void> _onUpdateLastSeen(bool value) async {
    _userPrivacy = _userPrivacy.copyWith(lastSeen: value);
    await _updateLocalProfile();
  }

  Future<void> _onUpdateStartChat() async {
    final res = await VAppAlert.showModalSheetWithActions<UserPrivacyType>(
      context: context,
      content: [
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).forRequest,
          id: UserPrivacyType.forReq,
        ),
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).public,
          id: UserPrivacyType.public,
        ),
      ],
    ) as ModelSheetItem<UserPrivacyType>?;
    if (res == null) return;
    _userPrivacy = _userPrivacy.copyWith(startChat: res.id);
    await _updateLocalProfile();
  }

  Future<void> _onUpdateShowStory() async {
    final res = await VAppAlert.showModalSheetWithActions<UserPrivacyType>(
      context: context,
      content: [
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).forRequest,
          id: UserPrivacyType.forReq,
        ),
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).public,
          id: UserPrivacyType.public,
        ),
      ],
    ) as ModelSheetItem<UserPrivacyType>?;
    if (res == null) return;
    _userPrivacy = _userPrivacy.copyWith(showStory: res.id);

    await _updateLocalProfile();
  }

  Future<void> _updateLocalProfile() async {
    final newProfile = AppAuth.myProfile.copyWith(
      userPrivacy: _userPrivacy,
    );
    await VAppPref.setMap(SStorageKeys.myProfile.name, newProfile.toMap());
    AppAuth.setProfileNull();
    setState(() {});
    _updateInApi();
  }

  String _getTrans(UserPrivacyType type) {
    switch (type) {
      case UserPrivacyType.forReq:
        return S.of(context).forRequest;
      case UserPrivacyType.public:
        return S.of(context).public;
      case UserPrivacyType.none:
        return S.of(context).none;
    }
  }

  Future _updateInApi() async {
    vSafeApiCall(
      request: () async {
        return _profileApi.updatePrivacy(_userPrivacy);
      },
      onSuccess: (response) {},
      onError: (exception) {
        VAppAlert.showErrorSnackBar(message: exception.message, context: context);
        print(exception);
      },
    );
  }
}
