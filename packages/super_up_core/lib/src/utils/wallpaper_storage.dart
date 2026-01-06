// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../v_chat/app_pref.dart';
import 'enums.dart';

/// Utility class for managing room wallpapers in local storage
abstract class VWallpaperStorage {
  /// Save wallpaper path for a specific room
  static Future<void> setRoomWallpaper(String roomId, String wallpaperPath) async {
    final wallpapers = _getRoomWallpapers();
    wallpapers[roomId] = wallpaperPath;
    await VAppPref.setStringKey(
      SStorageKeys.roomWallpapers.name,
      jsonEncode(wallpapers),
    );
    // Emit event to notify UI layers
    VEventBusSingleton.vEventBus.fire(
      VUpdateRoomWallpaperEvent(roomId: roomId, wallpaperPath: wallpaperPath),
    );
  }

  /// Get wallpaper path for a specific room
  static String? getRoomWallpaper(String roomId) {
    final wallpapers = _getRoomWallpapers();
    final wallpaperPath = wallpapers[roomId];
    
    // Check if file still exists
    if (wallpaperPath != null && File(wallpaperPath).existsSync()) {
      return wallpaperPath;
    }
    
    // Remove invalid path if file doesn't exist
    if (wallpaperPath != null) {
      removeRoomWallpaper(roomId);
    }
    
    return null;
  }

  /// Remove wallpaper for a specific room
  static Future<void> removeRoomWallpaper(String roomId) async {
    final wallpapers = _getRoomWallpapers();
    final wallpaperPath = wallpapers.remove(roomId);
    
    // Delete the file if it exists
    if (wallpaperPath != null) {
      try {
        final file = File(wallpaperPath);
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore file deletion errors
      }
    }
    
    await VAppPref.setStringKey(
      SStorageKeys.roomWallpapers.name,
      jsonEncode(wallpapers),
    );
    // Emit reset event
    VEventBusSingleton.vEventBus.fire(
      VUpdateRoomWallpaperEvent(roomId: roomId, wallpaperPath: null),
    );
  }

  /// Get all room wallpapers
  static Map<String, String> _getRoomWallpapers() {
    final data = VAppPref.getStringOrNullKey(SStorageKeys.roomWallpapers.name);
    if (data == null) return {};
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(data);
      return decoded.cast<String, String>();
    } catch (e) {
      return {};
    }
  }

  /// Clear all room wallpapers
  static Future<void> clearAllWallpapers() async {
    final wallpapers = _getRoomWallpapers();
    
    // Delete all wallpaper files
    for (final wallpaperPath in wallpapers.values) {
      try {
        final file = File(wallpaperPath);
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore file deletion errors
      }
    }
    
    await VAppPref.removeKey(SStorageKeys.roomWallpapers.name);
  }

  /// Check if room has custom wallpaper
  static bool hasRoomWallpaper(String roomId) {
    return getRoomWallpaper(roomId) != null;
  }
}