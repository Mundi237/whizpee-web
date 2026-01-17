import 'dart:io';

import 'package:dio/dio.dart';
import 'package:super_up/app/modules/annonces/datas/models/city.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/annonces/cores/error_handler.dart';
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
    String? price,
  }) async {
    try {
      final imagesData = await Future.wait(images
          .map(
            (e) async => await MultipartFile.fromFile(e.path,
                filename: '${DateTime.now().millisecondsSinceEpoch}.png'),
          )
          .toList());

      final Map<String, dynamic> formDataMap = {
        'title': title,
        "category": categorieId,
        "description": description,
        "images": imagesData,
        "ville": ville,
        "quartier": quartier
      };

      // Ajouter le prix seulement s'il est fourni (champ optionnel)
      if (price != null && price.isNotEmpty) {
        formDataMap["price"] = price;
      }

      final FormData data = FormData.fromMap(formDataMap);
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
    } on DioException catch (e) {
      // Gérer spécifiquement les erreurs Dio
      Utils.loggerError('DioException dans publishAnnonce: ${e.message}');
      Utils.loggerError('Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      // Gérer les autres types d'erreurs
      Utils.loggerError('Erreur inattendue dans publishAnnonce: $e');
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

      // Validation: s'assurer que la réponse n'est pas null
      if (response.data == null) {
        throw CustomException(message: "Réponse serveur invalide");
      }

      return response.data;
    } catch (e) {
      Utils.loggerError(e);
      rethrow;
    }
  }
}
