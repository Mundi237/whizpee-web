// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';
import 'package:super_up/app/modules/annonces/presentation/profile_screen.dart';
import 'package:super_up/app/modules/annonces/presentation/announcement_detail_page.dart';
import 'package:super_up_core/super_up_core.dart';

class BoostAnnonceBottomSheet extends StatefulWidget {
  const BoostAnnonceBottomSheet({super.key});

  @override
  State<BoostAnnonceBottomSheet> createState() =>
      _BoostAnnonceBottomSheetState();
}

class _BoostAnnonceBottomSheetState extends State<BoostAnnonceBottomSheet>
    with SingleTickerProviderStateMixin {
  int selectedDays = 3;
  bool _isProcessing = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<BoostController>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D0D0D),
            const Color(0xFF1A0E2E),
            const Color(0xFF2D1B4E),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              _buildHeader(),
              // Selected duration display
              _buildDurationDisplay(),
              // Slider
              _buildSlider(),
              // Quick suggestions
              _buildQuickSuggestions(),
              const Spacer(),
              // Action buttons
              _buildActionButtons(controller),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: AppTheme.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durée du boost',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choisissez combien de temps votre annonce sera boostée',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0);
  }

  Widget _buildDurationDisplay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryGreen
                      .withValues(alpha: 0.2 + (0.1 * _pulseController.value)),
                  AppTheme.primaryGreen
                      .withValues(alpha: 0.1 + (0.05 * _pulseController.value)),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryGreen
                    .withValues(alpha: 0.4 + (0.2 * _pulseController.value)),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen
                      .withValues(alpha: 0.3 * _pulseController.value),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rocket_launch_rounded,
                  color: AppTheme.primaryGreen,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  '$selectedDays ${selectedDays <= 1 ? "jour" : "jours"}',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryGreen,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
              thumbColor: AppTheme.primaryGreen,
              overlayColor: AppTheme.primaryGreen.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              trackHeight: 6,
            ),
            child: Slider(
              value: selectedDays.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '$selectedDays ${selectedDays <= 1 ? "jour" : "jours"}',
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() {
                  selectedDays = value.round();
                });
              },
            ),
          ),
          // Min/Max indicators
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1 jour',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '30 jours',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildQuickSuggestions() {
    final suggestions = [
      {'days': 1, 'label': '1 jour', 'popular': false},
      {'days': 3, 'label': '3 jours', 'popular': true},
      {'days': 7, 'label': '1 semaine', 'popular': true},
      {'days': 14, 'label': '2 semaines', 'popular': false},
      {'days': 30, 'label': '1 mois', 'popular': false},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Suggestions populaires',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: suggestions.map((suggestion) {
              final days = suggestion['days'] as int;
              final label = suggestion['label'] as String;
              final isPopular = suggestion['popular'] as bool;
              final isSelected = selectedDays == days;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    selectedDays = days;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppTheme.primaryGreen,
                              AppTheme.primaryGreen.withValues(alpha: 0.8),
                            ],
                          )
                        : null,
                    color: isSelected
                        ? null
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : isPopular
                              ? AppTheme.primaryGreen.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isPopular && !isSelected) ...[
                        Icon(
                          Icons.trending_up_rounded,
                          color: AppTheme.primaryGreen,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : isPopular
                                  ? AppTheme.primaryGreen
                                  : Colors.white.withValues(alpha: 0.7),
                          fontWeight: isSelected || isPopular
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildActionButtons(BoostController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _isProcessing
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close_rounded,
                      color: Colors.white
                          .withValues(alpha: _isProcessing ? 0.5 : 1),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Annuler',
                      style: TextStyle(
                        color: Colors.white
                            .withValues(alpha: _isProcessing ? 0.5 : 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ValueListenableBuilder(
              valueListenable: controller.boostsState,
              builder: (_, state, __) {
                return GestureDetector(
                  onTap:
                      (_isProcessing || state.isLoading) ? null : _processBoost,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.primaryGreen.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.isLoading || _isProcessing) ...[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ] else ...[
                          Icon(
                            Icons.rocket_launch_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          (state.isLoading || _isProcessing)
                              ? 'Boost en cours...'
                              : 'Booster gratuitement',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 800.ms);
  }

  void _processBoost() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    HapticFeedback.mediumImpact();

    try {
      final controller = GetIt.I.get<BoostController>();
      final annonceController = GetIt.I.get<AnnonceController>();

      await controller.boosAnnonce(selectedDays);

      if (controller.boostsState.value.hasNotNullData && mounted) {
        // Attendre un peu avant de publier pour éviter les conflits
        await Future.delayed(const Duration(milliseconds: 500));

        await annonceController
            .publishAnnonce(
          controller.selectedAnnonce!.id,
        )
            .catchError((e) {
          // Gérer les erreurs de publication silencieusement
          debugPrint('Erreur lors de la publication après boost: $e');
        });

        // Rafraîchir la liste des annonces
        annonceController.getAnnonces(true).catchError((e) {
          debugPrint('Erreur lors du rafraîchissement des annonces: $e');
        });

        if (mounted) {
          HapticFeedback.mediumImpact();
          VAppAlert.showSuccessSnackBar(
            message: "Annonce boostée avec succès",
            context: context,
          );
          _navigateToProfile();
        }
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        VAppAlert.showErrorSnackBar(
          message: "Erreur lors du boost: ${e.toString()}",
          context: context,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _navigateToProfile() {
    if (!mounted) return;

    // Close the bottom sheet first
    Navigator.of(context).pop();

    // Use a slight delay to ensure the bottom sheet is closed before navigation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        final controller = GetIt.I.get<BoostController>();
        if (controller.selectedAnnonce != null) {
          // Navigate to announcement detail page using pushReplacement
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AnnouncementDetailPage(
                announcement: controller.selectedAnnonce!,
              ),
            ),
          );
        } else {
          // Fallback to profile if no announcement is selected
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      }
    });
  }
}
