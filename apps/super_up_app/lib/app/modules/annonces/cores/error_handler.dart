// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:super_up/app/modules/annonces/cores/error_model.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
// import 'package:firebase_core/firebase_core.dart';

///
///Le fichier que voicie contient les fonctions de gestion des erreur
///

// Gestion des errrue globale

ErrorModel returnError(dynamic error) {
  if (error is CustomException) {
    return ErrorModel(error: error.message);
  }
  // error.printInfo();
  switch (error.runtimeType) {
    case const (SocketException):
      // printer('socket exception');
      return ErrorModel.fromMap({"error": 'Erreur de connection internet'});
    case const (TimeoutException):
      // printer('socket exception');
      return ErrorModel.fromMap({
        "error": 'Delet d\'attente dépaasé veillez réssayer',
      });
    case const (PlatformException):
      Utils.printer(error);
      return ErrorModel.fromMap({"error": 'Erreur systeme inconnue'});
    // case const (UnauthorizedException):
    //   Utils.printer(error);
    //   Get.find<UserController>().logout();
    //   return ErrorModel.fromMap({
    //     "error": 'Vous n\'êtes pas autorisé à accéder à cette ressource',
    //   });

    // case const (FirebaseAuthException):
    //   Utils.printer(error);
    //   return ErrorModel.fromMap({
    //     "error": (error as FirebaseAuthException).message ?? error.code,
    //   });
    case const (DioException):
      // printer('error dio');
      return manageDioError(error as DioException);
    case const (CustomException):
      // printer('error dio');
      return ErrorModel.fromMap({'error': (error as CustomException).message});
    default:
      // printer('cant\'t get error type ${error.runtimeType}');
      return ErrorModel.fromMap({'error': error.toString()});
  }
}

// Gestion des erreur web service du packages Dio

ErrorModel manageDioError(DioException except) {
  final code = except.response?.statusCode;
  if (except.error is CustomException) {
    return ErrorModel(error: (except.error as CustomException).message);
  }

  if (except.error.runtimeType.toString() == "_Exception") {
    return ErrorModel(error: (except.error as dynamic)?.message);
  }
  // if (except.error is UnauthorizedException) {
  //   Get.find<UserController>().logout();
  //   return ErrorModel.fromMap({
  //     "error": 'Vous n\'êtes pas autorisé à accéder à cette ressource',
  //   });
  // }
  // if(except.error is  Exception && (except.error as Exception)) {
  //   return ErrorModel.fromMap({
  //     "error": 'Erreur de connection internet',
  //   });
  // }

  switch (code) {
    case 400:
      if (except.response?.data['error_message'] != null) {
        return ErrorModel.fromMap({
          'error': except.response?.data['error_message'],
          'code': code,
        });
      }
      return ErrorModel.fromMap({
        "error":
            'Impossible de traiter votre demande veuillez réessayer plus tard',
        'code': code,
      });
    case 401:
      return ErrorModel.fromMap({
        "error": 'AUthorisation refusée',
        'code': code,
      });
    case 403:
      Utils.printer(
        except.response?.data['error'] ??
            except.response?.data ??
            except.response?.statusMessage,
      );
      return ErrorModel.fromMap({
        "error": except.response?.statusMessage ?? 'Données incorrectes',
        'code': code,
      });
    case 413:
      Utils.printer(
        except.response?.data['error'] ??
            except.response?.data ??
            except.response?.statusMessage,
      );
      return ErrorModel.fromMap({
        "error": "La taille de la requête est trop grande",
        'code': code,
      });
    case 500:
      Utils.printer(
        except.response?.data['error'] ??
            except.response?.data ??
            except.response?.statusMessage,
      );
      return ErrorModel.fromMap({
        "error": except.response?.data['error'] ??
            except.response?.data ??
            except.response?.statusMessage ??
            'Erreur de serveur interne',
        'code': code,
      });
    case 404:
      return ErrorModel.fromMap({
        'error': 'Connection au serveur impossible',
        'code': code,
      });
    default:
      switch (except.type) {
        case DioExceptionType.receiveTimeout:
          return ErrorModel.fromMap({
            'code': code,
            'error': 'Temps de réponse dépassé',
          });
        case DioExceptionType.sendTimeout:
          return ErrorModel.fromMap({
            'code': code,
            'error': 'Temps de réponse dépassé',
          });
        case DioExceptionType.connectionTimeout:
          return ErrorModel.fromMap({
            'code': code,
            'error': except.response?.data['error'] ??
                "Connection au serveur impossible",
          });
        case DioExceptionType.cancel:
          return ErrorModel.fromMap({'code': code, 'error': 'Requête annulée'});
        case DioExceptionType.badCertificate:
          return ErrorModel.fromMap({
            'code': code,
            'error':
                except.response?.data['error'] ?? "Certificat SSL invalide",
          });
        case DioExceptionType.badResponse:
          return ErrorModel.fromMap({
            'code': code,
            'error': except.response?.data['error'] ??
                "Quelque chose n'a pas fonctionné",
          });
        default:
          return ErrorModel.fromMap({
            'code': code,
            'error': except.response?.data['error'] ??
                except.error.toString() ??
                "Quelque chose n'a pas fonctionné",
          });
      }
  }
}

// Gestion des erreur inconnues .

ErrorModel returnCatchError(error) {
  switch (error.runtimeType) {
    case const (SocketException):
      Utils.printer('error SOCKET $error');
      return ErrorModel.fromMap({"error": 'Erreur de connection internet'});

    case const (HttpException):
      Utils.printer('error HTTP');
      return ErrorModel.fromMap({"error": 'Erreur de connection internet'});
    default:
      // printer('cant\'t get error type');
      return ErrorModel.fromMap({'error': "Quelque chose n'a pas fonctionné"});
  }
}

class CustomException implements Exception {
  final String message;
  final int? code;
  CustomException({required this.message, this.code});
}
