// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v_platform/v_platform.dart';

import '../v_chat/app_pick.dart';

/// Utility class for wallpaper selection and management
abstract class VWallpaperPicker {
  /// Show wallpaper selection dialog
  static Future<String?> showWallpaperPicker(BuildContext context) async {
    if (!VPlatforms.isMobile) return null;
    
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) => const _WallpaperPickerSheet(),
    );
  }

  /// Pick image from gallery for wallpaper
  static Future<String?> pickImageFromGallery() async {
    if (!VPlatforms.isMobile) return null;
    
    final image = await VAppPick.getImage();
    if (image == null) return null;
    
    return await _saveWallpaperToAppDirectory(image);
  }

  /// Pick image from camera for wallpaper
  static Future<String?> pickImageFromCamera() async {
    if (!VPlatforms.isMobile) return null;
    
    final image = await VAppPick.getImage(isFromCamera: true);
    if (image == null) return null;
    
    return await _saveWallpaperToAppDirectory(image);
  }

  /// Save wallpaper file to app directory
  static Future<String?> _saveWallpaperToAppDirectory(VPlatformFile image) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final wallpaperDir = Directory('${appDir.path}/wallpapers');
      
      if (!wallpaperDir.existsSync()) {
        wallpaperDir.createSync(recursive: true);
      }
      
      final fileName = 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${wallpaperDir.path}/$fileName';
      
      if (image.fileLocalPath != null) {
        // Copy from local path
        final sourceFile = File(image.fileLocalPath!);
        await sourceFile.copy(filePath);
      } else if (image.bytes != null) {
        // Save from bytes
        final file = File(filePath);
        await file.writeAsBytes(image.bytes!);
      } else {
        return null;
      }
      
      return filePath;
    } catch (e) {
      return null;
    }
  }

  /// Get predefined wallpaper options
  static List<String> getPredefinedWallpapers() {
    return [
      'assets/images/pattern_dark.png',
      'assets/images/pattern_light.png',
    ];
  }
}

/// Wallpaper picker bottom sheet widget
class _WallpaperPickerSheet extends StatelessWidget {
  const _WallpaperPickerSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Wallpaper',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              final wallpaper = await VWallpaperPicker.pickImageFromGallery();
              if (context.mounted) {
                Navigator.of(context).pop(wallpaper);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () async {
              final wallpaper = await VWallpaperPicker.pickImageFromCamera();
              if (context.mounted) {
                Navigator.of(context).pop(wallpaper);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.wallpaper),
            title: const Text('Default Wallpapers'),
            onTap: () {
              _showPredefinedWallpapers(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showPredefinedWallpapers(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Default Wallpapers',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...VWallpaperPicker.getPredefinedWallpapers().map(
              (wallpaper) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(wallpaper),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(wallpaper.split('/').last.split('.').first),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(wallpaper);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}