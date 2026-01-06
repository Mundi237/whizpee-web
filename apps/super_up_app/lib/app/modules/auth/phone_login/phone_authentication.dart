import 'package:country_detector/country_detector.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/core/widgets/s_app_button.dart';
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
  static const double _horizontalPadding = 16.0;
  static const double _logoSize = 120.0;
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
    final theme = AppTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.background,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(8),
              ),
              image: DecorationImage(
                image: AssetImage("assets/loginchat.png"),
                fit: BoxFit.cover,
              ),
            ),
            // child: Container(
            //   height: MediaQuery.sizeOf(context).height * 0.5,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     gradient: RadialGradient(colors: [
            //       Colors.white.withOpacity(0.4),
            //       Colors.white.withOpacity(0.3),
            //       Colors.white.withOpacity(0.2),
            //       Colors.white.withOpacity(0.1),
            //       Colors.black.withOpacity(0.1),
            //       Colors.black.withOpacity(0.2),
            //       Colors.black.withOpacity(0.3),
            //       Colors.black.withOpacity(0.4),
            //     ]),
            //   ),
            //   child: Center(
            //     child: CircleAvatar(
            //       radius: 70,
            //       backgroundImage: AssetImage("assets/logo.jpg"),
            //     ),
            //   ),
            // ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: _horizontalPadding),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      _buildSettingsRow(context),
                      // const SizedBox(height: 39),
                      // _buildHeader(context),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.4,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        // S.of(context).enterYourPhoneNumber,
                        "Login",
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text("Let's start again to chat with friend"),
                      const SizedBox(height: 20),
                      Text(
                        "Phone Number",
                        style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      _buildPhoneInput(context),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _buildErrorMessage(context),
                      ],
                      const SizedBox(height: 35),
                      _buildSubmitButton(context),
                      const SizedBox(height: 15),
                      // OR component
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Divider(
                              color: theme.textSecondary,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            "Or",
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          SizedBox(
                            width: 50,
                            child: Divider(
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      AppButton(
                        text: "Google Sign In",
                        onPressed: _isLoading ? null : _handleGoogleSignIn,
                        disabled: _isLoading || _loadindGoogle,
                        customIconWidget: SvgPicture.string(
                          googleSvgString,
                          height: 24,
                          width: 24,
                        ),
                        type: AppButtonType.outlined,
                        textColor: theme.textPrimary,
                        borderRadius: 16,
                        padding: const EdgeInsets.all(10),
                        elevation: 0,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

  /// Builds the settings row with theme and language options
  Widget _buildSettingsRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Language Selector
        IconButton(
          onPressed: _showLanguageSelector,
          icon: Icon(
            Icons.language,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        // Theme Selector
        IconButton(
          onPressed: _showThemeSelector,
          icon: Icon(
            VThemeListener.I.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
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

  /// Builds the header section with logo and text
  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Logo
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                "assets/logo.jpg",
                height: _logoSize,
                width: _logoSize,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: _logoSize,
                    width: _logoSize,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.phone_android,
                      size: 60,
                      color: colorScheme.onPrimary,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        // Title
        Text(
          S.of(context).enterYourPhoneNumber,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        // Subtitle
        Text(
          S.of(context).weWillSendYouAVerificationCode,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds the phone input field
  Widget _buildPhoneInput(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PhoneFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: S.of(context).phoneNumber,
            labelStyle: TextStyle(color: colorScheme.primary),
            helperText: _isCountryDetected ? null : "Detecting country",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            filled: true,
            fillColor: Colors.transparent,
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
    );
  }

  /// Builds error message widget
  Widget _buildErrorMessage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: colorScheme.onErrorContainer,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton(BuildContext context) {
    return AppButton(
      text: S.of(context).sendVerificationCode,
      onPressed: _isButtonActive && !_isLoading ? _handleSubmit : null,
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
