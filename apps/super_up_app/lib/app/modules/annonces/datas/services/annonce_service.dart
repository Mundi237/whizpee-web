import 'dart:io';

import 'package:dio/dio.dart';
import 'package:super_up/app/modules/annonces/datas/models/city.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces;

class AnnonceService {
  final Dio dio;

  AnnonceService(this.dio);

  Future<Annonces> createAnnonce({
    required String title,
    required String description,
    required String categorieId,
    required List<File> images,
    required String ville,
    required String quartier,
  }) async {
    try {
      final imagesData = await Future.wait(images
          .map(
            (e) async => await MultipartFile.fromFile(e.path,
                filename: '${DateTime.now().millisecondsSinceEpoch}.png'),
          )
          .toList());
      final FormData data = FormData.fromMap({
        'title': title,
        "category": categorieId,
        "description": description,
        "images": imagesData,
        "ville": ville,
        "quartier": quartier
      });
      final result = await dio.request(
        "/annonces",
        data: data,
        options: Options(
          method: 'POST',
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization':
                "Bearer ${VAppPref.getHashedString(key: SStorageKeys.vAccessToken.name)}",
          },
        ),
      );
      return Annonces.fromMap(result.data['data']);
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }

  Future<List<Annonces>> getAnnonces({final bool forMe = true}) async {
    try {
      final response =
          await dio.get(!forMe ? '/annonces' : '/annonces/my-annonces');
      final data = response.data['data'];
      return (data as List).map((e) => Annonces.fromMap(e)).toList();
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }

  Future<Annonces> publishAnnonce(String annonceID) async {
    try {
      final response =
          await dio.post('/annonces/publish', data: {"annonceId": annonceID});
      final data = response.data['data'];
      return Annonces.fromMap(data);
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }

  Future viewAnnonce(String annonceID) async {
    try {
      await dio.get('/annonces/$annonceID/views');
      // final data = response.data['data'];
      return 200;
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }

  Future<List<City>> getCities() async {
    try {
      final response = await Dio().get(
        "https://api.countrystatecity.in/v1/countries/CM/cities",
        options: Options(
          headers: {
            'X-CSCAPI-KEY':
                'cUc1c2ZJMGVMOEVUR25KQ25UWG41UVB1V1RXTDBwekZLZGpmd0g2WQ=='
          },
        ),
      );
      final data = response.data as List;
      return data.map((city) => City.fromMap(city)).toList();
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }

  Future createConversation(String annonceId) async {
    try {
      final response =
          await dio.post("/annonces/$annonceId/start-conversation");
      Utils.printLog(response.data);
      return response.data;
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }
}
