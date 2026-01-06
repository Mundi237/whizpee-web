import 'package:country_detector/country_detector.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/modules/annonces/datas/services/api_services.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../core/api_service/auth/auth_api_service.dart';
import '../../../core/api_service/profile/profile_api_service.dart';
import '../../home/home_controller/views/home_view.dart';
import '../auth_utils.dart';
import '../social_login_auth.dart';
import '../waiting_list/views/waiting_list_page.dart';

class ContinueGetDataScreen extends StatefulWidget {
  final SocialUser socialUser;

  const ContinueGetDataScreen({super.key, required this.socialUser});

  @override
  State<ContinueGetDataScreen> createState() => _ContinueGetDataScreenState();
}

class _ContinueGetDataScreenState extends State<ContinueGetDataScreen> {
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthApiService authService = GetIt.I();
  final ProfileApiService profileService = GetIt.I();
  bool _isLoading = false;
  final CountryDetector _countryDetector = CountryDetector();
  static const double _borderRadius = 16.0;

  VPlatformFile? image;

  @override
  initState() {
    super.initState();
    if (widget.socialUser.name != null) {
      nameController.text = widget.socialUser.name!;
    }
    if (widget.socialUser.phone != null) {
      _phoneController.value = PhoneNumber.parse(widget.socialUser.phone!);
    }

    if (widget.socialUser.phone != null) {
      print("user phone number : ${widget.socialUser.phone}");
      _initializeCountryDetection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Back Button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Welcome Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).completeYourProfile,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ).animate().fadeIn().slideX(),
                        const SizedBox(height: 12),
                        Text(
                          S.of(context).pleaseProvideYourNameToContinue,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ).animate().fadeIn().slideX(delay: 200.ms),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Profile Image
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                              image: image != null
                                  ? DecorationImage(
                                      image:
                                          VPlatformImageProvider(source: image!)
                                              .getImageProvider(),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: widget.socialUser.photo == null
                                ? Icon(
                                    PhosphorIcons.user(),
                                    size: 48,
                                    color: colorScheme.onPrimaryContainer,
                                  )
                                : null,
                          ).animate().scale(),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _selectPhoto,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  PhosphorIcons.camera(),
                                  size: 20,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Name Input Field
                    if (widget.socialUser.name == null ||
                        widget.socialUser.name!.isEmpty)
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: S.of(context).name,
                          hintText: S.of(context).enterYourFullName,
                          prefixIcon: Icon(
                            PhosphorIcons.user(),
                            color: colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).pleaseEnterYourName;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        autofocus: true,
                      ).animate().fadeIn().slideX(delay: 400.ms)
                    else if (widget.socialUser.phone == null ||
                        widget.socialUser.phone!.isEmpty)
                      _buildPhoneInput(context)
                          .animate()
                          .fadeIn()
                          .slideX(delay: 400.ms),
                    const SizedBox(height: 48),
                    // Register Button
                    FilledButton(
                      onPressed: _isLoading ? null : () => register(context),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              S.of(context).register,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                    ).animate().fadeIn().slideX(delay: 600.ms),
                    const SizedBox(height: 24),
                    // User Info
                    if (widget.socialUser.email != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIcons.envelope(),
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.socialUser.email!,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideX(delay: 800.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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

  final PhoneController _phoneController = PhoneController();
  bool _isButtonActive = false;
  bool _isCountryDetected = false;
  static const String _defaultCountryCode = "CM";
  // String? _errorMessage;

  /// Handles phone number changes
  void _onPhoneNumberChanged(PhoneNumber phoneNumber) {
    setState(() {
      _isButtonActive = _validatePhoneNumber(phoneNumber);
      // _errorMessage = null;
    });
  }

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

  bool _validatePhoneNumber(PhoneNumber phoneNumber) {
    return phoneNumber.isValid() && phoneNumber.nsn.isNotEmpty;
  }

  Future<void> register(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await vSafeApiCall<SMyProfile>(
      onLoading: () async {
        // Loading state is handled by the button
      },
      onError: (exception, trace) {
        setState(() => _isLoading = false);
        final errEnum = EnumToString.fromString(
          ApiI18nErrorRes.values,
          exception.toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AuthTrUtils.tr(errEnum) ?? exception.toString(),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      request: () async {
        final deviceHelper = DeviceInfoHelper();
        await authService.register(RegisterDto(
          email: widget.socialUser.email,
          method: widget.socialUser.type,
          authId: widget.socialUser.authId,
          identifier: widget.socialUser.identifier,
          phone: _phoneController.value.international,
          // phone: widget.socialUser.authId,
          image: image,
          fullName: nameController.text,
          pushKey: await (await VChatController
                  .I.vChatConfig.currentPushProviderService)
              ?.getToken(VPlatforms.isWeb ? SConstants.webVapidKey : null),
          deviceInfo: await deviceHelper.getDeviceMapInfo(),
          deviceId: await deviceHelper.getId(),
          language: VLanguageListener.I.appLocal.languageCode,
          platform: VPlatforms.currentPlatform,
        ));
        return profileService.getMyProfile();
      },
      onSuccess: (response) async {
        setState(() => _isLoading = false);
        final status = response.registerStatus;
        await VAppPref.setMap(SStorageKeys.myProfile.name, response.toMap());

        if (status == RegisterStatus.accepted) {
          await VAppPref.setBool(SStorageKeys.isLogin.name, true);
          refreshToken();
          _homeNav(context);
        } else {
          context.toPage(
            WaitingListPage(profile: response),
            withAnimation: true,
            removeAll: true,
          );
        }
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  void _homeNav(BuildContext context) {
    context.toPage(
      const HomeView(),
      withAnimation: true,
      removeAll: true,
    );
  }

  void _selectPhoto() async {
    final image = await VAppPick.getCroppedImage(context: context);
    if (image == null) return;
    this.image = image;
    setState(() {});
  }
}
