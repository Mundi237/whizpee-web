import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/api_service/story/story_api_service.dart';
import 'package:super_up/app/core/models/story/create_story_dto.dart';
import 'package:super_up/app/core/utils/enums.dart';
import 'package:super_up_core/super_up_core.dart';

class _CreateStoryState {
  Color backgroundColor = const Color(0xFFA68888);
  StoryFontType fontType = StoryFontType.normal;
}

class CreateTextStory extends StatefulWidget {
  const CreateTextStory({super.key});

  @override
  State<CreateTextStory> createState() => _CreateTextStoryState();
}

class _CreateTextStoryState extends State<CreateTextStory>
    with TickerProviderStateMixin {
  final state = _CreateStoryState();
  final random = Random();

  final _api = GetIt.I.get<StoryApiService>();
  final _txtController = TextEditingController();
  final _focusNode = FocusNode();

  late AnimationController _backgroundController;
  late AnimationController _toolsController;
  bool _isUploading = false;

  final List<Color> _predefinedColors = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF8B5CF6), // Violet
    const Color(0xFFEC4899), // Pink
    const Color(0xFFF59E0B), // Amber
    const Color(0xFF10B981), // Emerald
    const Color(0xFF3B82F6), // Blue
    const Color(0xFFEF4444), // Red
    const Color(0xFF8B5A2B), // Brown
    const Color(0xFF6B7280), // Gray
    const Color(0xFF059669), // Green
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _toolsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _backgroundController.forward();
    _toolsController.forward();

    // Set initial random color
    state.backgroundColor =
        _predefinedColors[random.nextInt(_predefinedColors.length)];
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _txtController.dispose();
    _backgroundController.dispose();
    _toolsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              state.backgroundColor,
              state.backgroundColor.withValues(alpha: 0.8),
              state.backgroundColor.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader().animate().slideY(begin: -1, end: 0).fadeIn(),
              Expanded(
                child: _buildTextEditor()
                    .animate()
                    .scale(begin: const Offset(0.8, 0.8))
                    .fadeIn(delay: 200.ms),
              ),
              _buildBottomControls()
                  .animate()
                  .slideY(begin: 1, end: 0)
                  .fadeIn(delay: 400.ms),
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
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Créer une story',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildToolsRow(),
        ],
      ),
    );
  }

  Widget _buildToolsRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildToolButton(
          icon: Icons.palette_rounded,
          onTap: _showColorPicker,
        ),
        const SizedBox(width: 8),
        _buildToolButton(
          icon: Icons.text_format_rounded,
          onTap: _randomFontType,
        ),
        const SizedBox(width: 8),
        _buildToolButton(
          icon: Icons.shuffle_rounded,
          onTap: _generateRandomColor,
        ),
      ],
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTextEditor() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: TextField(
          controller: _txtController,
          focusNode: _focusNode,
          textAlign: TextAlign.center,
          maxLines: null,
          maxLength: 200,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontStyle: state.fontType == StoryFontType.italic
                ? FontStyle.italic
                : null,
            fontWeight: state.fontType == StoryFontType.bold
                ? FontWeight.bold
                : FontWeight.w500,
            shadows: const [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).createYourStory,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 32,
              fontWeight: FontWeight.w400,
            ),
            counterStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.of(context).shareYourStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Partagez vos pensées avec vos contacts',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _isUploading ? null : uploadTextStory,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
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
                    child: _isUploading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                mainAxisSize: MainAxisSize.min,
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.palette_rounded,
                                color: AppTheme.primaryGreen,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Choisir une couleur',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _predefinedColors.length,
                          itemBuilder: (context, index) {
                            final color = _predefinedColors[index];
                            final isSelected = state.backgroundColor == color;

                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  state.backgroundColor = color;
                                });
                                Navigator.pop(context);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _generateRandomColor() {
    HapticFeedback.mediumImpact();
    final color = _predefinedColors[random.nextInt(_predefinedColors.length)];
    setState(() {
      state.backgroundColor = color;
    });
  }

  void _randomFontType() {
    HapticFeedback.lightImpact();
    state.fontType =
        StoryFontType.values[random.nextInt(StoryFontType.values.length)];
    setState(() {});
  }

  void uploadTextStory() async {
    if (_txtController.text.isEmpty) {
      HapticFeedback.heavyImpact();
      VAppAlert.showErrorSnackBar(
        context: context,
        message: 'Veuillez saisir du texte pour votre story',
      );
      return;
    }

    setState(() => _isUploading = true);
    HapticFeedback.mediumImpact();

    await vSafeApiCall(
      request: () async {
        final dto = CreateStoryDto(
          storyType: StoryType.text,
          content: _txtController.text,
          backgroundColor: state.backgroundColor.toARGB32().toRadixString(16),
          storyFontType: state.fontType,
        );
        return _api.createStory(dto);
      },
      onSuccess: (response) {
        if (mounted) {
          Navigator.of(context).pop();
          VAppAlert.showSuccessSnackBar(
            context: context,
            message: S.of(context).storyCreatedSuccessfully,
          );
        }
      },
      onError: (exception) {
        if (mounted) {
          setState(() => _isUploading = false);
          VAppAlert.showErrorSnackBar(
            context: context,
            message: exception.toString(),
          );
        }
      },
    );
  }
}
