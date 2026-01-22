import 'package:dio/dio.dart';
import 'package:super_up/app/modules/annonces/datas/models/credits/payment_transaction.dart';

class PaymentApiService {
  final Dio dio;

  PaymentApiService(this.dio);

  Future<PaymentTransaction> createTransaction({
    required int subscriptionId,
    required int amount,
    required String phoneNumber,
    required String countryCode,
    String? callbackUrl,
  }) async {
    try {
      final response = await dio.post(
        '/payment/transaction',
        data: {
          'subscription_id': subscriptionId,
          'amount': amount,
          'phone_number': phoneNumber,
          'country_code': countryCode,
          if (callbackUrl != null) 'callback_url': callbackUrl,
        },
      );
      return PaymentTransaction.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentTransaction> verifyTransaction(String payToken) async {
    try {
      final response = await dio.get('/payment/transaction/$payToken');
      return PaymentTransaction.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getBalance() async {
    try {
      final response = await dio.get('/payment/balance');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentTransaction> depositOrange({
    required int amount,
    required String phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dio.post(
        '/payment/deposit/orange',
        data: {
          'amount': amount,
          'phone_number': phoneNumber,
          'country_code': countryCode ?? 'CMR',
        },
      );
      return PaymentTransaction.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentTransaction> depositMtn({
    required int amount,
    required String phoneNumber,
    String? countryCode,
  }) async {
    try {
      final response = await dio.post(
        '/payment/deposit/mtn',
        data: {
          'amount': amount,
          'phone_number': phoneNumber,
          'country_code': countryCode ?? 'CMR',
        },
      );
      return PaymentTransaction.fromMap(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> withdraw({
    required int amount,
    required String phoneNumber,
    required String paymentProvider,
  }) async {
    try {
      final response = await dio.post(
        '/payment/withdrawal/$paymentProvider',
        data: {
          'amount': amount,
          'phoneNumber': phoneNumber,
          'countryCode': 'CMR',
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSubscriptions() async {
    try {
      final response = await dio.get('/payment/subscriptions');
      return List<Map<String, dynamic>>.from(
          response.data['subscriptions'] ?? []);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSubscriptionDetail(int id) async {
    try {
      final response = await dio.get('/payment/subscriptions/$id');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
