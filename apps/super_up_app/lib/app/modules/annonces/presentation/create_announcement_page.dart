// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/city.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/categorie_controller.dart';
import 'package:super_up/app/modules/annonces/presentation/custom_text_field.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Categorie;
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_platform/v_platform.dart';

class BoostOption {
  final String level;
  final String description;
  final String? badge;
  final double amount;

  BoostOption(
      {required this.level,
      required this.description,
      required this.amount,
      this.badge});
}

class CreateAnnouncementPage extends StatefulWidget {
  const CreateAnnouncementPage({super.key});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage>
    with TickerProviderStateMixin {
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final List<File> _images = [];
  final formKey = GlobalKey<FormState>();

  late AnimationController _floatController;
  late AnimationController _progressController;
  bool _isSubmitting = false;
  int _currentStep = 0;
  final PageController _pageController = PageController();

  final AnnonceController annonceController = GetIt.I.get<AnnonceController>();
  final CategorieController categorieController =
      GetIt.I.get<CategorieController>();

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _progressController.dispose();
    _pageController.dispose();
    annonceController.clearFields();
    super.dispose();
  }

  Future<VBaseMediaRes?> pickImage(bool camera) async {
    HapticFeedback.lightImpact();
    final VPlatformFile? image = await VAppPick.getImage(isFromCamera: camera);
    if (image == null) return null;
    final VBaseMediaRes? mediaAfterEdit = await onSubmitMedia(context, [image]);
    return mediaAfterEdit;
  }

  Future<VBaseMediaRes?> onSubmitMedia(
    BuildContext context,
    List<VPlatformFile> files,
  ) async {
    final fileRes = await context.toPage(VMediaEditorView(
      files: files,
    )) as List<VBaseMediaRes>?;
    if (fileRes == null || fileRes.isEmpty) return null;
    return fileRes.first;
  }

  File? vBaseMediaResToFile(VBaseMediaRes media) {
    try {
      final filePath = media.getVPlatformFile().fileLocalPath;
      if (filePath == null) return null;
      final file = File(filePath);
      return file;
    } catch (e) {
      debugPrint("Erreur conversion VBaseMediaRes en File: $e");
      return null;
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      HapticFeedback.selectionClick();
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.animateTo((_currentStep + 1) / 3);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      HapticFeedback.selectionClick();
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.animateTo((_currentStep + 1) / 3);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return annonceController.titleController.text.trim().length >= 3 &&
            annonceController.descriptionController.text.trim().length >= 10;
      case 1:
        return annonceController.villeController.text.isNotEmpty &&
            quarterController.text.trim().isNotEmpty &&
            annonceController.selectedCategorie != null;
      case 2:
        return _images.isNotEmpty;
      default:
        return false;
    }
  }

