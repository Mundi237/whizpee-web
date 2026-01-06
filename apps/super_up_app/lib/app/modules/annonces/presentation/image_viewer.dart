import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:super_up/app/core/theme/app_theme_manager.dart';

class ImageViewer extends StatelessWidget {
  final String imageUrl;
  const ImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: bgColor,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: SizedBox.shrink(),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close,
                // color: white
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ]),
      body: Padding(
        padding: EdgeInsets.all(3),
        child: kIsWeb
            ? PhotoView(imageProvider: NetworkImage(imageUrl))
            : PhotoView(
                imageProvider: CachedNetworkImageProvider(imageUrl),
              ),
      ),
    );
  }
}
