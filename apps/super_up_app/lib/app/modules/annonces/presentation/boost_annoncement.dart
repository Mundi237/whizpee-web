// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/widgets/app_header_logo.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';
import 'package:super_up/app/modules/annonces/presentation/boost_annonce_bootom_sheet.dart';
import 'package:super_up/app/modules/annonces/presentation/announcement_detail_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces, Boost;

class BoostAnnoncementScreen extends StatefulWidget {
  final Annonces annonces;
  const BoostAnnoncementScreen({super.key, required this.annonces});

  @override
  State<BoostAnnoncementScreen> createState() => _BoostAnnoncementScreenState();
}

class _BoostAnnoncementScreenState extends State<BoostAnnoncementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    final BoostController controller = GetIt.I.get<BoostController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getBoosts();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<BoostController>();
    final isDark = VThemeListener.I.isDarkMode;

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
              // Background glassmorphism circles
              Positioned(
                top: -100,
                right: -100,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 280 + (30 * _floatController.value),
                      height: 280 + (30 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGreen.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -120,
                left: -80,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 300 - (30 * _floatController.value),
                      height: 300 - (30 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Main content
              Column(
                children: [
                  // Premium Header with AppHeaderLogo
                  AppHeaderLogo(
                    icon: Icons.rocket_launch_rounded,
                    title: "Booster l'annonce",
                    actions: [
                      // Info button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showInfoModal();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Announcement Preview Card
                  _buildAnnouncementPreview(),
                  // Content
                  Expanded(
                    child: ValueListenableBuilder<AppState<List<Boost>>>(
                      valueListenable: controller.boostsListState,
                      builder: (context, state, child) {
                        if (state.isLoading) {
                          return _buildLoadingState();
                        }
                        if (state.hasError) {
                          return _buildErrorState(controller, state);
                        }
                        if ((state.data ?? []).isEmpty) {
                          return _buildEmptyState(controller);
                        }

                        final List<Boost> boosts = state.data!;
                        return _buildBoostsList(boosts);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementPreview() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.image_rounded,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.annonces.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.annonces.ville ?? 'Ville non spécifiée',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.annonces.price != null &&
                        widget.annonces.price! > 0)
                      Text(
                        '${widget.annonces.price} XAF',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0);
  }

  void _showInfoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0D0D0D),
                const Color(0xFF1A0E2E),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.rocket_launch_rounded,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'À propos du boost',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Le boost augmente la visibilité de votre annonce en la positionnant en tête des résultats de recherche.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Avantages du boost :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoPoint('Plus de visibilité',
                        'Votre annonce apparaît en premier'),
                    _buildInfoPoint(
                        'Plus de vues', 'Augmentez le nombre de consultations'),
                    _buildInfoPoint(
                        'Plus de contacts', 'Recevez plus de messages'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryGreen),
          const SizedBox(height: 16),
          Text(
            'Chargement des options de boost...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BoostController controller, AppState<List<Boost>> state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red.shade400,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.errorModel?.error ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.getBoosts();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BoostController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.rocket_launch_outlined,
                color: Colors.white.withValues(alpha: 0.4),
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucune option de boost',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aucune option de boost n\'est disponible pour le moment',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                controller.getBoosts();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Actualiser'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoostsList(List<Boost> boosts) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choisissez votre boost',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Options de boost payants
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: boosts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final boost = boosts[index];
                // Vérifier si c'est le boost TOP pour le marquer comme recommandé
                final isRecommended = boost.title.toUpperCase() == 'TOP';
                // Vérifier si c'est le boost SILVER (gratuit et illimité)
                final isFreeBoost = boost.title.toUpperCase() == 'SILVER';

                return BoostOptionCard(
                  boost: boost,
                  isRecommended: isRecommended,
                  isFreeBoost: isFreeBoost,
                  onTap: () => isFreeBoost
                      ? _showFreeBoostDirectly()
                      : _showBoostDayNumbers(boost),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  void _showFreeBoostDirectly() {
    HapticFeedback.lightImpact();
    // Pour le boost SILVER (gratuit et illimité), on applique directement sans sélection de période
    final controller = GetIt.I.get<BoostController>();
    // Trouver le boost SILVER dans la liste
    final boosts = controller.boostsListState.value.data ?? [];
    final silverBoost = boosts.firstWhere(
      (boost) => boost.title.toUpperCase() == 'SILVER',
      orElse: () => boosts.first, // Fallback si non trouvé
    );

    controller.changeBoost(silverBoost);

    // Naviguer directement vers le processus de boost sans sélection de période
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (builderContext) {
        return const BoostAnnonceBottomSheet();
      },
    );
  }

  void _showBoostDayNumbers(Boost boost) {
    final controller = GetIt.I.get<BoostController>();
    controller.changeBoost(boost);
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (builderContext) {
        return const BoostAnnonceBottomSheet();
      },
    );
    // Removed the .then() callback that was causing navigation issues
  }

  void _navigateToProfile() {
    if (!mounted) return;

    // Navigate to announcement detail page instead of profile
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => AnnouncementDetailPage(
          announcement: widget.annonces,
        ),
      ),
      (route) => false,
    );
  }
}

class BoostOptionCard extends StatelessWidget {
  final Boost boost;
  final VoidCallback onTap;
  final bool isRecommended;
  final bool isFreeBoost;

  const BoostOptionCard({
    super.key,
    required this.boost,
    required this.onTap,
    this.isRecommended = false,
    this.isFreeBoost = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isRecommended
                ? [
                    AppTheme.primaryGreen.withValues(alpha: 0.15),
                    AppTheme.primaryGreen.withValues(alpha: 0.08),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRecommended
                ? AppTheme.primaryGreen.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.15),
            width: isRecommended ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isRecommended
                            ? AppTheme.primaryGreen.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        color: isRecommended
                            ? AppTheme.primaryGreen
                            : Colors.white.withValues(alpha: 0.7),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                boost.title,
                                style: TextStyle(
                                  color: isRecommended
                                      ? AppTheme.primaryGreen
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isRecommended) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGreen,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Recommandé',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            boost.description,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isRecommended
                          ? AppTheme.primaryGreen
                          : Colors.white.withValues(alpha: 0.5),
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isFreeBoost
                            ? Icons.all_inclusive_rounded
                            : Icons.info_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isFreeBoost
                              ? 'Boost gratuit et illimité - Actif immédiatement'
                              : 'Appuyez pour choisir la durée du boost',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// final List<BoostOption> _boostOptions = [
//   BoostOption(
//     level: 'TOP',
//     description: 'Soyez en haut, restez visible. Visibilité maximale.',
//     amount: 15000,
//   ),
//   BoostOption(
//     level: 'VVIP',
//     description: 'Un traitement royal pour votre annonce.',
//     amount: 10000,
//   ),
//   BoostOption(
//     level: 'PREMIUM',
//     description: 'Encadré spécial + badge + remontée auto.',
//     amount: 5000,
//   ),
//   BoostOption(
//     level: 'VIP',
//     description: 'Badge VIP + remontée régulière.',
//     amount: 2500,
//   ),
//   BoostOption(
//     level: 'GOLD',
//     description: 'Badge doré, excellent rapport qualité/prix.',
//     amount: 1000,
//   ),
//   BoostOption(
//     level: 'SILVER',
//     description: 'Gratuit, affiché sans boost.',
//     amount: 500,
//   ),
// ];

String formatToFCFA(num value, {bool showCurrency = true, int decimals = 1}) {
  if (value == 0) {
    return showCurrency ? "0 FCFA" : "0";
  }

  String suffix = "";
  double formattedValue = value.toDouble();

  // Déterminer le suffixe et diviser la valeur
  if (value.abs() >= 1000000000) {
    // Milliards
    formattedValue = value / 1000000000;
    suffix = "B";
  } else if (value.abs() >= 1000000) {
    // Millions
    formattedValue = value / 1000000;
    suffix = "M";
  } else if (value.abs() >= 1000) {
    // Milliers
    formattedValue = value / 1000;
    suffix = "k";
  }

  // Formater le nombre
  String formattedString;

  if (suffix.isNotEmpty) {
    // Pour les nombres avec suffixe, utiliser les décimales si nécessaire
    if (formattedValue == formattedValue.roundToDouble()) {
      // Nombre entier
      formattedString = formattedValue.round().toString();
    } else {
      // Nombre décimal
      formattedString = formattedValue.toStringAsFixed(decimals);
      // Supprimer les zéros inutiles à la fin
      formattedString = formattedString.replaceAll(RegExp(r'\.?0+$'), '');
    }
    formattedString += suffix;
  } else {
    // Pour les nombres < 1000, ajouter des espaces comme séparateurs de milliers
    formattedString = _addThousandSeparators(value.round());
  }

  return showCurrency ? "$formattedString FCFA" : formattedString;
}

/// Ajoute des espaces comme séparateurs de milliers
/// Exemple: 1234567 → "1 234 567"
String _addThousandSeparators(int value) {
  String str = value.abs().toString();
  String result = '';

  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) {
      result += ' ';
    }
    result += str[i];
  }

  return value < 0 ? '-$result' : result;
}

/// Version alternative avec plus d'options de personnalisation
String formatToFCFAAdvanced(
  num value, {
  bool showCurrency = true,
  int decimals = 1,
  bool useCommaAsDecimalSeparator = true,
  String currencySymbol = "FCFA",
  bool currencyBefore = false,
}) {
  if (value == 0) {
    String currency = showCurrency
        ? (currencyBefore ? "$currencySymbol " : " $currencySymbol")
        : "";
    return currencyBefore ? "${currency}0" : "0$currency";
  }

  String suffix = "";
  double formattedValue = value.toDouble();

  // Déterminer le suffixe et diviser la valeur
  if (value.abs() >= 1000000000) {
    formattedValue = value / 1000000000;
    suffix = "B";
  } else if (value.abs() >= 1000000) {
    formattedValue = value / 1000000;
    suffix = "M";
  } else if (value.abs() >= 1000) {
    formattedValue = value / 1000;
    suffix = "k";
  }

  // Formater le nombre
  String formattedString;

  if (suffix.isNotEmpty) {
    if (formattedValue == formattedValue.roundToDouble()) {
      formattedString = formattedValue.round().toString();
    } else {
      formattedString = formattedValue.toStringAsFixed(decimals);
      formattedString = formattedString.replaceAll(RegExp(r'\.?0+$'), '');

      // Remplacer le point par une virgule si demandé
      if (useCommaAsDecimalSeparator) {
        formattedString = formattedString.replaceAll('.', ',');
      }
    }
    formattedString += suffix;
  } else {
    formattedString = _addThousandSeparators(value.round());
  }

  // Ajouter la devise
  if (showCurrency) {
    if (currencyBefore) {
      return "$currencySymbol $formattedString";
    } else {
      return "$formattedString $currencySymbol";
    }
  }

  return formattedString;
}
