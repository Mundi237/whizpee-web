import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_up_core/super_up_core.dart';

class EmailLoginView extends StatefulWidget {
  const EmailLoginView({super.key});

  @override
  State<EmailLoginView> createState() => _EmailLoginViewState();
}

class _EmailLoginViewState extends State<EmailLoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = VThemeListener.I.isDarkMode;
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
              // Top bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
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
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Title
                        Text(
                          "Connexion par e-mail",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 200.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 12),

                        Text(
                          "Entrez vos identifiants pour accéder à votre compte",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .slideY(begin: 0.3, end: 0),

                        SizedBox(height: size.height * 0.06),

                        // Email field
                        _buildInputLabel("Adresse e-mail", delay: 600),
                        const SizedBox(height: 12),
                        _buildEmailField()
                            .animate()
                            .fadeIn(
                              duration: 600.ms,
                              delay: 700.ms,
                            )
                            .slideX(begin: -0.2, end: 0),

                        const SizedBox(height: 24),

                        // Password field
                        _buildInputLabel("Mot de passe", delay: 900),
                        const SizedBox(height: 12),
                        _buildPasswordField()
                            .animate()
                            .fadeIn(
                              duration: 600.ms,
                              delay: 1000.ms,
                            )
                            .slideX(begin: -0.2, end: 0),

                        const SizedBox(height: 16),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              // TODO: Implement forgot password
                            },
                            child: Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(
                                color: AppTheme.primaryGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),

                        const SizedBox(height: 32),

                        // Login button
                        _buildLoginButton()
                            .animate()
                            .fadeIn(
                              duration: 600.ms,
                              delay: 1400.ms,
                            )
                            .scale(
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1.0, 1.0),
                            ),

                        const SizedBox(height: 24),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Vous n'avez pas de compte ? ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                // TODO: Navigate to sign up
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Créer un compte",
                                style: TextStyle(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 600.ms, delay: 1600.ms),

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

  Widget _buildInputLabel(String label, {required int delay}) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.9),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: delay.ms);
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: Colors.white, fontSize: 16),
      onChanged: (value) {
        setState(() {
          _isEmailValid = _validateEmail(value);
        });
      },
      decoration: InputDecoration(
        hintText: "votre.email@exemple.com",
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 16,
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: _isEmailValid
              ? AppTheme.primaryGreen
              : Colors.white.withValues(alpha: 0.5),
        ),
        suffixIcon: _emailController.text.isNotEmpty
            ? Icon(
                _isEmailValid ? Icons.check_circle : Icons.cancel,
                color:
                    _isEmailValid ? AppTheme.primaryGreen : Colors.red.shade400,
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Veuillez entrer votre adresse e-mail";
        }
        if (!_validateEmail(value)) {
          return "Adresse e-mail invalide";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.done,
      style: TextStyle(color: Colors.white, fontSize: 16),
      onChanged: (value) {
        setState(() {
          _isPasswordValid = value.length >= 6;
        });
      },
      onFieldSubmitted: (_) => _handleLogin(),
      decoration: InputDecoration(
        hintText: "••••••••",
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 16,
        ),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: _isPasswordValid
              ? AppTheme.primaryGreen
              : Colors.white.withValues(alpha: 0.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppTheme.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Veuillez entrer votre mot de passe";
        }
        if (value.length < 6) {
          return "Le mot de passe doit contenir au moins 6 caractères";
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    final bool isEnabled = _isEmailValid && _isPasswordValid && !_isLoading;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _handleLogin : null,
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
                      "Se connecter",
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

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HapticFeedback.mediumImpact();

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual login logic
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      VAppAlert.showSuccessSnackBar(
        message: "Connexion réussie !",
        context: context,
      );
    }
  }
}
