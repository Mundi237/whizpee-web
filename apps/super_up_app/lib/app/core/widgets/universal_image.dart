import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:super_up/app/core/widgets/skeleton_loaders.dart';
// Conditional import for web support
import 'package:super_up/app/core/widgets/web_image_shim.dart'
    if (dart.library.html) 'dart:ui_web' as ui_web;
import 'package:universal_html/html.dart' as html;

class UniversalImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget Function(BuildContext)? placeholderBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const UniversalImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Generate a unique view type ID for each image to register factory
      final String viewType =
          'img-view-${imageUrl.hashCode}-${DateTime.now().millisecondsSinceEpoch}';

      // Register the view factory
      // Note: In refined implementation, we should check if factory is already registered or use a more generic factory.
      // For simplicity and immediate fixing, we register per unique URL/instance.
      // Ideally, use a parameter-based factory if platform supports it smoothly, or use a cached registry.

      try {
        ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
          final img = html.ImageElement()
            ..src = imageUrl
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = _boxFitToCss(fit);

          // Handle errors on the HTML element level if possible, mostly for logging
          img.onError.listen((event) {
            print("HTML Image Element Error for: $imageUrl");
          });

          return img;
        });
      } catch (e) {
        // Fallback or ignore if already registered (though unique ID prevents this mostly)
        print("Error registering view factory: $e");
      }

      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: SizedBox(
          width: width,
          height: height,
          child: HtmlElementView(viewType: viewType),
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholderBuilder?.call(context) ??
            SkeletonLoaders.announcementImage(
                width: width ?? 100, height: height ?? 100),
        errorWidget: (context, url, error) =>
            errorBuilder?.call(context, error, null) ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[800],
              child: const Icon(Icons.error, color: Colors.white54),
            ),
      ),
    );
  }

  String _boxFitToCss(BoxFit fit) {
    switch (fit) {
      case BoxFit.cover:
        return 'cover';
      case BoxFit.contain:
        return 'contain';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.fitHeight:
        return 'none'; // Approximation or use height 100%
      case BoxFit.fitWidth:
        return 'none'; // Approximation
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scale-down';
    }
  }
}
