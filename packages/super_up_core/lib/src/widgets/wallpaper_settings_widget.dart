// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_platform/v_platform.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../super_up_core.dart';

/// Widget for managing room wallpaper settings
class VWallpaperSettingsWidget extends StatefulWidget {
  final String roomId;
  final VoidCallback? onWallpaperChanged;

  const VWallpaperSettingsWidget({
    super.key,
    required this.roomId,
    this.onWallpaperChanged,
  });

  @override
  State<VWallpaperSettingsWidget> createState() => _VWallpaperSettingsWidgetState();
}

class _VWallpaperSettingsWidgetState extends State<VWallpaperSettingsWidget> {
  bool _isLoading = false;
  String? _currentWallpaper;

  @override
  void initState() {
    super.initState();
    _loadCurrentWallpaper();
  }

  void _loadCurrentWallpaper() {
    _currentWallpaper = VWallpaperStorage.getRoomWallpaper(widget.roomId);
  }

  Future<void> _selectWallpaper() async {
    if (!VPlatforms.isMobile) return;
    
    HapticFeedback.selectionClick();
    
    setState(() {
      _isLoading = true;
    });

    try {
      final wallpaperPath = await VWallpaperPicker.showWallpaperPicker(context);
      if (wallpaperPath != null) {
        HapticFeedback.mediumImpact();
        await VWallpaperStorage.setRoomWallpaper(widget.roomId, wallpaperPath);
        setState(() {
          _currentWallpaper = wallpaperPath;
        });
        VEventBusSingleton.vEventBus.fire(
          VUpdateRoomWallpaperEvent(roomId: widget.roomId, wallpaperPath: wallpaperPath),
        );
        widget.onWallpaperChanged?.call();
        
        if (mounted) {
          _showSuccessSnackBar('Wallpaper updated successfully');
        }
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        _showErrorDialog('Failed to set wallpaper');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeWallpaper() async {
    HapticFeedback.lightImpact();
    
    setState(() {
      _isLoading = true;
    });

    try {
      HapticFeedback.mediumImpact();
      await VWallpaperStorage.removeRoomWallpaper(widget.roomId);
      setState(() {
        _currentWallpaper = null;
      });
      VEventBusSingleton.vEventBus.fire(
        VUpdateRoomWallpaperEvent(roomId: widget.roomId, wallpaperPath: null),
      );
      widget.onWallpaperChanged?.call();
      
      if (mounted) {
        _showSuccessSnackBar('Wallpaper removed');
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        _showErrorDialog('Failed to remove wallpaper');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Row(
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              color: CupertinoColors.systemRed.resolveFrom(context),
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text('Error'),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildWallpaperPreview() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _currentWallpaper == null
            ? (CupertinoTheme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[300])
            : null,
        image: _currentWallpaper != null
            ? DecorationImage(
                image: _currentWallpaper!.startsWith('assets/')
                    ? AssetImage(_currentWallpaper!) as ImageProvider
                    : FileImage(File(_currentWallpaper!)),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: _currentWallpaper != null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: _currentWallpaper == null
          ? Icon(
              CupertinoIcons.photo,
              color: CupertinoTheme.of(context).brightness == Brightness.dark
                  ? Colors.grey[600]
                  : Colors.grey[500],
              size: 28,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!VPlatforms.isMobile) {
      return const SizedBox.shrink();
    }

    return CupertinoListTile(
      leading: _buildWallpaperPreview(),
      title: const Text('Wallpaper'),
      subtitle: Text(
        _currentWallpaper != null ? 'Custom wallpaper set' : 'Default wallpaper',
      ),
      trailing: _isLoading
          ? const CupertinoActivityIndicator()
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_currentWallpaper != null)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.delete,
                      color: CupertinoColors.destructiveRed,
                    ),
                    onPressed: _removeWallpaper,
                  ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.photo),
                  onPressed: _selectWallpaper,
                ),
              ],
            ),
      onTap: _selectWallpaper,
    );
  }
}