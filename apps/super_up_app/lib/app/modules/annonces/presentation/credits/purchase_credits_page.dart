import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/core/widgets/app_header_logo.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/pricing.dart';
import 'package:super_up/app/modules/annonces/providers/wallet_provider.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/widgets/phone_number_input.dart';
import 'package:super_up_core/super_up_core.dart';

class PurchaseCreditsPage extends StatefulWidget {
  final PurchaseMode mode;
  final CreditPackage? selectedPackage;

  const PurchaseCreditsPage({
    super.key,
    this.mode = PurchaseMode.byAmount,
    this.selectedPackage,
  });

  @override
  State<PurchaseCreditsPage> createState() => _PurchaseCreditsPageState();
}

enum PurchaseMode { byAmount, byCredits, byPackage }

class _PurchaseCreditsPageState extends State<PurchaseCreditsPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _creditsController = TextEditingController();
  final _phoneController = TextEditingController();
  late AnimationController _floatController;

  String? _selectedProvider;
  PurchaseMode _currentMode = PurchaseMode.byAmount;
  Pricing? _pricing;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    // Retarder le chargement après le build initial pour éviter l'erreur
    // "setState() called during build"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPricing();
    });
  }

  Future<void> _loadPricing() async {
    final walletProvider = GetIt.I<WalletProvider>();
    await walletProvider.fetchPricing();
    if (mounted && walletProvider.pricing.value.hasNotNullData) {
      setState(() {
        _pricing = walletProvider.pricing.value.data;
      });
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _amountController.dispose();
    _creditsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int? get _calculatedCredits {
    if (_pricing == null) return null;
    final amount = int.tryParse(_amountController.text);
    if (amount == null) return null;
    return _pricing!.pricing.creditsFromAmount(amount);
  }

  int? get _calculatedAmount {
    if (_pricing == null) return null;
    final credits = int.tryParse(_creditsController.text);
    if (credits == null) return null;
    return _pricing!.pricing.amountFromCredits(credits);
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = GetIt.I<WalletProvider>();
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
              Form(
                key: _formKey,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Premium Header with AppHeaderLogo
                    SliverToBoxAdapter(
                      child: AppHeaderLogo(
                        icon: Icons.shopping_cart_rounded,
                        title: "Acheter des crédits",
                        actions: const [],
                      ),
                    ),
                    // Form Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            if (widget.selectedPackage != null)
                              _buildPackageCard(widget.selectedPackage!)
                            else ...[
                              _buildModeSwitcher(),
                              const SizedBox(height: 16),
                              if (_currentMode == PurchaseMode.byAmount)
                                _buildAmountInput()
                              else
                                _buildCreditsInput(),
                            ],
                            const SizedBox(height: 16),
                            _buildPhoneSection(),
                            const SizedBox(height: 24),
                            _buildPurchaseButton(walletProvider),
                            const SizedBox(height: 16),
                            _buildPricingInfo(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(CreditPackage package) {
    final hasBonus = package.bonusCredits > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hasBonus
              ? [
                  AppTheme.primaryGreen,
                  AppTheme.primaryGreen.withValues(alpha: 0.8),
                  Colors.purple.shade600.withValues(alpha: 0.8),
                ]
              : [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: hasBonus
              ? AppTheme.primaryGreen.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.15),
        ),
        boxShadow: hasBonus
            ? [
                BoxShadow(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      package.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    if (hasBonus) ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amber.shade400,
                              Colors.amber.shade600
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'BONUS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${package.credits} crédits',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        if (hasBonus) ...[
                          const SizedBox(height: 4),
                          Text(
                            '+ ${package.bonusCredits} bonus',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${package.amount}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                        Text(
                          'FCFA',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildPhoneSection() {
    return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: PhoneNumberInput(
              controller: _phoneController,
              selectedProvider: _selectedProvider,
              onProviderDetected: (provider) {
                if (provider != null && provider != _selectedProvider) {
                  setState(() {
                    _selectedProvider = provider;
                  });
                }
              },
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildPurchaseButton(WalletProvider walletProvider) {
    return ValueListenableBuilder(
      valueListenable: walletProvider.currentPurchase,
      builder: (context, value, child) {
        final isLoading = value.isLoading;
        return Container(
          width: double.infinity,
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    _handlePurchase();
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: isLoading
                    ? LinearGradient(
                        colors: [
                          Colors.grey.withValues(alpha: 0.3),
                          Colors.grey.withValues(alpha: 0.2),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.primaryGreen.withValues(alpha: 0.8),
                        ],
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLoading
                      ? Colors.grey.withValues(alpha: 0.3)
                      : AppTheme.primaryGreen,
                ),
                boxShadow: isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Center(
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Traitement...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Confirmer l\'achat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms);
  }

  Widget _buildModeSwitcher() {
    return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      color: AppTheme.primaryGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mode d\'achat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _currentMode = PurchaseMode.byAmount;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: _currentMode == PurchaseMode.byAmount
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.primaryGreen,
                                      AppTheme.primaryGreen
                                          .withValues(alpha: 0.8),
                                    ],
                                  )
                                : null,
                            color: _currentMode != PurchaseMode.byAmount
                                ? Colors.white.withValues(alpha: 0.1)
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _currentMode == PurchaseMode.byAmount
                                  ? AppTheme.primaryGreen.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                color: _currentMode == PurchaseMode.byAmount
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Par montant',
                                style: TextStyle(
                                  color: _currentMode == PurchaseMode.byAmount
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _currentMode = PurchaseMode.byCredits;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: _currentMode == PurchaseMode.byCredits
                                ? LinearGradient(
                                    colors: [
                                      AppTheme.primaryGreen,
                                      AppTheme.primaryGreen
                                          .withValues(alpha: 0.8),
                                    ],
                                  )
                                : null,
                            color: _currentMode != PurchaseMode.byCredits
                                ? Colors.white.withValues(alpha: 0.1)
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _currentMode == PurchaseMode.byCredits
                                  ? AppTheme.primaryGreen.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.stars_rounded,
                                color: _currentMode == PurchaseMode.byCredits
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Par crédits',
                                style: TextStyle(
                                  color: _currentMode == PurchaseMode.byCredits
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildAmountInput() {
    return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      color: AppTheme.primaryGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Montant à payer',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Montant (FCFA)',
                    labelStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    hintText: 'Ex: 5000',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.payments_rounded,
                      color: AppTheme.primaryGreen,
                    ),
                    suffixText: 'FCFA',
                    suffixStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.primaryGreen,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un montant';
                    }
                    final amount = int.tryParse(value);
                    if (amount == null || amount < 1000) {
                      return 'Montant minimum: 1000 FCFA';
                    }
                    if (amount > (_pricing?.pricing.maxAmount ?? 1000000)) {
                      return 'Montant maximum: ${_pricing?.pricing.maxAmount ?? 1000000} FCFA';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
                if (_calculatedCredits != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGreen.withValues(alpha: 0.15),
                          AppTheme.primaryGreen.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          color: AppTheme.primaryGreen,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Vous recevrez ≈ $_calculatedCredits crédits',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 250.ms);
  }

  Widget _buildCreditsInput() {
    return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: AppTheme.primaryGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Nombre de crédits',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _creditsController,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nombre de crédits',
                    labelStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    hintText: 'Ex: 1000',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.stars_rounded,
                      color: AppTheme.primaryGreen,
                    ),
                    suffixText: 'crédits',
                    suffixStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.primaryGreen,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nombre de crédits';
                    }
                    final credits = int.tryParse(value);
                    if (credits == null || credits < 100) {
                      return 'Minimum: 100 crédits';
                    }
                    if (credits > (_pricing?.pricing.maxCredits ?? 100000)) {
                      return 'Maximum: ${_pricing?.pricing.maxCredits ?? 100000} crédits';
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {}),
                ),
                if (_calculatedAmount != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600.withValues(alpha: 0.15),
                          Colors.blue.shade600.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.shade400.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.payments_rounded,
                          color: Colors.blue.shade400,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Coût estimé: ≈ $_calculatedAmount FCFA',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 250.ms);
  }

  Widget _buildPricingInfo() {
    if (_pricing == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Informations tarifaires',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPricingInfoItem(
                  Icons.swap_horiz_rounded,
                  'Taux de conversion',
                  '1 crédit = ${_pricing!.pricing.conversionRate} FCFA',
                  AppTheme.primaryGreen,
                ),
                const SizedBox(height: 12),
                _buildPricingInfoItem(
                  Icons.keyboard_arrow_down_rounded,
                  'Montant minimum',
                  '${_pricing!.pricing.minAmount} FCFA',
                  Colors.orange.shade400,
                ),
                const SizedBox(height: 12),
                _buildPricingInfoItem(
                  Icons.keyboard_arrow_up_rounded,
                  'Montant maximum',
                  '${_pricing!.pricing.maxAmount} FCFA',
                  Colors.red.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 550.ms);
  }

  Widget _buildPricingInfoItem(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvider == null) {
      VAppAlert.showErrorSnackBar(
        message:
            'Le mode de paiement sera détecté automatiquement selon votre numéro',
        context: context,
      );
      return;
    }

    final walletProvider = GetIt.I<WalletProvider>();
    final phoneNumber = _phoneController.text.trim();

    try {
      if (widget.selectedPackage != null) {
        await walletProvider.purchaseByPackage(
          packageId: widget.selectedPackage!.id,
          paymentProvider: _selectedProvider!,
          phoneNumber: phoneNumber,
        );
      } else if (_currentMode == PurchaseMode.byAmount) {
        final amount = int.parse(_amountController.text);
        await walletProvider.purchaseByAmount(
          amount: amount,
          paymentProvider: _selectedProvider!,
          phoneNumber: phoneNumber,
        );
      } else {
        final credits = int.parse(_creditsController.text);
        await walletProvider.purchaseByCredits(
          credits: credits,
          paymentProvider: _selectedProvider!,
          phoneNumber: phoneNumber,
        );
      }

      if (!mounted) return;

      if (walletProvider.currentPurchase.value.hasNotNullData) {
        VAppAlert.showSuccessSnackBar(
          message:
              'Achat initié avec succès. Veuillez valider sur votre téléphone.',
          context: context,
        );
        Navigator.pop(context);
      } else if (walletProvider.currentPurchase.value.hasError) {
        VAppAlert.showErrorSnackBar(
          message: walletProvider.currentPurchase.value.errorModel?.error ??
              'Erreur lors de l\'achat',
          context: context,
        );
      }
    } catch (e) {
      if (!mounted) return;
      VAppAlert.showErrorSnackBar(
        message: 'Une erreur est survenue: $e',
        context: context,
      );
    }
  }
}
