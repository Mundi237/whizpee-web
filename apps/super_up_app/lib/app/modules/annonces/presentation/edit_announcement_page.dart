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
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Categorie, Annonces;
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_platform/v_platform.dart';

class EditAnnouncementPage extends StatefulWidget {
  final Annonces announcement;

  const EditAnnouncementPage({
    super.key,
    required this.announcement,
  });

  @override
  State<EditAnnouncementPage> createState() => _EditAnnouncementPageState();
}

class _EditAnnouncementPageState extends State<EditAnnouncementPage>
    with TickerProviderStateMixin {
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final List<File> _newImages = [];
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

    // Pré-remplir les champs avec les données existantes
    _prefillFields();
  }

  void _prefillFields() {
    annonceController.titleController.text = widget.announcement.title;
    annonceController.descriptionController.text =
        widget.announcement.description;
    annonceController.villeController.text = widget.announcement.ville ?? '';
    quarterController.text = widget.announcement.quartier ?? '';
    annonceController.priceController.text = widget.announcement.price > 0
        ? widget.announcement.price.toString()
        : '';

    // Charger la catégorie si elle existe
    if (widget.announcement.categoryInfo != null) {
      annonceController.selectedCategorie = Categorie(
        id: widget.announcement.categoryInfo!.id,
        name: widget.announcement.categoryInfo!.name,
      );
      _categorieController.text = widget.announcement.categoryInfo!.name;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _progressController.dispose();
    _pageController.dispose();
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
        // Pour l'édition, on accepte si il y a des nouvelles images OU des images existantes
        return _newImages.isNotEmpty ||
            (widget.announcement.images?.isNotEmpty ?? false);
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
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
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
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        );
                      }
                      if (value.hasError || (value.data ?? []).isEmpty) {
                        if ((value.data ?? []).isEmpty) {
                          annonceController.getCities();
                        }
                        return Expanded(
                          child: Center(
                            child: Text(
                              'Chargement...',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: ValueListenableBuilder<List<City>>(
                          valueListenable: annonceController.villes,
                          builder: (context, cities, child) {
                            return ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: cities.length,
                              itemBuilder: (context, index) {
                                final city = cities[index];
                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      annonceController.villeController.text =
                                          city.name;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.1),
                                          Colors.white.withValues(alpha: 0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            Colors.white.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_city_rounded,
                                          color: AppTheme.primaryGreen,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          city.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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

  void _showCategoriePicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
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
                  const SizedBox(height: 10),
                  ValueListenableBuilder<AppState<List<Categorie>>>(
                    valueListenable: categorieController.categoriesState,
                    builder: (context, value, child) {
                      if (value.isLoading) {
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        );
                      }
                      if (value.hasError || (value.data ?? []).isEmpty) {
                        if ((value.data ?? []).isEmpty) {
                          categorieController.getCategories();
                        }
                        return Expanded(
                          child: Center(
                            child: Text(
                              'Chargement...',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        );
                      }

                      final categories = value.data!;
                      return Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected =
                                annonceController.selectedCategorie?.id ==
                                    category.id;

                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  annonceController.selectedCategorie =
                                      category;
                                  _categorieController.text = category.name;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isSelected
                                        ? [
                                            AppTheme.primaryGreen
                                                .withValues(alpha: 0.3),
                                            AppTheme.primaryGreen
                                                .withValues(alpha: 0.1),
                                          ]
                                        : [
                                            Colors.white.withValues(alpha: 0.1),
                                            Colors.white
                                                .withValues(alpha: 0.05),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryGreen
                                        : Colors.white.withValues(alpha: 0.1),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category_rounded,
                                      color: isSelected
                                          ? AppTheme.primaryGreen
                                          : Colors.white.withValues(alpha: 0.6),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppTheme.primaryGreen
                                            : Colors.white,
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
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
              // Animated background circles
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
                  _buildHeader(),
                  _buildProgressIndicator(),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStep1(),
                        _buildStep2(),
                        _buildStep3(),
                      ],
                    ),
                  ),
                  _buildNavigationButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
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
                Icons.arrow_back_rounded,
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
                  'Modifier l\'annonce',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Étape ${_currentStep + 1} sur 3',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(
                gradient: index <= _currentStep
                    ? LinearGradient(
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.primaryGreen.withValues(alpha: 0.7),
                        ],
                      )
                    : null,
                color: index > _currentStep
                    ? Colors.white.withValues(alpha: 0.1)
                    : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations générales',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: annonceController.titleController,
            label: 'Titre de l\'annonce',
            hint: 'Ex: iPhone 13 Pro Max',
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: annonceController.descriptionController,
            label: 'Description',
            hint: 'Décrivez votre annonce en détail...',
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          // CustomTextField(
          //   controller: annonceController.priceController,
          //   label: 'Prix (optionnel)',
          //   hint: 'Ex: 500000',
          //   keyboardType: TextInputType.number,
          // ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Localisation et catégorie',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _showLocationPicker,
            child: AbsorbPointer(
              child: CustomTextField(
                controller: annonceController.villeController,
                label: 'Ville',
                hint: 'Sélectionner une ville',
                readOnly: true,
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: quarterController,
            label: 'Quartier',
            hint: 'Ex: Bastos',
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showCategoriePicker,
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _categorieController,
                label: 'Catégorie',
                hint: 'Sélectionner une catégorie',
                readOnly: true,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photos',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez de nouvelles photos (les anciennes seront conservées)',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          // Afficher les images existantes
          if (widget.announcement.images?.isNotEmpty ?? false) ...[
            Text(
              'Images actuelles (${widget.announcement.images!.length})',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.announcement.images!.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.announcement.images![index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
          // Nouvelles images
          if (_newImages.isNotEmpty) ...[
            Text(
              'Nouvelles images (${_newImages.length})',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ..._newImages.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _newImages.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
              // Bouton ajouter image
              GestureDetector(
                onTap: () async {
                  final media = await pickImage(false);
                  if (media != null) {
                    final file = vBaseMediaResToFile(media);
                    if (file != null) {
                      setState(() {
                        _newImages.add(file);
                      });
                    }
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryGreen.withValues(alpha: 0.2),
                        AppTheme.primaryGreen.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        color: AppTheme.primaryGreen,
                        size: 32,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ajouter',
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFF0D0D0D),
            const Color(0xFF0D0D0D).withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: GestureDetector(
                onTap: _previousStep,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
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
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Précédent',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
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
                            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Suivant',
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

                                  try {
                                    await annonceController.updateAnnonce(
                                      context,
                                      annonceId: widget.announcement.id,
                                      title: annonceController
                                                  .titleController.text
                                                  .trim() !=
                                              widget.announcement.title
                                          ? annonceController
                                              .titleController.text
                                              .trim()
                                          : null,
                                      description: annonceController
                                                  .descriptionController.text
                                                  .trim() !=
                                              widget.announcement.description
                                          ? annonceController
                                              .descriptionController.text
                                              .trim()
                                          : null,
                                      categorieId: annonceController
                                                  .selectedCategorie?.id
                                                  .toString() !=
                                              widget
                                                  .announcement.categoryInfo?.id
                                          ? annonceController
                                              .selectedCategorie?.id
                                              .toString()
                                          : null,
                                      newImages: _newImages.isNotEmpty
                                          ? _newImages
                                          : null,
                                      // price: null,
                                    );

                                    if (mounted) {
                                      setState(() => _isSubmitting = false);
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() => _isSubmitting = false);
                                    }
                                  }
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (value.isLoading || _isSubmitting) ...[
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  value.isLoading || _isSubmitting
                                      ? 'Modification...'
                                      : 'Modifier l\'annonce',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!value.isLoading && !_isSubmitting) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 16,
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
        if (_newImages.isEmpty &&
            (widget.announcement.images?.isEmpty ?? true)) {
          return "Veuillez ajouter au moins une photo";
        }
        break;
    }
    return "Veuillez remplir tous les champs requis";
  }
}
