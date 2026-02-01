import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:super_up/app/core/app_config/app_config_controller.dart';
import 'package:super_up/app/core/widgets/app_header_logo.dart';
import 'package:super_up/app/core/widgets/skeleton_loaders.dart';
import 'package:super_up/app/modules/annonces/presentation/boost_annoncement.dart';
import 'package:super_up/app/modules/annonces/presentation/image_viewer.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';
import 'package:super_up/app/modules/home/mobile/rooms_tab/controllers/rooms_tab_controller.dart';
import 'package:super_up/app/modules/home/home_wide_modules/home/controller/home_wide_controller.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:super_up/app/core/utils/date_formatter.dart';
import 'package:super_up/app/modules/annonces/datas/services/api_services.dart';
import 'package:super_up/app/core/widgets/universal_image.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart'
    show Annonces, VChatController;

class AnnouncementDetailPage extends StatefulWidget {
  final Annonces announcement;

  const AnnouncementDetailPage({super.key, required this.announcement});

  @override
  State<AnnouncementDetailPage> createState() => _AnnouncementDetailPageState();
}

class _AnnouncementDetailPageState extends State<AnnouncementDetailPage>
    with SingleTickerProviderStateMixin {
  late final RoomsTabController controller;
  final config = VAppConfigController.appConfig;
  final PageController _pageController = PageController();
  late AnimationController _floatController;

  bool _isFingerOnSlides = false;
  bool _isAutoPlaying = false;
  late List<String> imagesList;
  int _currentImageIndex = 0;

  // Add state for the updated announcement data
  Annonces? _updatedAnnouncement;
  bool _isLoadingDetails = true;

  @override
  void initState() {
    super.initState();
    final list = widget.announcement.images;
    imagesList = ((list ?? []).isEmpty ? [""] : list)!;

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _autoPlaySlides();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnnouncementDetails();
    });
  }

  Future<void> _loadAnnouncementDetails() async {
    try {
      final annonceController = GetIt.I.get<AnnonceController>();
      final updatedAnnouncement =
          await annonceController.getAnnonceDetails(widget.announcement.id);

      setState(() {
        _updatedAnnouncement = updatedAnnouncement;
        _isLoadingDetails = false;
        // Update images list if needed
        final updatedImages = updatedAnnouncement.images;
        if (updatedImages != null && updatedImages.isNotEmpty) {
          imagesList = updatedImages;
        }
      });

      checkAnnonce();
    } catch (e) {
      setState(() {
        _isLoadingDetails = false;
      });
      debugPrint('Erreur lors du chargement des détails de l\'annonce: $e');
    }
  }

  // Helper method to get the current announcement (updated or original)
  Annonces get currentAnnouncement =>
      _updatedAnnouncement ?? widget.announcement;

  void _autoPlaySlides() {
    if (_isAutoPlaying || imagesList.length <= 1) return;
    setState(() {
      _isAutoPlaying = true;
    });

    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_pageController.hasClients && !_isFingerOnSlides) {
        final currentIndex = _pageController.page?.round() ?? 0;
        if (currentIndex < imagesList.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        } else {
          _pageController.jumpToPage(0);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  final BoostController boostController = GetIt.I.get<BoostController>();

  void checkAnnonce() {
    final announcement = currentAnnouncement;
    if (announcement.isBoosted && !announcement.isPublished) {
      // Appeler publishAnnonce avec gestion d'erreur silencieuse
      GetIt.I
          .get<AnnonceController>()
          .publishAnnonce(announcement.id)
          .catchError((e) {
        // Logger l'erreur mais ne pas planter l'application
        debugPrint('Erreur lors de la publication automatique: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0D0D0D),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF2D1B4E),
                  ]
                : [
                    const Color(0xFF000000),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF3D2257),
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background Effects
              Positioned(
                top: -100,
                right: -100,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 300 + (30 * _floatController.value),
                      height: 300 + (30 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGreen.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Main Content
              Column(
                children: [
                  // Premium Header with AppHeaderLogo
                  AppHeaderLogo(
                    icon: Icons.article_rounded,
                    title: "Détails de l'annonce",
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (GetIt.I.get<AppSizeHelper>().isWide(context)) {
                              GetIt.I.get<HomeWideController>().closeDetail();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Image carousel section
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Container(
                            height: size.height * 0.4,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Image Slider
                                  Listener(
                                    onPointerDown: (_) => setState(
                                        () => _isFingerOnSlides = true),
                                    onPointerUp: (_) => setState(
                                        () => _isFingerOnSlides = false),
                                    child: PageView.builder(
                                      controller: _pageController,
                                      onPageChanged: (index) {
                                        setState(
                                            () => _currentImageIndex = index);
                                      },
                                      itemCount: imagesList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageViewer(
                                                  imageUrl: imagesList[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag:
                                                'annonce_${currentAnnouncement.id}_image_$index',
                                            child: UniversalImage(
                                              imageUrl: _processUrl(
                                                  imagesList[index]),
                                              fit: BoxFit.cover,
                                              placeholderBuilder: (context) =>
                                                  SkeletonLoaders
                                                      .announcementImage(
                                                width: double.infinity,
                                                height: double.infinity,
                                                borderRadius: BorderRadius.zero,
                                              ),
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                color: Colors.grey[900],
                                                child: const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Story-like Progress Indicators
                                  if (imagesList.length > 1)
                                    Positioned(
                                      top: MediaQuery.of(context).padding.top +
                                          12,
                                      left: 20,
                                      right: 20,
                                      child: Row(
                                        children: List.generate(
                                            imagesList.length, (index) {
                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                height: 3.5,
                                                decoration: BoxDecoration(
                                                  color: _currentImageIndex ==
                                                          index
                                                      ? AppTheme.primaryGreen
                                                      : Colors.white.withValues(
                                                          alpha: 0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.3),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),

                                  // Gradient Overlay at bottom
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.8),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Boost Badge
                                  if (currentAnnouncement.isBoosted)
                                    Positioned(
                                      top: 20,
                                      right: 20,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFFFFD700),
                                              const Color(0xFFFFD700)
                                                  .withValues(alpha: 0.8),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFFD700)
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 12,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.bolt_rounded,
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              currentAnnouncement
                                                      .boostType?.title ??
                                                  'BOOSTÉ',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.black,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).animate().scale(
                                          duration: 800.ms,
                                          curve: Curves.bounceOut),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and Price Section
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentAnnouncement.title,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.1,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (currentAnnouncement.price != null &&
                                        currentAnnouncement.price! > 0)
                                      Text(
                                        '${NumberFormat('#,###').format(currentAnnouncement.price)} FCFA',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.primaryGreen,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                  ],
                                )
                                    .animate()
                                    .fadeIn(delay: 100.ms)
                                    .slideY(begin: 0.1),

                                const SizedBox(height: 32),

                                // Info Grid
                                GridView.count(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 2.5,
                                  children: [
                                    _buildInfoCard(
                                      Icons.location_on_rounded,
                                      'Ville',
                                      currentAnnouncement.ville ??
                                          "Non spécifié",
                                    ),
                                    _buildInfoCard(
                                      Icons.map_rounded,
                                      'Quartier',
                                      currentAnnouncement.quartier ??
                                          "Non spécifié",
                                    ),
                                    _buildInfoCard(
                                      Icons.calendar_today_rounded,
                                      'Publié le',
                                      DateFormatter.formatRelativeTime(
                                          currentAnnouncement.createdAt),
                                    ),
                                    _buildInfoCard(
                                      Icons.remove_red_eye_rounded,
                                      'Vues',
                                      _isLoadingDetails
                                          ? '...'
                                          : '${currentAnnouncement.views ?? 0}',
                                    ),
                                  ],
                                ).animate().fadeIn(delay: 200.ms).scale(),

                                const SizedBox(height: 32),

                                // Description
                                Text(
                                  "À PROPOS",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.03),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.05),
                                    ),
                                  ),
                                  child: Text(
                                    currentAnnouncement.description,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.7,
                                      color:
                                          Colors.white.withValues(alpha: 0.85),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ).animate().fadeIn(delay: 300.ms),

                                const SizedBox(
                                    height: 120), // Space for bottom buttons
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Bottom Action Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (!currentAnnouncement.isMine)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _showContactModal(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryGreen,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 8,
                                  shadowColor: AppTheme.primaryGreen
                                      .withValues(alpha: 0.4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.chat_bubble_rounded,
                                        color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Contacter',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (!currentAnnouncement.isMine)
                            const SizedBox(width: 16),
                          if (!currentAnnouncement.isBoosted)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  boostController
                                      .changeAnnonce(currentAnnouncement);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BoostAnnoncementScreen(
                                        annonces: currentAnnouncement,
                                      ),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  side: BorderSide(
                                    color: currentAnnouncement.isMine
                                        ? AppTheme.primaryGreen
                                        : Colors.white.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rocket_launch_rounded,
                                      color: currentAnnouncement.isMine
                                          ? AppTheme.primaryGreen
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Booster',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: currentAnnouncement.isMine
                                            ? AppTheme.primaryGreen
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .slideY(begin: 1, end: 0, duration: 600.ms, delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Contacter l\'annonceur',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.chat_bubble_outline_rounded,
                        color: AppTheme.primaryGreen),
                  ),
                  title: const Text(
                    'Envoyer un message',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Discutez directement dans l\'app'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side:
                        BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  onTap: () async {
                    Navigator.pop(modalContext);
                    await GetIt.I
                        .get<AnnonceController>()
                        .createConversation(currentAnnouncement.id, context)
                        .then((e) async {
                      if (e != null) {
                        VChatController.I.vNavigator.messageNavigator
                            .toMessagePage(context, e);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  String _processUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    final cleanUrl = url.startsWith('/') ? url.substring(1) : url;
    return "$BASE_URL/$cleanUrl";
  }
}
