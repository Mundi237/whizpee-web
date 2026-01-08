import 'package:country_detector/country_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  // Constants
  static const double _borderRadius = 16.0;
  static const String _defaultCountryCode = "CM";

  // Controllers and instances
  final CountryDetector _countryDetector = CountryDetector();
  final PhoneController _phoneController = PhoneController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State variables
  bool _isButtonActive = false;
  bool _isLoading = false;
  bool _isCountryDetected = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCountryDetection();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.pop();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
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
                            Icons.language,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        IconButton(
                          onPressed: _showThemeSelector,
                          icon: Icon(
                            VThemeListener.I.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Vérification du numéro",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Entrez votre numéro de téléphone pour recevoir un code de confirmation.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 48),
                        _buildPhoneInput(context),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          _buildErrorMessage(context),
                        ],
                        const SizedBox(height: 32),
                        _buildSubmitButton(context),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withValues(alpha: 0.3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "OU",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withValues(alpha: 0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isLoading || _loadindGoogle
                                ? null
                                : _handleGoogleSignIn,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 24),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_loadindGoogle)
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  else
                                    SvgPicture.string(
                                      googleSvgString,
                                      height: 24,
                                      width: 24,
                                    ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Continuer avec Google",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PhoneFormField(
        controller: _phoneController,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: "Numéro de téléphone",
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 16,
          ),
          helperText: _isCountryDetected ? null : "Détection du pays...",
          helperStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
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
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
    );
  }

  /// Builds error message widget
  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade400.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.red.shade300,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade100,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton(BuildContext context) {
    final bool isEnabled = _isButtonActive && !_isLoading;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _handleSubmit : null,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: isEnabled
                  ? LinearGradient(
                      colors: [
                        AppTheme.primaryGreen,
                        AppTheme.primaryGreen.withValues(alpha: 0.8),
                      ],
                    )
                  : null,
              color: isEnabled ? null : Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Envoyer le code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