  void _showLocationPicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (builderContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
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
                  Container(
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
                            Icons.location_on_rounded,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Choisir une ville',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<AppState<List<City>>>(
                    valueListenable: annonceController.citiesList,
                    builder: (context, value, child) {
                      if (value.isLoading) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Chargement des villes...',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (value.hasError) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.red.shade400,
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  value.errorModel?.error ??
                                      'Erreur de chargement',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    annonceController.getCities();
                                  },
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Réessayer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryGreen,
                                    foregroundColor: Colors.white,
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
                      if ((value.data ?? []).isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.location_off_rounded,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucune ville trouvée',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    annonceController.getCities();
                                  },
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Actualiser'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryGreen,
                                    foregroundColor: Colors.white,
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

                      return ValueListenableBuilder<List<City>>(
                        valueListenable: annonceController.villes,
                        builder: (context, villes, child) {
                          return Expanded(
                            child: Column(
                              children: [
                                // Search field
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: TextField(
                                      onChanged: annonceController.searchVille,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'Rechercher une ville...',
                                        hintStyle: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.5),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          color: AppTheme.primaryGreen,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Cities list
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    itemCount: villes.length,
                                    itemBuilder: (listContext, index) {
                                      final city = villes[index];
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.03),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.08),
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.location_city_rounded,
                                            color: AppTheme.primaryGreen
                                                .withValues(alpha: 0.7),
                                          ),
                                          title: Text(
                                            city.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white
                                                .withValues(alpha: 0.3),
                                            size: 16,
                                          ),
                                          onTap: () {
                                            HapticFeedback.selectionClick();
                                            setState(() {
                                              annonceController.villeController
                                                  .text = city.name;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCategoriesPicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (builderContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
                  Container(
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
                            Icons.category_rounded,
                            color: AppTheme.primaryGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Choisir une catégorie',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<AppState<List<Categorie>>>(
                    valueListenable: categorieController.categoriesState,
                    builder: (context, value, child) {
                      if (value.isLoading) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: AppTheme.primaryGreen,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Chargement des catégories...',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (value.hasError) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.red.shade400,
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  value.errorModel?.error ??
                                      'Erreur de chargement',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    categorieController.getCategories();
                                  },
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Réessayer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryGreen,
                                    foregroundColor: Colors.white,
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
                      if ((value.data ?? []).isEmpty) {
                        return Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.category_outlined,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Aucune catégorie trouvée',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    categorieController.getCategories();
                                  },
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Actualiser'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryGreen,
                                    foregroundColor: Colors.white,
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
                      final List<Categorie> categories = value.data!;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: categories.length,
                          itemBuilder: (listContext, index) {
                            final category = categories[index];
                            final isSelected =
                                annonceController.selectedCategorie?.id ==
                                    category.id;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryGreen
                                        .withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.03),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryGreen
                                          .withValues(alpha: 0.3)
                                      : Colors.white.withValues(alpha: 0.08),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.primaryGreen
                                            .withValues(alpha: 0.2)
                                        : Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.label_rounded,
                                    color: isSelected
                                        ? AppTheme.primaryGreen
                                        : Colors.white.withValues(alpha: 0.6),
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppTheme.primaryGreen
                                        : Colors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: AppTheme.primaryGreen,
                                        size: 24,
                                      )
                                    : Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color:
                                            Colors.white.withValues(alpha: 0.3),
                                        size: 16,
                                      ),
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  annonceController.changeCategorie(category);
                                  setState(() {
                                    _categorieController.text = category.name;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImagePicker(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
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
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.add_photo_alternate_rounded,
                              color: AppTheme.primaryGreen,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Ajouter une photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Options
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildImagePickerOption(
                            icon: Icons.photo_library_rounded,
                            title: 'Galerie',
                            subtitle: 'Choisir depuis vos photos',
                            onTap: () async {
                              Navigator.of(context).pop();
                              final result = await pickImage(false);
                              if (result != null) {
                                final data = vBaseMediaResToFile(result);
                                if (data != null) {
                                  setState(() {
                                    _images.add(data);
                                  });
                                  HapticFeedback.mediumImpact();
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildImagePickerOption(
                            icon: Icons.camera_alt_rounded,
                            title: 'Appareil photo',
                            subtitle: 'Prendre une nouvelle photo',
                            onTap: () async {
                              Navigator.of(context).pop();
                              final result = await pickImage(true);
                              if (result != null) {
                                final data = vBaseMediaResToFile(result);
                                if (data != null) {
                                  setState(() {
                                    _images.add(data);
                                  });
                                  HapticFeedback.mediumImpact();
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _geoLocate() {
    HapticFeedback.lightImpact();
    // TODO: Implement geolocation
    VAppAlert.showErrorSnackBar(
      message: "Géolocalisation bientôt disponible",
      context: context,
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.photo_library_rounded,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Photos de votre annonce',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'Requis',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Ajoutez au moins une photo pour attirer l\'attention',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _images.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < _images.length) {
              final imageFile = _images[index];
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _images.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Image counter
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.8, 0.8));
            } else {
              // Add photo button
              return GestureDetector(
                onTap: () => _showImagePicker(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          color: AppTheme.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ajouter',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        if (_images.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGreen.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_images.length} photo${_images.length > 1 ? 's' : ''} ajoutée${_images.length > 1 ? 's' : ''}. La première sera utilisée comme photo principale.',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  // Header with glassmorphism
                  _buildHeader(),
                  // Progress indicator
                  _buildProgressIndicator(),
                  // Content
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStep1(), // Basic info
                        _buildStep2(), // Location & Category
                        _buildStep3(), // Images
                      ],
                    ),
                  ),
                  // Bottom navigation
                  _buildBottomNavigation(),
                ],
              ),
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
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Créer une annonce',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStepTitle(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryGreen.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${_currentStep + 1}/3',
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0);
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Informations de base';
      case 1:
        return 'Localisation et catégorie';
      case 2:
        return 'Photos de votre annonce';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: List.generate(3, (index) {
              final isActive = index <= _currentStep;
              final isCompleted = index < _currentStep;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isActive
                        ? AppTheme.primaryGreen
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                  child: isCompleted
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: AppTheme.primaryGreen,
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepIndicator(0, 'Infos', Icons.edit_rounded),
              _buildStepIndicator(1, 'Lieu', Icons.location_on_rounded),
              _buildStepIndicator(2, 'Photos', Icons.photo_camera_rounded),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = step == _currentStep;
    final isCompleted = step < _currentStep;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? AppTheme.primaryGreen
                : Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? AppTheme.primaryGreen
                  : Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check_rounded : icon,
            color: isActive || isCompleted
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive || isCompleted
                ? AppTheme.primaryGreen
                : Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
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
                                  'Informations de base',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Donnez un titre et décrivez votre annonce',
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
                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: annonceController.titleController,
                        label: 'Titre de l\'annonce',
                        hint: 'Ex: iPhone 13 Pro Max en excellent état',
                        validator: (title) {
                          if (title == null || title.trim().length < 3) {
                            return "Le titre doit contenir au moins 3 caractères";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: annonceController.descriptionController,
                        label: 'Description détaillée',
                        hint:
                            'Décrivez votre article, son état, ses caractéristiques...',
                        maxLines: 5,
                        validator: (description) {
                          if (description == null ||
                              description.trim().length < 10) {
                            return "La description doit contenir au moins 10 caractères";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Prix (XAF)',
                        hint: 'Ex: 150000 (optionnel)',
                        keyboardType: TextInputType.number,
                        controller: annonceController.priceController,
                        prefixText: 'XAF',
                        validator: (val) {
                          // Prix est optionnel selon l'API
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
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
                                'Localisation et catégorie',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Où se trouve votre article et dans quelle catégorie ?',
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
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: annonceController.villeController,
                      onTap: () {
                        annonceController.getCities();
                        _showLocationPicker();
                      },
                      label: 'Ville',
                      hint: 'Sélectionnez votre ville',
                      validator: (ville) {
                        if (ville == null || ville.isEmpty) {
                          return "Veuillez sélectionner une ville";
                        }
                        return null;
                      },
                      suffixIcon: GestureDetector(
                        onTap: _geoLocate,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.my_location_rounded,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                        ),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Quartier',
                      hint: 'Ex: Bonapriso, Akwa, Bonanjo...',
                      controller: quarterController,
                      validator: (quartier) {
                        if (quartier?.trim().isEmpty ?? true) {
                          return "Le quartier est requis";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Catégorie',
                      hint: 'Sélectionnez une catégorie',
                      controller: _categorieController,
                      validator: (val) {
                        if (annonceController.selectedCategorie == null) {
                          return "Veuillez sélectionner une catégorie";
                        }
                        return null;
                      },
                      onTap: () {
                        categorieController.getCategories();
                        _showCategoriesPicker();
                      },
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.photo_camera_rounded,
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
                                'Photos de votre annonce',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ajoutez des photos pour attirer plus d\'acheteurs',
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
                    const SizedBox(height: 24),
                    _buildImagePicker(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              if (_currentStep > 0) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: _previousStep,
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
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Précédent',
                            style: TextStyle(
                              color: Colors.white,
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
              ],
              Expanded(
                flex: _currentStep == 0 ? 1 : 1,
                child: _currentStep < 2
                    ? GestureDetector(
                        onTap: () {
                          if (_validateCurrentStep()) {
                            _nextStep();
                          } else {
                            HapticFeedback.heavyImpact();
                            VAppAlert.showErrorSnackBar(
                              message: _getValidationMessage(),
                              context: context,
                            );
                          }
                        },
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
                                color: AppTheme.primaryGreen
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continuer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ValueListenableBuilder(
                        valueListenable: annonceController.annonceState,
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: _isSubmitting
                                ? null
                                : () async {
                                    if (_validateCurrentStep()) {
                                      setState(() => _isSubmitting = true);
                                      HapticFeedback.mediumImpact();

                                      await annonceController.createAnnonce(
                                        context,
                                        images: _images,
                                        quartier: quarterController.text,
                                      );

                                      setState(() => _isSubmitting = false);
                                    } else {
                                      HapticFeedback.heavyImpact();
                                      VAppAlert.showErrorSnackBar(
                                        message:
                                            "Veuillez ajouter au moins une photo",
                                        context: context,
                                      );
                                    }
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryGreen,
                                    AppTheme.primaryGreen
                                        .withValues(alpha: 0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen
                                        .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (value.isLoading || _isSubmitting) ...[
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  Text(
                                    value.isLoading || _isSubmitting
                                        ? 'Création en cours...'
                                        : 'Créer l\'annonce',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (!value.isLoading && !_isSubmitting) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }

  String _getValidationMessage() {
    switch (_currentStep) {
      case 0:
        if (annonceController.titleController.text.trim().length < 3) {
          return "Le titre doit contenir au moins 3 caractères";
        }
        if (annonceController.descriptionController.text.trim().length < 10) {
          return "La description doit contenir au moins 10 caractères";
        }
        break;
      case 1:
        if (annonceController.villeController.text.isEmpty) {
          return "Veuillez sélectionner une ville";
        }
        if (quarterController.text.trim().isEmpty) {
          return "Le quartier est requis";
        }
        if (annonceController.selectedCategorie == null) {
          return "Veuillez sélectionner une catégorie";
        }
        break;
      case 2:
        if (_images.isEmpty) {
          return "Veuillez ajouter au moins une photo";
        }
        break;
    }
    return "Veuillez remplir tous les champs requis";
  }
}
