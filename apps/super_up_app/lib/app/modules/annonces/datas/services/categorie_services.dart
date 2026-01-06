import 'package:dio/dio.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Categorie;

class CategorieServices {
  final Dio dio;

  CategorieServices(this.dio);

  Future<List<Categorie>> getCategorie() async {
    try {
      final response = await dio.get('/annonces/categories');
      final data = response.data['data'];
      return (data as List).map((e) => Categorie.fromMap(e)).toList();
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }
}
