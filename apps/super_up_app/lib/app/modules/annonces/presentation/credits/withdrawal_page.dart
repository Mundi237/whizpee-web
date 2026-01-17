import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up/app/modules/annonces/providers/payment_provider.dart';
import 'package:super_up/app/modules/annonces/providers/wallet_provider.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/widgets/payment_method_selector.dart';
import 'package:super_up/app/modules/annonces/presentation/credits/widgets/phone_number_input.dart';
import 'package:super_up_core/super_up_core.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedProvider;

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = GetIt.I<PaymentProvider>();
    final walletProvider = GetIt.I<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrait d\'argent'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBalanceCard(walletProvider),
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildAmountInput(),
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
              valueListenable: paymentProvider.currentTransaction,
              builder: (context, value, child) {
                final isLoading = value.isLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : _handleWithdrawal,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red[700],
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Effectuer le retrait',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletProvider walletProvider) {
    return ValueListenableBuilder(
      valueListenable: walletProvider.balance,
      builder: (context, value, child) {
        final credits = value.data?.credits ?? 0;
        final amount = credits * 10;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solde disponible',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$credits crédits',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '≈ $amount FCFA',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => walletProvider.fetchBalance(),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange[700]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Les retraits sont traités sous 24-48h. Des frais peuvent s\'appliquer.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Montant à retirer (FCFA)',
        hintText: 'Entrez le montant',
        prefixIcon: const Icon(Icons.attach_money),
        suffixText: 'FCFA',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        helperText: 'Montant minimum: 1000 FCFA',
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

        final walletProvider = GetIt.I<WalletProvider>();
        final availableAmount =
            (walletProvider.balance.value.data?.credits ?? 0) * 10;
        if (amount > availableAmount) {
          return 'Solde insuffisant';
        }

        return null;
      },
    );
  }

  Future<void> _handleWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProvider == null) {
      VAppAlert.showErrorSnackBar(
        message: 'Veuillez sélectionner un mode de paiement',
        context: context,
      );
      return;
    }

    final confirmed = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: 'Confirmer le retrait',
      content:
          'Êtes-vous sûr de vouloir retirer ${_amountController.text} FCFA vers votre compte ${_selectedProvider == 'orange' ? 'Orange Money' : 'MTN MoMo'} ?',
    );

    if (confirmed != 1) return;

    final paymentProvider = GetIt.I<PaymentProvider>();
    final phoneNumber = _phoneController.text.trim();
    final amount = int.parse(_amountController.text);

    try {
      if (_selectedProvider == 'orange') {
        await paymentProvider.withdrawalOrange(
          amount: amount,
          phoneNumber: phoneNumber,
        );
      } else {
        await paymentProvider.withdrawalMtn(
          amount: amount,
          phoneNumber: phoneNumber,
        );
      }

      if (!mounted) return;

      if (paymentProvider.currentTransaction.value.hasNotNullData) {
        VAppAlert.showSuccessSnackBar(
          message: 'Demande de retrait initiée avec succès',
          context: context,
        );

        final walletProvider = GetIt.I<WalletProvider>();
        await walletProvider.fetchBalance();

        Navigator.pop(context);
      } else if (paymentProvider.currentTransaction.value.hasError) {
        VAppAlert.showErrorSnackBar(
          message: paymentProvider.currentTransaction.value.errorModel?.error ??
              'Erreur lors du retrait',
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
