import 'package:dio/dio.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/credit_balance.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/credit_purchase.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/credit_transaction.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/pricing.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/transaction_stats.dart';

class CreditApiService {
  final Dio dio;

  CreditApiService(this.dio);

  Future<CreditBalance> getBalance() async {
    try {
      final response = await dio.get('/credits/balance');
      return CreditBalance.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Pricing> getPricing() async {
    try {
      final response = await dio.get('/credits/pricing');
      return Pricing.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CreditPackage>> getPackages() async {
    try {
      final response = await dio.get('/credits/packages');
      final packages = (response.data['packages'] as List)
          .map((e) => CreditPackage.fromMap(e))
          .toList();
      return packages;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreditPurchase> purchaseByAmount({
    required int amount,
    required String paymentProvider,
    required String phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dio.post(
        '/credits/purchase',
        data: {
          'amount': amount,
          'paymentProvider': paymentProvider,
          'paymentDirection': 'deposit',
          'phoneNumber': phoneNumber,
          'countryCode': countryCode ?? 'CMR',
        },
      );
      return CreditPurchase.fromMap(response.data['data'] ?? response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreditPurchase> purchaseByCredits({
    required int credits,
    required String paymentProvider,
    required String phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dio.post(
        '/credits/purchase-by-credits',
        data: {
          'credits': credits,
          'paymentProvider': paymentProvider,
          'paymentDirection': 'deposit',
          'phoneNumber': phoneNumber,
          'countryCode': countryCode ?? 'CMR',
        },
      );
      return CreditPurchase.fromMap(response.data['data'] ?? response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreditPurchase> purchaseByPackage({
    required String packageId,
    required String paymentProvider,
    required String phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dio.post(
        '/credits/purchase-by-package',
        data: {
          'packageId': packageId,
          'paymentProvider': paymentProvider,
          'paymentDirection': 'deposit',
          'phoneNumber': phoneNumber,
          'countryCode': countryCode ?? 'CMR',
        },
      );
      return CreditPurchase.fromMap(response.data['data'] ?? response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CreditTransaction>> getTransactions({
    String type = 'all',
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await dio.get(
        '/credits/transactions',
        queryParameters: {
          'type': type,
          'limit': limit,
          'skip': skip,
        },
      );
      final transactions = (response.data['transactions'] as List)
          .map((e) => CreditTransaction.fromMap(e))
          .toList();
      return transactions;
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionStats> getTransactionStats() async {
    try {
      final response = await dio.get('/credits/transactions/stats');
      return TransactionStats.fromMap(response.data['stats'] ?? response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CreditPurchase>> getPurchases({
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await dio.get(
        '/credits/purchases',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );
      final purchases = (response.data['purchases'] as List)
          .map((e) => CreditPurchase.fromMap(e))
          .toList();
      return purchases;
    } catch (e) {
      rethrow;
    }
  }

  Future<CreditPurchase> getPurchaseDetail(String id) async {
    try {
      final response = await dio.get('/credits/purchases/$id');
      return CreditPurchase.fromMap(response.data['purchase'] ?? response.data);
    } catch (e) {
      rethrow;
    }
  }
}
