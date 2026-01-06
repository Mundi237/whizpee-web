import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_admin/src/modules/home/home_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/api_service/api_service.dart';
import 'package:animate_do/animate_do.dart'; // Add this dependency for animations

// Modern color palette with deep gradient blues
const primaryColor = Color(0xFF3A36DB); // Deep blue
const accentColor = Color(0xFF00B8D9); // Bright blue accent
const backgroundColor = Color(0xFFF7F9FC); // Light cool background
const textColor = Color(0xFF2C3E50); // Dark slate for text
const cardColor = Colors.white;
const secondaryColor = Color(0xFF6C63FF); // Purple accent

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordFiled = TextEditingController();
  bool _saveLogin = true;
  bool _obscurePassword = true;
  final vAdminApiService = GetIt.I.get<SAdminApiService>();

  @override
  void initState() {
    super.initState();
    //todo remove this in release version
    _passwordFiled.text = "super-up-strong-password-viewer";
  }

  @override
  void dispose() {
    _passwordFiled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout breakpoints
          bool isNarrowScreen = constraints.maxWidth < 900;

          return Row(
            children: [
              // Left panel - Brand section with illustration
              if (!isNarrowScreen)
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryColor, secondaryColor],
                        stops: const [0.3, 0.9],
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // App logo
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outlined,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                SConstants.appName,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  S.of(context).adminDashboard,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Feature highlights
                              _buildFeatureItem(Icons.security,
                                  S.of(context).secureAdminAccess),
                              _buildFeatureItem(Icons.analytics_outlined,
                                  S.of(context).userAnalytics),
                              _buildFeatureItem(Icons.settings,
                                  S.of(context).systemConfiguration),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Right panel - login form with card design
              Expanded(
                flex: isNarrowScreen ? 12 : 7,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: FadeInRight(
                        duration: const Duration(milliseconds: 800),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 450,
                          ),
                          child: Card(
                            elevation: 15,
                            shadowColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            color: cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Compact header for narrow screens
                                  if (isNarrowScreen)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(
                                                alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Icon(
                                            Icons.chat_bubble_outlined,
                                            size: 50,
                                            color: primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          SConstants.appName,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          S.of(context).adminDashboard,
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              color: secondaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                        const Divider(),
                                        const SizedBox(height: 40),
                                      ],
                                    ),

                                  // Welcome message with modern typography
                                  Column(
                                    crossAxisAlignment: isNarrowScreen
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.of(context).welcomeBack,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        S
                                            .of(context)
                                            .enterCredentialsToAccessDashboard,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 16,
                                            color: textColor.withValues(
                                                alpha: 0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),

                                  // Password field with floating label
                                  Text(
                                    S.of(context).password,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: _passwordFiled,
                                    obscureText: _obscurePassword,
                                    style: TextStyle(fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText:
                                          S.of(context).enterAdminPassword,
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(
                                          Icons.lock_outline,
                                          color: primaryColor,
                                          size: 22,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey.shade600,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                    ),
                                    onFieldSubmitted: (value) => _login(),
                                  ),
                                  const SizedBox(height: 16),

                                  // Remember me checkbox with modern styling
                                  Transform.translate(
                                    offset: const Offset(-12, 0),
                                    child: CheckboxListTile(
                                      title: Text(
                                        S.of(context).saveLogin,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: textColor.withValues(
                                                alpha: 0.8),
                                          ),
                                        ),
                                      ),
                                      value: _saveLogin,
                                      onChanged: (value) {
                                        setState(() {
                                          _saveLogin = value ?? false;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor: primaryColor,
                                      checkColor: Colors.white,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 36),

                                  // Login button with gradient
                                  SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        textStyle: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        elevation: 0,
                                      ).copyWith(
                                        backgroundColor: WidgetStateProperty
                                            .resolveWith<Color>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
                                              return primaryColor.withValues(
                                                  alpha: 0.8);
                                            }
                                            return primaryColor;
                                          },
                                        ),
                                      ),
                                      child: Text(
                                          S.of(context).login.toUpperCase()),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Help text
                                  Center(
                                    child: TextButton.icon(
                                      icon: Icon(Icons.help_outline,
                                          size: 18,
                                          color:
                                              textColor.withValues(alpha: 0.6)),
                                      label: Text(
                                        S.of(context).needHelp,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 14,
                                            color: textColor.withValues(
                                                alpha: 0.6),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Show help dialog or navigate to help page
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to create feature highlight items
  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    await vSafeApiCall<bool>(
      request: () async {
        VAppAlert.showLoading(context: context);
        if (_passwordFiled.text.isEmpty) {
          throw S.of(context).passwordIsRequired;
        }
        await VAppPref.setHashedString(
          SStorageKeys.adminAccessPassword.name,
          _passwordFiled.text,
        );
        if (_passwordFiled.text == "super-up-strong-password-viewer") {
          VAppAlert.showSuccessSnackBar(
            message: S
                .of(context)
                .nowYouLoginAsReadOnlyAdminAllEditYouDoneWillNotAppliedDueToThisIsTestVersion,
            context: context,
            duration: const Duration(seconds: 20),
          );
        }
        return await vAdminApiService.login();
      },
      onSuccess: (response) async {
        if (_saveLogin) {
          await VAppPref.setBool(SStorageKeys.isLogin.name, true);
        } else {
          await VAppPref.setBool(SStorageKeys.isLogin.name, false);
        }
        await VAppPref.setBool(SStorageKeys.isViewer.name, response);
        context.toPage(const HomePage(), withAnimation: true, removeAll: true);
      },
      onError: (exception) {
        Navigator.of(context).pop();
        VAppAlert.showErrorSnackBar(
          context: context,
          message: exception.message,
        );
      },
    );
  }
}
