import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:super_up/app/modules/annonces/presentation/announcement_detail_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces;

class AnnoncmentComponent extends StatefulWidget {
  final Annonces announcement;
  const AnnoncmentComponent({
    super.key,
    required this.announcement,
  });

  @override
  State<AnnoncmentComponent> createState() => _AnnoncmentComponentState();
}

class _AnnoncmentComponentState extends State<AnnoncmentComponent> {
  bool _isPressed = false;
  late PageController _pageController;
  int _currentImageIndex = 0;
  Timer? _timer;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Start slideshow if multiple images
    if ((widget.announcement.images?.length ?? 0) > 1) {
      _startSlideshow();
    }
  }

  void _startSlideshow() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients && !_isHovered) {
        final nextIndex = (_currentImageIndex + 1) %
            (widget.announcement.images?.length ?? 1);
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _getBoostBadgeText() {
    if (widget.announcement.boostType?.title != null) {
      return widget.announcement.boostType!.title.toUpperCase();
    }
    return 'GRATUIT';
  }

  Color _getBoostBadgeColor() {
    final boostTitle =
        widget.announcement.boostType?.title.toUpperCase() ?? 'GRATUIT';
    switch (boostTitle) {
      case 'PREMIUM':
        return const Color(0xFFFFD700);
      case 'GOLD':
        return const Color(0xFFFFAA00);
      case 'SILVER':
        return const Color(0xFFC0C0C0);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.announcement.images?.isNotEmpty ?? false;
    final images = widget.announcement.images ?? [];
    final isBoosted = widget.announcement.isBoosted;
    final boostColor = _getBoostBadgeColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTapDown: (_) {
          HapticFeedback.lightImpact();
          setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          HapticFeedback.mediumImpact();
          context.toPage(
            AnnouncementDetailPage(announcement: widget.announcement),
          );
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.08),
                ],
              ),
              border: Border.all(
                color: isBoosted
                    ? boostColor.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.2),
                width: isBoosted ? 2.5 : 1.5,
              ),
              boxShadow: [
                if (isBoosted)
                  BoxShadow(
                    color: boostColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 1,
                  ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
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
                      // Slideshow Thumbnail - Taille réduite
                      Listener(
                        onPointerDown: (_) => setState(() => _isHovered = true),
                        onPointerUp: (_) => setState(() => _isHovered = false),
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.grey[900]!,
                                    Colors.grey[800]!,
                                  ],
                                ),
                              ),
                              child: hasImages
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: PageView.builder(
                                        controller: _pageController,
                                        onPageChanged: (index) => setState(
                                            () => _currentImageIndex = index),
                                        itemCount: images.length,
                                        itemBuilder: (context, index) {
                                          return kIsWeb
                                              ? Image.network(
                                                  images[index],
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      _buildPlaceholder(),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: images[index],
                                                  fit: BoxFit.cover,
                                                  placeholder: (_, __) =>
                                                      _buildPlaceholder(),
                                                  errorWidget: (_, __, ___) =>
                                                      _buildPlaceholder(),
                                                );
                                        },
                                      ),
                                    )
                                  : _buildPlaceholder(),
                            ),
                            // Story Progress Bars
                            if (images.length > 1)
                              Positioned(
                                top: 8,
                                left: 8,
                                right: 8,
                                child: Row(
                                  children:
                                      List.generate(images.length, (index) {
                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: _currentImageIndex == index
                                                ? Colors.white
                                                : Colors.white
                                                    .withValues(alpha: 0.3),
                                            borderRadius:
                                                BorderRadius.circular(1),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            // Boost badge
                            if (isBoosted)
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        boostColor,
                                        boostColor.withValues(alpha: 0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            boostColor.withValues(alpha: 0.5),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.bolt_rounded,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        _getBoostBadgeText(),
                                        style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    .animate(
                                        onPlay: (controller) =>
                                            controller.repeat())
                                    .shimmer(
                                      duration: 2000.ms,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Contenu - Plus compact
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Catégorie
                            if (widget.announcement.categoryInfo?.name != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryGreen
                                          .withValues(alpha: 0.25),
                                      AppTheme.primaryGreen
                                          .withValues(alpha: 0.15),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.announcement.categoryInfo!.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryGreen,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            // Titre et prix
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.announcement.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3,
                                    height: 1.1,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.announcement.price > 0) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.primaryGreen
                                              .withValues(alpha: 0.2),
                                          AppTheme.primaryGreen
                                              .withValues(alpha: 0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.primaryGreen
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      '${NumberFormat('#,###').format(widget.announcement.price)} FCFA',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Description
                            Text(
                              widget.announcement.description,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 12,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Localisation
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: AppTheme.primaryGreen,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${widget.announcement.ville ?? "Ville"}',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Footer: date et vues
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 11,
                                        color:
                                            Colors.white.withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        DateFormat('dd MMM', 'fr_FR').format(
                                            widget.announcement.createdAt),
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.6),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // Views with animation
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.visibility_rounded,
                                        size: 11,
                                        color:
                                            Colors.white.withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${widget.announcement.views ?? 0}',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.6),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true),
                                    )
                                    .scale(
                                      begin: const Offset(1.0, 1.0),
                                      end: const Offset(1.05, 1.05),
                                      duration: 2000.ms,
                                      curve: Curves.easeInOut,
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
        ),
      ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[800]!,
            Colors.grey[700]!,
            Colors.grey[600]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(),
            ),
          ),
          // Icon
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  'Aucune image',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    const dotSize = 2.0;
    const spacing = 8.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
