import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:super_up/app/modules/annonces/datas/models/credi_wallet.dart';
import 'package:super_up/app/modules/annonces/datas/models/package.dart';
import 'package:super_up/app/modules/annonces/datas/models/package_transaction.dart';
import 'package:super_up_core/super_up_core.dart';

class CreditService {
  final Dio _dio;
  CreditService(this._dio);

  Future<List<Package>> fetchPackages() async {
    try {
      final response = await _dio.get('/api/credits/packages');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['packages'];
        return data.map((json) => Package.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PackageTransaction> purchasePackage(String packageId) async {
    try {
      final response = await _dio.post(
        '/api/credits/purchase-by-package',
        data: {'packageId': packageId},
      );
      return PackageTransaction.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CrediWallet> getWallet() async {
    try {
      final response = await _dio.get('/api/credits/balance');
      if (response.statusCode == 200) {
        return CrediWallet.fromJson(response.data);
      } else {
        throw Exception('Failed to get wallet');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PackageTransaction>> fetchTransactions({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response =
          await _dio.get('/api/credits/purchases', queryParameters: {
        'page': page,
        'skip': limit,
      });
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['purchases'];
        final list =
            data.map((json) => PackageTransaction.fromJson(json)).toList();
        VAppPref.setList(
            "packages", list.map((e) => jsonEncode(e.toJson())).toList());
        return list;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PackageTransaction>?> getPackagesFromStorages() async {
    try {
      final list = VAppPref.getList("packages");
      if (list == null) return null;
      if (list.isEmpty) return null;
      return list
          .map((e) => PackageTransaction.fromJson(jsonDecode(e)))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
