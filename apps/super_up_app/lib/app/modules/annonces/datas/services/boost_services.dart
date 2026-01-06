import 'package:dio/dio.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Boost, Annonces;

class BoostServices {
  final Dio dio;

  BoostServices(this.dio);

  Future<List<Boost>> getBoosts() async {
    try {
      final result = await dio.get("/boost-types");
      final data = result.data['data'];
      return (data as List).map((e) => Boost.fromJson(e)).toList();
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }

  Future<Annonces> boostAnnonce(
      {required String annonceId,
      required String boostId,
      required int duration}) async {
    try {
      final result = await dio.post("/annonces/$annonceId/boost",
          data: {"boostTypeId": boostId, "days": duration});
      return Annonces.fromMap(result.data['data']);
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }
}
