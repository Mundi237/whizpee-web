import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/pricing.dart';
import 'package:super_up/app/modules/annonces/providers/wallet_provider.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/widgets/payment_method_selector.dart';
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

class _PurchaseCreditsPageState extends State<PurchaseCreditsPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _creditsController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedProvider;
  PurchaseMode _currentMode = PurchaseMode.byAmount;
  Pricing? _pricing;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.mode;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acheter des crédits'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.selectedPackage != null)
              _buildPackageCard(widget.selectedPackage!)
            else ...[
              _buildModeSwitcher(),
              const SizedBox(height: 20),
              if (_currentMode == PurchaseMode.byAmount)
                _buildAmountInput()
              else
                _buildCreditsInput(),
            ],
            const SizedBox(height: 20),
            PaymentMethodSelector(
              selectedProvider: _selectedProvider,
              onProviderSelected: (provider) {
                setState(() {
                  _selectedProvider = provider;
                });
              },
            ),
            const SizedBox(height: 20),
            PhoneNumberInput(
              controller: _phoneController,
              selectedProvider: _selectedProvider,
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder(
              valueListenable: walletProvider.currentPurchase,
              builder: (context, value, child) {
                final isLoading = value.isLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : _handlePurchase,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Confirmer l\'achat',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildPricingInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(CreditPackage package) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${package.credits} crédits',
                      style: const TextStyle(fontSize: 18),
                    ),
                    if (package.bonusCredits > 0)
                      Text(
                        '+ ${package.bonusCredits} bonus',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                Text(
                  '${package.amount} FCFA',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSwitcher() {
    return SegmentedButton<PurchaseMode>(
      segments: const [
        ButtonSegment(
          value: PurchaseMode.byAmount,
          label: Text('Par montant'),
          icon: Icon(Icons.attach_money),
        ),
        ButtonSegment(
          value: PurchaseMode.byCredits,
          label: Text('Par crédits'),
          icon: Icon(Icons.stars),
        ),
      ],
      selected: {_currentMode},
      onSelectionChanged: (Set<PurchaseMode> newSelection) {
        setState(() {
          _currentMode = newSelection.first;
        });
      },
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Montant (FCFA)',
            hintText: 'Entrez le montant',
            prefixIcon: const Icon(Icons.attach_money),
            suffixText: 'FCFA',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 8),
          Text(
            '≈ $_calculatedCredits crédits',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCreditsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _creditsController,
          decoration: InputDecoration(
            labelText: 'Nombre de crédits',
            hintText: 'Entrez le nombre de crédits',
            prefixIcon: const Icon(Icons.stars),
            suffixText: 'crédits',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 8),
          Text(
            '≈ $_calculatedAmount FCFA',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPricingInfo() {
    if (_pricing == null) return const SizedBox.shrink();

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations tarifaires',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text('Taux: 1 crédit = ${_pricing!.pricing.conversionRate} FCFA'),
            Text('Montant min: ${_pricing!.pricing.minAmount} FCFA'),
            Text('Montant max: ${_pricing!.pricing.maxAmount} FCFA'),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvider == null) {
      VAppAlert.showErrorSnackBar(
        message: 'Veuillez sélectionner un mode de paiement',
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
