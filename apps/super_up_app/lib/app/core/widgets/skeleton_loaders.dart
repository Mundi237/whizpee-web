import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Composants squelettes avec design glassmorphism cohérent
class SkeletonLoaders {
  static Widget shimmerEffect({required Widget child}) {
    return child.animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.1),
          angle: 0.5,
        );
  }

  /// Squelette pour une annonce dans la liste
  static Widget announcementCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image skeleton
                  shimmerEffect(
                    child: Container(
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content skeleton
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        shimmerEffect(
                          child: Container(
                            width: 80,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Title
                        shimmerEffect(
                          child: Container(
                            width: double.infinity,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        shimmerEffect(
                          child: Container(
                            width: 150,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Price
                        shimmerEffect(
                          child: Container(
                            width: 100,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Description
                        shimmerEffect(
                          child: Container(
                            width: double.infinity,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        shimmerEffect(
                          child: Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Location and date
                        Row(
                          children: [
                            shimmerEffect(
                              child: Container(
                                width: 80,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            const Spacer(),
                            shimmerEffect(
                              child: Container(
                                width: 40,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Squelette pour les onglets de filtres
  static Widget filterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: List.generate(2, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index == 0 ? 12 : 0),
              child: shimmerEffect(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Squelette pour la barre de recherche
  static Widget searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: shimmerEffect(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
    );
  }

  /// Squelette pour une image d'annonce
  static Widget announcementImage({
    double width = 120,
    double height = 150,
    BorderRadius? borderRadius,
  }) {
    return shimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            color: Colors.white.withValues(alpha: 0.3),
            size: 32,
          ),
        ),
      ),
    );
  }

  /// Squelette pour un texte de ligne
  static Widget textLine({
    required double width,
    double height = 14,
    BorderRadius? borderRadius,
  }) {
    return shimmerEffect(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// Squelette pour la page de détails d'annonce
  static Widget announcementDetail() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header image
          shimmerEffect(
            child: Container(
              width: double.infinity,
              height: 300,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                textLine(width: 100, height: 20),
                const SizedBox(height: 12),
                // Title
                textLine(width: double.infinity, height: 24),
                const SizedBox(height: 8),
                textLine(width: 200, height: 24),
                const SizedBox(height: 16),
                // Price
                textLine(width: 120, height: 20),
                const SizedBox(height: 20),
                // Description
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: textLine(
                      width: index == 3 ? 150 : double.infinity,
                      height: 16,
                    ),
                  );
                }),
                const SizedBox(height: 20),
                // Location and date
                Row(
                  children: [
                    textLine(width: 100, height: 16),
                    const Spacer(),
                    textLine(width: 80, height: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Squelette pour une liste générique
  static Widget listSkeleton({
    int itemCount = 5,
    Widget Function()? itemBuilder,
  }) {
    return Column(
      children: List.generate(itemCount, (index) {
        return itemBuilder?.call() ?? announcementCard();
      }),
    );
  }

  /// Squelette compact pour les éléments de chat
  static Widget chatRoomItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Avatar
          shimmerEffect(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                textLine(width: 150, height: 16),
                const SizedBox(height: 6),
                // Last message
                textLine(width: 200, height: 14),
              ],
            ),
          ),
          // Time
          textLine(width: 40, height: 12),
        ],
      ),
    );
  }
}
