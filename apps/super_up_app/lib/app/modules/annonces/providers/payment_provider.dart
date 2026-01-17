import 'package:flutter/foundation.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/payment_transaction.dart';
import 'package:super_up/app/modules/annonces/datas/services/credits/payment_api_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentApiService _paymentApiService;

  PaymentProvider(this._paymentApiService);

  final currentTransaction =
      ValueNotifier<AppState<PaymentTransaction>>(AppState());

  Future<PaymentTransaction> withdrawalOrange({
    required int amount,
    required String phoneNumber,
  }) async {
    currentTransaction.value = AppState.loading();
    try {
      final result = await _paymentApiService.withdraw(
        amount: amount,
        phoneNumber: phoneNumber,
        paymentProvider: 'orange',
      );
      final transaction = PaymentTransaction.fromMap(result);
      currentTransaction.value = AppState.completed(transaction);
      return transaction;
    } catch (e) {
      currentTransaction.value = AppState.trash(e);
      rethrow;
    }
  }

  Future<PaymentTransaction> withdrawalMtn({
    required int amount,
    required String phoneNumber,
  }) async {
    currentTransaction.value = AppState.loading();
    try {
      final result = await _paymentApiService.withdraw(
        amount: amount,
        phoneNumber: phoneNumber,
        paymentProvider: 'mtn',
      );
      final transaction = PaymentTransaction.fromMap(result);
      currentTransaction.value = AppState.completed(transaction);
      return transaction;
    } catch (e) {
      currentTransaction.value = AppState.trash(e);
      rethrow;
    }
  }

  @override
  void dispose() {
    currentTransaction.dispose();
    super.dispose();
  }
}
