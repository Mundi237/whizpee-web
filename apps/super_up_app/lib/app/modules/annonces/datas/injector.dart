import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_up/app/modules/annonces/datas/services/api_services.dart';
import 'package:super_up/app/modules/annonces/datas/services/annonce_service.dart';
import 'package:super_up/app/modules/annonces/datas/services/boost_services.dart';
import 'package:super_up/app/modules/annonces/datas/services/categorie_services.dart';
import 'package:super_up/app/modules/annonces/datas/services/credit_service.dart';
import 'package:super_up/app/modules/annonces/datas/services/local_storage_service.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';
import 'package:super_up/app/modules/annonces/providers/categorie_controller.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
import 'package:super_up/app/modules/annonces/datas/services/credits/credit_api_service.dart';
import 'package:super_up/app/modules/annonces/datas/services/credits/payment_api_service.dart';
import 'package:super_up/app/modules/annonces/providers/wallet_provider.dart';
import 'package:super_up/app/modules/annonces/providers/payment_provider.dart';

void initInjectorApp({required SharedPreferences preferences}) {
  ///// START ////

  GetIt.I.registerLazySingleton<Dio>(() => API().dio);

  GetIt.I.registerLazySingleton<APIPackages>(() => APIPackages());

  GetIt.I.registerLazySingleton<SharedPreferences>(() => preferences);

  GetIt.I.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(preferences),
  );
  GetIt.I.registerLazySingleton<AnnonceService>(
    () => AnnonceService(GetIt.I<Dio>()),
  );
  GetIt.I.registerLazySingleton<BoostServices>(
    () => BoostServices(GetIt.I<Dio>()),
  );
  GetIt.I.registerLazySingleton<CategorieServices>(
    () => CategorieServices(GetIt.I<Dio>()),
  );
  GetIt.I.registerLazySingleton(
      () => CategorieController(GetIt.I<CategorieServices>()));
  GetIt.I.registerLazySingleton(
      () => AnnonceController(GetIt.I<AnnonceService>()));
  GetIt.I
      .registerLazySingleton(() => BoostController(GetIt.I<BoostServices>()));

  GetIt.I
      .registerLazySingleton(() => CreditService(GetIt.I<APIPackages>().dio));

  GetIt.I.registerLazySingleton(() => CreditProvider(GetIt.I<CreditService>()));

  GetIt.I.registerLazySingleton<APICredits>(() => APICredits());

  GetIt.I.registerLazySingleton<CreditApiService>(
    () => CreditApiService(GetIt.I<APICredits>().dio),
  );

  GetIt.I.registerLazySingleton<PaymentApiService>(
    () => PaymentApiService(GetIt.I<APICredits>().dio),
  );

  GetIt.I.registerLazySingleton<WalletProvider>(
    () => WalletProvider(GetIt.I<CreditApiService>()),
  );

  GetIt.I.registerLazySingleton<PaymentProvider>(
    () => PaymentProvider(GetIt.I<PaymentApiService>()),
  );
  ///// END ////
}
