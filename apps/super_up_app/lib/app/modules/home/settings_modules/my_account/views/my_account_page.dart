// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_platform/v_platform.dart';
import '../../../../../core/api_service/profile/profile_api_service.dart';
import '../../../mobile/settings_tab/widgets/settings_list_item_tile.dart';
import '../controllers/my_account_controller.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late final MyAccountController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark ? null : CupertinoColors.systemGrey6,
      appBar: AppBar(
        title: Text(AppAuth.myProfile.baseUser.fullName),
      ),
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ChatSettingsTileInfo(
                  padding: const EdgeInsets.only(
                    right: 15,
                    left: 15,
                    top: 10,
                    bottom: 0,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CupertinoListTile(
                        title: Text(
                          S.of(context).updateYourProfile,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 2,
                        ),
                        leadingSize: 65,
                        padding: EdgeInsets.zero,
                        leading: Column(
                          children: [
                            VCircleAvatar(
                              vFileSource: VPlatformFile.fromUrl(
                                networkUrl:
                                    AppAuth.myProfile.baseUser.userImage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.only(left: 20),
                        minSize: 0,
                        onPressed: () => controller.updateUserImage(context),
                        child: S.of(context).edit.text,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        height: 1,
                      ),
                      SettingsListItemTile(
                        title: AppAuth.myProfile.baseUser.fullName,
                        trailing: const Icon(Icons.edit),
                        onTap: () => controller.updateUserName(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: S
                      .of(context)
                      .email
                      .toUpperCase()
                      .text
                      .color(Colors.grey)
                      .size(15),
                ),
                ChatSettingsTileInfo(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //     AppAuth.myProfile.authMethod.type.name.toUpperCase()),
                      // Text(
                      //   AppAuth.myProfile.authMethod.identifier.toString(),
                      //   style: const TextStyle(fontSize: 15),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: S
                      .of(context)
                      .about
                      .toUpperCase()
                      .text
                      .color(Colors.grey)
                      .size(15),
                ),
                ChatSettingsTileInfo(
                  title: Text(
                    AppAuth.myProfile.userBio,
                    maxLines: 3,
                  ),
                  padding: const EdgeInsets.all(10),
                  trailing: const Icon(Icons.edit),
                  onPressed: () => controller.updateUserBio(context),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (AppAuth.isLoginByEmail)
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: S
                        .of(context)
                        .password
                        .toUpperCase()
                        .text
                        .color(Colors.grey)
                        .size(15),
                  ),
                if (AppAuth.isLoginByEmail)
                  ChatSettingsTileInfo(
                    title: Text(S.of(context).updateYourPassword),
                    padding: const EdgeInsets.all(10),
                    trailing: const Icon(Icons.edit),
                    onPressed: () => controller.updateUserPassword(context),
                  ),
                if (AppAuth.isLoginByEmail)
                  const SizedBox(
                    height: 10,
                  ),
                ChatSettingsTileInfo(
                  title: Text(
                    S.of(context).deleteMyAccount,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.red),
                  ),
                  padding: const EdgeInsets.all(10),
                  trailing: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  onPressed: () => controller.deleteMyAccount(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = MyAccountController(GetIt.I.get<ProfileApiService>());
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }
}
