// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_admin/src/modules/home_tabs/users/nested/user_profile_controller.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

class UserProfile extends StatefulWidget {
  final String id;

  const UserProfile({
    super.key,
    required this.id,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late final UserProfileController controller;
  final sizer = GetIt.I.get<AppSizeHelper>();

  @override
  void initState() {
    controller = UserProfileController(widget.id);
    controller.onInit();
    super.initState();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sizer.isWide(context)
          ? AppBar(
              title: S.of(context).userProfile.h5,
              centerTitle: true,
            )
          : null,
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (_, __, ___) {
          final loadingState = controller.loadingState;
          final countries = controller.data.userCountries;
          final reports = controller.data.userReports;
          final roomCounter = controller.data.roomCounter;
          final userDevices = controller.data.userDevices;
          final messagesCounter = controller.data.messagesCounter;
          return Center(
            child: Container(
              alignment: Alignment.topCenter,
              constraints: sizer.isWide(context)
                  ? BoxConstraints(maxWidth: context.width * .6)
                  : null,
              child: Card(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: loadingState == VChatLoadingState.loading,
                          child: const LinearProgressIndicator(),
                        ),
                        const SizedBox(height: 5),
                        VCircleAvatar(
                          vFileSource: VPlatformFile.fromUrl(
                            networkUrl: controller.data.user.userImage,
                          ),
                          radius: 100,
                        ),
                        const SizedBox(height: 5),
                        controller.data.user.fullName.h4,
                        const SizedBox(height: 5),
                        (
                          controller.data.user.isOnline
                              ? S.of(context).online
                              : S.of(context).offline,
                        ).toString().b1,
                        const SizedBox(height: 5),
                        ExpansionTile(
                          title: Text(S.of(context).userInfo),
                          subtitle:
                              S.of(context).clickToSeeAllUserInformations.b2,
                          children: [
                            ListTile(
                              title: S.of(context).email.b1,
                              subtitle: controller.data.user.email.b2,
                            ),
                            ListTile(
                              title: S.of(context).fullName.b1,
                              subtitle: controller.data.user.fullName.b2,
                            ),
                            ListTile(
                              title: S.of(context).bio.b1,
                              subtitle: (controller.data.user.bio ??
                                      S.of(context).noBio)
                                  .b2,
                            ),
                            ListTile(
                              title: S.of(context).verifiedAt.b1,
                              subtitle:
                                  controller.data.user.verifiedAt.toString().b2,
                            ),
                            ListTile(
                              title: S.of(context).registerStatus.b1,
                              subtitle: controller.data.user.registerStatus.b2,
                              onTap: controller.data.user.registerStatus ==
                                      RegisterStatus.pending.name
                                  ? () => controller.acceptUser(context)
                                  : null,
                              trailing: controller.data.user.registerStatus ==
                                      RegisterStatus.pending.name
                                  ? const Icon(Icons.edit)
                                  : null,
                            ),
                            ListTile(
                              title: S.of(context).registerMethod.b1,
                              subtitle: controller.data.user.registerMethod.b2,
                            ),
                            ListTile(
                              onTap: () => controller.blockUser(context),
                              title: S.of(context).banTo.b1,
                              subtitle:
                                  controller.data.user.banTo.toString().b2,
                              trailing: const Icon(Icons.edit),
                            ),
                            ListTile(
                              onTap: () => controller.deleteUser(context),
                              title: S.of(context).deletedAt.b1,
                              subtitle:
                                  controller.data.user.deletedAt.toString().b2,
                              trailing: const Icon(Icons.edit),
                            ),
                            ListTile(
                              onTap: () => controller.primeUser(context),
                              title: "isPrime".b1,
                              subtitle:
                                  controller.data.user.isPrime.toString().b2,
                              trailing: const Icon(Icons.edit),
                            ),
                            ListTile(
                              onTap: () => controller.hasBadgeUser(context),
                              title: S.of(context).verified.b1,
                              subtitle:
                                  controller.data.user.hasBadge.toString().b2,
                              trailing: const Icon(Icons.edit),
                            ),
                            ListTile(
                              title: S.of(context).createdAt.b1,
                              subtitle: DateFormat.yMd(
                                Localizations.localeOf(context).languageCode,
                              )
                                  .format(controller.data.user.createdAt)
                                  .toString()
                                  .b2,
                            ),
                            ListTile(
                              title: S.of(context).updatedAt.b1,
                              subtitle: DateFormat.yMd(
                                Localizations.localeOf(context).languageCode,
                              )
                                  .format(controller.data.user.updatedAt)
                                  .toString()
                                  .b2,
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title:
                              "${S.of(context).country} ${countries.length}".b1,
                          subtitle: S.of(context).clickToSeeAllUserCountries.b2,
                          children: controller.data.userCountries
                              .map(
                                (e) => ListTile(
                                  leading: Text(e.emoji),
                                  title: e.name.b1,
                                  subtitle: e.code.b2,
                                ),
                              )
                              .toList(),
                        ),
                        ExpansionTile(
                          title:
                              "${S.of(context).messages} ${messagesCounter.messages}"
                                  .b1,
                          subtitle:
                              S.of(context).clickToSeeAllUserMessagesDetails.b2,
                          children: controller.messages
                              .map(
                                (e) => ListTile(
                                  title: Text(e.title),
                                  subtitle: Text(e.value),
                                ),
                              )
                              .toList(),
                        ),
                        ExpansionTile(
                          title:
                              "${S.of(context).chats} ${roomCounter.total}".b1,
                          subtitle:
                              S.of(context).clickToSeeAllUserRoomsDetails.b2,
                          children: controller.rooms
                              .map(
                                (e) => ListTile(
                                  title: Text(e.title),
                                  subtitle: Text(e.value),
                                ),
                              )
                              .toList(),
                        ),
                        ExpansionTile(
                          title:
                              "${S.of(context).devices} ${userDevices.length}"
                                  .b1,
                          subtitle:
                              S.of(context).clickToSeeAllUserDevicesDetails.b2,
                          children: userDevices
                              .map(
                                (e) => ListTile(
                                  title: Text(e.platform),
                                  subtitle: Text(
                                    format(
                                      e.lastSeenAt,
                                      locale: Localizations.localeOf(context)
                                          .countryCode,
                                    ),
                                  ),
                                  trailing: Text(
                                      "${S.of(context).visits} ${e.visits}"),
                                ),
                              )
                              .toList(),
                        ),
                        ExpansionTile(
                          title:
                              "${S.of(context).reports} ${reports.length}".b1,
                          subtitle: S.of(context).clickToSeeAllUserReports.b2,
                          children: reports
                              .map(
                                (e) => ListTile(
                                  dense: false,
                                  leading: VCircleAvatar(
                                    vFileSource: VPlatformFile.fromUrl(
                                      networkUrl: e.reporter.userImage,
                                    ),
                                    radius: 20,
                                  ),
                                  title: e.reporter.fullName.b1,
                                  subtitle: e.content.b2,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
