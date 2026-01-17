import 'package:flutter/foundation.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/credit_balance.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/credit_purchase.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/credit_transaction.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/pricing.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/transaction_stats.dart';
import 'package:super_up/app/modules/annonces/datas/services/credits/credit_api_service.dart';

class WalletProvider extends ChangeNotifier {
  final CreditApiService _creditApiService;

  WalletProvider(this._creditApiService);

  final balance = ValueNotifier<AppState<CreditBalance>>(AppState());
  final pricing = ValueNotifier<AppState<Pricing>>(AppState());
  final packages = ValueNotifier<AppState<List<CreditPackage>>>(AppState());
  final transactions =
      ValueNotifier<AppState<List<CreditTransaction>>>(AppState());
  final purchases = ValueNotifier<AppState<List<CreditPurchase>>>(AppState());
  final stats = ValueNotifier<AppState<TransactionStats>>(AppState());
  final currentPurchase = ValueNotifier<AppState<CreditPurchase>>(AppState());

  int _currentTransactionSkip = 0;
  bool _hasMoreTransactions = true;
  bool get hasMoreTransactions => _hasMoreTransactions;

  Future<void> fetchBalance() async {
    balance.value = AppState.loading();
    try {
      final data = await _creditApiService.getBalance();
      balance.value = AppState.completed(data);
    } catch (e) {
      balance.value = AppState.trash(e);
    }
  }

  Future<void> fetchPricing() async {
    pricing.value = AppState.loading();
    try {
      final data = await _creditApiService.getPricing();
      pricing.value = AppState.completed(data);
    } catch (e) {
      pricing.value = AppState.trash(e);
    }
  }

  Future<void> fetchPackages() async {
    packages.value = AppState.loading();
    try {
      final data = await _creditApiService.getPackages();
      packages.value = AppState.completed(data);
    } catch (e) {
      packages.value = AppState.trash(e);
    }
  }

  Future<void> fetchTransactions({
    String type = 'all',
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (!_hasMoreTransactions) return;
    } else {
      _currentTransactionSkip = 0;
      _hasMoreTransactions = true;
      transactions.value = AppState.loading();
    }

    try {
      final data = await _creditApiService.getTransactions(
        type: type,
        skip: _currentTransactionSkip,
      );

      if (data.isEmpty) {
        _hasMoreTransactions = false;
      } else {
        _currentTransactionSkip += data.length;
      }

      if (loadMore && transactions.value.hasNotNullData) {
        final existing = transactions.value.data!;
        transactions.value = AppState.completed([...existing, ...data]);
      } else {
        transactions.value = AppState.completed(data);
      }
    } catch (e) {
      transactions.value = AppState.trash(e);
    }
  }

  Future<void> fetchTransactionStats() async {
    stats.value = AppState.loading();
    try {
      final data = await _creditApiService.getTransactionStats();
      stats.value = AppState.completed(data);
    } catch (e) {
      stats.value = AppState.trash(e);
    }
  }

  Future<void> fetchPurchases() async {
    purchases.value = AppState.loading();
    try {
      final data = await _creditApiService.getPurchases();
      purchases.value = AppState.completed(data);
    } catch (e) {
      purchases.value = AppState.trash(e);
    }
  }

  Future<CreditPurchase> purchaseByAmount({
    required int amount,
    required String paymentProvider,
    required String phoneNumber,
  }) async {
    currentPurchase.value = AppState.loading();
    try {
      final purchase = await _creditApiService.purchaseByAmount(
        amount: amount,
        paymentProvider: paymentProvider,
        phoneNumber: phoneNumber,
      );
      currentPurchase.value = AppState.completed(purchase);
      await fetchBalance();
      await fetchTransactions();
      return purchase;
    } catch (e) {
      currentPurchase.value = AppState.trash(e);
      rethrow;
    }
  }

  Future<CreditPurchase> purchaseByCredits({
    required int credits,
    required String paymentProvider,
    required String phoneNumber,
  }) async {
    currentPurchase.value = AppState.loading();
    try {
      final purchase = await _creditApiService.purchaseByCredits(
        credits: credits,
        paymentProvider: paymentProvider,
        phoneNumber: phoneNumber,
      );
      currentPurchase.value = AppState.completed(purchase);
      await fetchBalance();
      await fetchTransactions();
      return purchase;
    } catch (e) {
      currentPurchase.value = AppState.trash(e);
      rethrow;
    }
  }

  Future<CreditPurchase> purchaseByPackage({
    required String packageId,
    required String paymentProvider,
    required String phoneNumber,
  }) async {
    currentPurchase.value = AppState.loading();
    try {
      final purchase = await _creditApiService.purchaseByPackage(
        packageId: packageId,
        paymentProvider: paymentProvider,
        phoneNumber: phoneNumber,
      );
      currentPurchase.value = AppState.completed(purchase);
      await fetchBalance();
      await fetchTransactions();
      return purchase;
    } catch (e) {
      currentPurchase.value = AppState.trash(e);
      rethrow;
    }
  }

  @override
  void dispose() {
    balance.dispose();
    pricing.dispose();
    packages.dispose();
    transactions.dispose();
    purchases.dispose();
    stats.dispose();
    currentPurchase.dispose();
    super.dispose();
  }
}
