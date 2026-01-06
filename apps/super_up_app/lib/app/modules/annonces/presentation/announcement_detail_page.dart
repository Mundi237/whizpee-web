// ignore_for_file: depend_on_referenced_packages, prefer_final_fields

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
// import 'package:super_up/app/core/theme/app_theme_manager.dart';
import 'package:super_up/app/modules/annonces/presentation/boost_annoncement.dart';
import 'package:super_up/app/modules/annonces/presentation/image_viewer.dart';
import 'package:super_up/app/modules/home/mobile/rooms_tab/controllers/rooms_tab_controller.dart';
import 'package:super_up/app/modules/peer_profile/controllers/peer_profile_controller.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart'
    show Annonces, VChatController;
// import 'package:super_up_core/super_up_core.dart';
// import 'package:super_up/app/modules/home/models/announcement_model.dart';

class AnnouncementDetailPage extends StatefulWidget {
  final Annonces announcement;

  const AnnouncementDetailPage({super.key, required this.announcement});

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage> {
  late final RoomsTabController controller;
  final config = VAppConfigController.appConfig;
  PageController _pageController = PageController();
  bool _isFingerOnSlides = false;
  bool _isAutoPlaying = false;

  late List<String> imagesList;

  void _autoPlaySlides() {
    if (_isAutoPlaying) return;
    setState(() {
      _isAutoPlaying = true;
    });

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && !_isFingerOnSlides) {
        final currentIndex = _pageController.page!.toInt();
        if (currentIndex < (widget.announcement.images ?? []).length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          _pageController.jumpToPage(
            0,
          );
        }
      }
    });
  }

  @override
  void initState() {
    final list = widget.announcement.images;
    imagesList = ((list ?? []).isEmpty ? [""] : list)!;
    _autoPlaySlides();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAnnonce();
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final BoostController boostController = GetIt.I.get<BoostController>();

  void checkAnnonce() {
    if (widget.announcement.isBoosted && !widget.announcement.isPublished) {
      GetIt.I.get<AnnonceController>().publishAnnonce(widget.announcement.id);
    }
    // viewAnnonce();
  }

  // void viewAnnonce() {
  //   if (AppAuth.myProfile != null) {
  //     GetIt.I.get<AnnonceController>().viewAnnonce(widget.announcement.id);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (!_isFingerOnSlides) {
      _autoPlaySlides();
    }
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Détails de l\'annonce',
          style: TextStyle(
            // color: white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            // color: white
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Listener(
                    onPointerDown: (_) {
                      setState(() {
                        _isFingerOnSlides = true;
                      });
                    },
                    onPointerUp: (_) {
                      setState(() {
                        _isFingerOnSlides = false;
                      });
                    },
                    child: SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: imagesList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageViewer(
                                          imageUrl: imagesList[index])),
                                );
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: imagesList[index],
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            widget.announcement.boostTypeId?.title ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                children: imagesList.asMap().entries.map((entry) {
                  // int idx = entry.key;
                  dynamic img = entry.value;
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => FullScreenImageViewer(
                      //       imageUrls: imagesList,
                      //       initialIndex: idx,
                      //     ),
                      //   ),
                      // );
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: img,
                          fit: BoxFit.cover,
                        )),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text(
                widget.announcement.title,
                style: const TextStyle(
                  // color: white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Publié le: ${DateFormat('MMMM d, yyyy').format(widget.announcement.createdAt)}',
                style: TextStyle(
                  // color: white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.announcement.description,
                style: const TextStyle(
                  // color: white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.announcement.ville ?? 'Unknown',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.calendar_month, color: Colors.grey, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Age: 22 years old',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (!widget.announcement.isMine)
                ElevatedButton(
                  onPressed: () async {
                    // if (AppAuth.myProfile == null) {
                    //   context.toPageAndRemoveAllWithOutAnimation(LoginView());
                    //   return;
                    // }
                    _showContactModal();
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Contacter l\'annonceur',
                    style: TextStyle(
                      fontSize: 18,
                      // color: white
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (!widget.announcement.isBoosted)
                ElevatedButton(
                  onPressed: () {
                    boostController.changeAnnonce(widget.announcement);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoostAnnoncementScreen(
                          annonces: widget.announcement,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                        // color: primary
                        ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Booster l\'annonce',
                    style: TextStyle(
                      fontSize: 18,
                      // color: primary
                    ),
                  ),
                ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (modalContext) {
        // Use a different context name to avoid confusion
        return Container(
          height: 250,
          decoration: const BoxDecoration(
            // color: bgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtres',
                  style: TextStyle(
                      // color: white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // ListTile(
                //   leading: SvgPicture.asset("assets/icons/phone.svg"),
                //   contentPadding: EdgeInsets.zero,
                //   title: const Text('Via appel direct',
                //       style: TextStyle(color: white, fontSize: 16)),
                //   trailing: const Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(Icons.arrow_forward_ios, color: primary, size: 16),
                //     ],
                //   ),
                //   onTap: () {},
                // ),
                const Divider(color: Colors.grey),
                // Date Filter
                ListTile(
                  leading: Icon(Icons.chat_bubble_outline),
                  //  SvgPicture.asset("assets/icons/chat.svg"),
                  contentPadding: EdgeInsets.zero,
                  title:
                      const Text('Via Message', style: TextStyle(fontSize: 16)),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ],
                  ),
                  onTap: () async {
                    await GetIt.I
                        .get<AnnonceController>()
                        .createConversation(widget.announcement.id, context)
                        .then((e) async {
                      if (e != null) {
                        VChatController.I.vNavigator.messageNavigator
                            .toMessagePage(context, e);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
