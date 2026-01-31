import 'dart:ui';
import 'package:country_detector/country_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home/mobile/settings_tab/views/sheet_for_choose_language.dart';
import '../social_login_auth.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({super.key});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication>
    with SingleTickerProviderStateMixin {
  // Constants
  static const double _borderRadius = 20.0;
  static const String _defaultCountryCode = "CM";

  // Controllers and instances
  final CountryDetector _countryDetector = CountryDetector();
  final PhoneController _phoneController = PhoneController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _floatController;

  // State variables
  bool _isButtonActive = false;
  bool _isLoading = false;
  bool _isCountryDetected = false;
  String? _errorMessage;
  bool _isButtonHovered = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    _initializeCountryDetection();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                top: -70,
                right: -70,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 220 + (25 * _floatController.value),
                      height: 220 + (25 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGreen.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -90,
                left: -90,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 250 - (25 * _floatController.value),
                      height: 250 - (25 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Main content
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    // Web/Tablet Layout (Split View)
                    return Column(
                      children: [
                        _buildTopBar(context),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 64, vertical: 48),
                            child: Form(
                              key: _formKey,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left Column: Header Info
                                  Expanded(
                                    flex: 1,
                                    child:
                                        _buildHeaderCard(context, isWeb: true),
                                  ),
                                  const SizedBox(width: 80),
                                  // Right Column: Input Form
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        _buildPhoneInput(context)
                                            .animate()
                                            .fadeIn(
                                                duration: 600.ms, delay: 700.ms)
                                            .slideY(begin: 0.2, end: 0),
                                        if (_errorMessage != null) ...[
                                          const SizedBox(height: 16),
                                          _buildErrorMessage(context)
                                              .animate()
                                              .fadeIn(duration: 300.ms)
                                              .shake(),
                                        ],
                                        const SizedBox(height: 32),
                                        _buildSubmitButton(context)
                                            .animate()
                                            .fadeIn(
                                                duration: 600.ms, delay: 900.ms)
                                            .slideY(begin: 0.2, end: 0),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Mobile Layout
                    return Column(
                      children: [
                        _buildTopBar(context),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: size.height * 0.05),
                                  _buildHeaderCard(context, isWeb: false),
                                  const SizedBox(height: 40),
                                  _buildPhoneInput(context)
                                      .animate()
                                      .fadeIn(duration: 600.ms, delay: 700.ms)
                                      .slideY(begin: 0.2, end: 0),
                                  if (_errorMessage != null) ...[
                                    const SizedBox(height: 16),
                                    _buildErrorMessage(context)
                                        .animate()
                                        .fadeIn(duration: 300.ms)
                                        .shake(),
                                  ],
                                  const SizedBox(height: 32),
                                  _buildSubmitButton(context)
                                      .animate()
                                      .fadeIn(duration: 600.ms, delay: 900.ms)
                                      .slideY(begin: 0.2, end: 0),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      context.pop();
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.12),
                            Colors.white.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _showLanguageSelector,
                      icon: Icon(
                        Icons.language_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    IconButton(
                      onPressed: _showThemeSelector,
                      icon: Icon(
                        VThemeListener.I.isDarkMode
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3, end: 0),
    );
  }

  Widget _buildHeaderCard(BuildContext context, {required bool isWeb}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
            mainAxisSize: isWeb ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGreen.withValues(alpha: 0.3),
                      AppTheme.primaryGreen.withValues(alpha: 0.15),
                    ],
                  ),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.phone_android_rounded,
                  size: 32,
                  color: AppTheme.primaryGreen,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 20),
              Text(
                "Vérification du numéro",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                "Entrez votre numéro de téléphone pour recevoir un code de confirmation.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.75),
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 500.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  bool _loadindGoogle = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _loadindGoogle = true;
    });
    await SocialLoginAuth.loginByGoogle(context);
    setState(() {
      _loadindGoogle = false;
    });
  }

  /// Shows language selection bottom sheet
  void _showLanguageSelector() async {
    final res = await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SheetForChooseLanguage(),
    ) as ModelSheetItem?;
    if (res == null) {
      return;
    }

    await VLanguageListener.I.setLocal(Locale(res.id.toString()));
    await VAppPref.setStringKey(
      SStorageKeys.appLanguageTitle.name,
      res.title,
    );
  }

  /// Shows theme selection bottom sheet
  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildThemeBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  /// Builds language selection bottom sheet
  Widget _buildLanguageBottomSheet() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildLanguageOption('English', 'en', Icons.language),
          _buildLanguageOption('العربية', 'ar', Icons.language),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Builds theme selection bottom sheet
  Widget _buildThemeBottomSheet() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "selectTheme",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildThemeOption("lightTheme", ThemeMode.light, Icons.light_mode),
          _buildThemeOption("darkTheme", ThemeMode.dark, Icons.dark_mode),
          _buildThemeOption("systemTheme", ThemeMode.system, Icons.auto_mode),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Builds language option tile
  Widget _buildLanguageOption(String title, String langCode, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = VLanguageListener.I.appLocal.languageCode == langCode;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title),
      trailing:
          isSelected ? Icon(Icons.check, color: colorScheme.primary) : null,
      onTap: () {
        VLanguageListener.I.setLocal(Locale(langCode));
        Navigator.pop(context);
      },
    );
  }

  /// Builds theme option tile
  Widget _buildThemeOption(String title, ThemeMode themeMode, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = VThemeListener.I.appTheme == themeMode;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title),
      trailing:
          isSelected ? Icon(Icons.check, color: colorScheme.primary) : null,
      onTap: () {
        VThemeListener.I.setTheme(themeMode);
        Navigator.pop(context);
      },
    );
  }

  /// Builds the phone input field
  Widget _buildPhoneInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: PhoneFormField(
              controller: _phoneController,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Numéro de téléphone",
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 16,
                ),
                helperText: _isCountryDetected ? null : "Détection du pays...",
                helperStyle: TextStyle(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  borderSide: BorderSide(
                    color: AppTheme.primaryGreen,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  borderSide: BorderSide(
                    color: Colors.red.shade400,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  borderSide: BorderSide(
                    color: Colors.red.shade400,
                    width: 2,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              ),
              validator: PhoneValidator.compose([
                PhoneValidator.required(context),
                PhoneValidator.validMobile(context),
              ]),
              countrySelectorNavigator:
                  const CountrySelectorNavigator.draggableBottomSheet(),
              onChanged: _onPhoneNumberChanged,
              autofocus: true,
              countryButtonStyle: const CountryButtonStyle(
                showDialCode: true,
                showIsoCode: false,
                showFlag: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds error message widget
  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade900.withValues(alpha: 0.4),
            Colors.red.shade900.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.shade400.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade400.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.error_rounded,
                  color: Colors.red.shade200,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red.shade50,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton(BuildContext context) {
    final bool isEnabled = _isButtonActive && !_isLoading;

    return GestureDetector(
      onTapDown: (_) {
        if (isEnabled) {
          HapticFeedback.lightImpact();
          setState(() => _isButtonHovered = true);
        }
      },
      onTapUp: (_) {
        if (isEnabled) {
          setState(() => _isButtonHovered = false);
          HapticFeedback.mediumImpact();
          _handleSubmit();
        }
      },
      onTapCancel: () {
        setState(() => _isButtonHovered = false);
      },
      child: AnimatedScale(
        scale: _isButtonHovered && isEnabled ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: BoxDecoration(
            gradient: isEnabled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryGreen,
                      AppTheme.primaryGreen.withValues(alpha: 0.85),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.5),
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.25),
                      blurRadius: 12,
                      spreadRadius: -2,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Envoyer le code",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Initializes country detection
  Future<void> _initializeCountryDetection() async {
    try {
      // Gets country code in priority: SIM -> Network -> Locale
      final countryCode = await _countryDetector.isoCountryCode();

      if (mounted) {
        _phoneController.changeCountry(
          IsoCode.fromJson(countryCode ?? _defaultCountryCode),
        );
        setState(() {
          _isCountryDetected = true;
        });
      }
    } catch (error) {
      // Fallback to default country
      if (mounted) {
        _phoneController.changeCountry(IsoCode.fromJson(_defaultCountryCode));
        setState(() {
          _isCountryDetected = true;
        });
      }

      // Log error for debugging
      debugPrint('Country detection failed: $error');
    }
  }

  /// Handles phone number changes
  void _onPhoneNumberChanged(PhoneNumber phoneNumber) {
    setState(() {
      _isButtonActive = _validatePhoneNumber(phoneNumber);
      _errorMessage = null; // Clear error when user types
    });
  }

  /// Validates phone number
  bool _validatePhoneNumber(PhoneNumber phoneNumber) {
    return phoneNumber.isValid() && phoneNumber.nsn.isNotEmpty;
  }

  /// Handles form submission
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final phone = _phoneController.value;
      final countryCode = "+${phone.countryCode}";
      final completeNumber = "$countryCode${phone.nsn}";

      // Validate one more time before submission
      if (!_validatePhoneNumber(phone)) {
        throw Exception("invalid Phone Number");
      }

      // Perform phone sign in
      await SocialLoginAuth.phoneSignIn(completeNumber);

      // Save phone preferences
      await _savePhonePreferences(countryCode, phone.isoCode.name);

      // Success - navigation should be handled by SocialLoginAuth
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = _getErrorMessage(error);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Saves phone preferences to storage
  Future<void> _savePhonePreferences(String countryCode, String isoCode) async {
    await Future.wait([
      VAppPref.setStringKey(SStorageKeys.phoneCountryKey.name, countryCode),
      VAppPref.setStringKey(SStorageKeys.countryCode.name, isoCode),
    ]);
  }

  /// Gets user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network')) {
      return S.of(context).networkError;
    } else if (error.toString().contains('invalid')) {
      return "invalid phone number";
    } else {
      return "somethingWentWrong";
    }
  }
}

const googleSvgString =
    '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 48 48"><path fill="#ffc107" d="M43.611 20.083H42V20H24v8h11.303c-1.649 4.657-6.08 8-11.303 8c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C12.955 4 4 12.955 4 24s8.955 20 20 20s20-8.955 20-20c0-1.341-.138-2.65-.389-3.917" stroke-width="1" stroke="#ffc107"/><path fill="#ff3d00" d="m6.306 14.691l6.571 4.819C14.655 15.108 18.961 12 24 12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C16.318 4 9.656 8.337 6.306 14.691" stroke-width="1" stroke="#ff3d00"/><path fill="#4caf50" d="M24 44c5.166 0 9.86-1.977 13.409-5.192l-6.19-5.238A11.9 11.9 0 0 1 24 36c-5.202 0-9.619-3.317-11.283-7.946l-6.522 5.025C9.505 39.556 16.227 44 24 44" stroke-width="1" stroke="#4caf50"/><path fill="#1976d2" d="M43.611 20.083H42V20H24v8h11.303a12.04 12.04 0 0 1-4.087 5.571l.003-.002l6.19 5.238C36.971 39.205 44 34 44 24c0-1.341-.138-2.65-.389-3.917" stroke-width="1" stroke="#1976d2"/></svg>';
