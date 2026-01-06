import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces;
import 'package:super_up/app/modules/annonces/presentation/announcement_detail_page.dart';
import 'package:super_up/app/modules/annonces/presentation/announcements_page.dart';
import 'package:super_up/app/modules/annonces/presentation/wallet_screen.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
// import 'package:super_up/app/modules/home/home_controller/views/pages/announcements_page.dart';
// import 'package:super_up/app/modules/home/home_controller/views/pages/create_announcement_page.dart';
import 'package:super_up/app/modules/home/mobile/settings_tab/views/settings_tab_view.dart';
import 'package:super_up/app/modules/home/settings_modules/my_account/views/my_account_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Map> optionsList;

  @override
  initState() {
    try {
      final AnnonceController controller = GetIt.I.get<AnnonceController>();
      optionsList = [];
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        optionsList = [];
        await controller.getAnnonces(true);
        optionsList = [
          {'title': 'Vue d’annonce', "value": controller.totalviews},
          {'title': 'Clique sur annonce', "value": "0"},
          {'title': 'CTA Message', "value": "0"},
        ];
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<AnnonceController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Whispee"),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                context.toPage(SettingsTabView());
              },
              child: SvgPicture.string(
                settnigsIcons,
                color: Colors.white,
                width: 27,
                height: 27,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.getAnnonces(true);
            optionsList = [
              {'title': 'Vue d’annonce', "value": controller.totalviews},
              {'title': 'Clique sur annonce', "value": "0"},
              {'title': 'CTA Message', "value": "0"},
            ];
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/ic_addphoto.png"))),
                  child: VCircleAvatar(
                    radius: 70,
                    vFileSource: VPlatformFile.fromUrl(
                      networkUrl: AppAuth.myProfile.baseUser.userImage,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  AppAuth.myProfile.baseUser.fullName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    for (var option in optionsList)
                      Expanded(
                        child: Column(
                          spacing: 10,
                          children: [
                            Text(
                              option['value'].toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              option['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Expanded(
                      flex: 5,
                      child: GestureDetector(
                        onTap: () async {
                          if (kIsWeb) {
                            context.toPage(AnnouncementsPage());
                            return;
                          }
                          // GetIt.I.get<HomeController>().changeIndex(0);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              "Annonces",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: GestureDetector(
                        onTap: () {
                          context.toPage(const WalletScreen());
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade800,
                          ),
                          child: Center(
                            child: Text(
                              "Wallet",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          // context.toPage(CreateAnnouncementPage());
                          context.toPage(MyAccountPage());
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade800,
                          ),
                          child: Center(
                              child: Icon(
                            Icons.edit,
                            size: 28,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 15),
                ValueListenableBuilder<AppState<List<Annonces>>>(
                    valueListenable: controller.myAnnoncesListState,
                    builder: (_, state, __) {
                      if (state.isLoading) {
                        return Center(
                          child: Column(
                            children: [
                              SizedBox(height: 50),
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      }
                      if (state.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  state.errorModel!.error,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red.shade500, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.getAnnonces(true);
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 30,
                                  ))
                            ],
                          ),
                        );
                      }
                      if ((state.data ?? []).isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: Column(
                              children: [
                                Text(
                                  'Aucune annonce ne correspond à vos filtres.',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                IconButton(
                                    onPressed: () {
                                      controller.getAnnonces(true);
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      size: 30,
                                    ))
                              ],
                            ),
                          ),
                        );
                      }

                      final List<Annonces> announcements = state.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: announcements.length,
                        itemBuilder: (_, index) {
                          final announcement = announcements[index];
                          return GestureDetector(
                            onTap: () {
                              context.toPage(
                                AnnouncementDetailPage(
                                  announcement: announcement,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(10),
                                image: kIsWeb
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            announcement.images?.firstOrNull ??
                                                ''),
                                        fit: BoxFit.cover,
                                      )
                                    : DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            announcement.images?.firstOrNull ??
                                                ''),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const settnigsIcons =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-width="1.9"><path stroke-linecap="round" d="m21.318 7.141l-.494-.856c-.373-.648-.56-.972-.878-1.101c-.317-.13-.676-.027-1.395.176l-1.22.344c-.459.106-.94.046-1.358-.17l-.337-.194a2 2 0 0 1-.788-.967l-.334-.998c-.22-.66-.33-.99-.591-1.178c-.261-.19-.609-.19-1.303-.19h-1.115c-.694 0-1.041 0-1.303.19c-.261.188-.37.518-.59 1.178l-.334.998a2 2 0 0 1-.789.967l-.337.195c-.418.215-.9.275-1.358.17l-1.22-.345c-.719-.203-1.078-.305-1.395-.176c-.318.129-.505.453-.878 1.1l-.493.857c-.35.608-.525.911-.491 1.234c.034.324.268.584.736 1.105l1.031 1.153c.252.319.431.875.431 1.375s-.179 1.056-.43 1.375l-1.032 1.152c-.468.521-.702.782-.736 1.105s.14.627.49 1.234l.494.857c.373.647.56.971.878 1.1s.676.028 1.395-.176l1.22-.344a2 2 0 0 1 1.359.17l.336.194c.36.23.636.57.788.968l.334.997c.22.66.33.99.591 1.18c.262.188.609.188 1.303.188h1.115c.694 0 1.042 0 1.303-.189s.371-.519.59-1.179l.335-.997c.152-.399.428-.738.788-.968l.336-.194c.42-.215.9-.276 1.36-.17l1.22.344c.718.204 1.077.306 1.394.177c.318-.13.505-.454.878-1.101l.493-.857c.35-.607.525-.91.491-1.234s-.268-.584-.736-1.105l-1.031-1.152c-.252-.32-.431-.875-.431-1.375s.179-1.056.43-1.375l1.032-1.153c.468-.52.702-.781.736-1.105s-.14-.626-.49-1.234Z"/><path d="M15.52 12a3.5 3.5 0 1 1-7 0a3.5 3.5 0 0 1 7 0Z"/></g></svg>';
