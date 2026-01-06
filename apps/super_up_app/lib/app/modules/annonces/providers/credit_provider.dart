import 'package:flutter/foundation.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/cores/error_handler.dart';
import 'package:super_up/app/modules/annonces/datas/models/credi_wallet.dart';
import 'package:super_up/app/modules/annonces/datas/models/package.dart';
import 'package:super_up/app/modules/annonces/datas/models/package_transaction.dart';
import 'package:super_up/app/modules/annonces/datas/services/credit_service.dart';
import 'package:super_up_core/super_up_core.dart';

class CreditProvider extends ChangeNotifier {
  final CreditService creditService;
  CreditProvider(this.creditService);

  int page = 1;
  int limit = 25;

  ValueNotifier<AppState<List<Package>>> packagesList =
      ValueNotifier<AppState<List<Package>>>(AppState());

  ValueNotifier<AppState<List<PackageTransaction>>> packageTransactionsList =
      ValueNotifier<AppState<List<PackageTransaction>>>(AppState());

  ValueNotifier<AppState<PackageTransaction>> packageTransaction =
      ValueNotifier<AppState<PackageTransaction>>(AppState());

  ValueNotifier<AppState<CrediWallet>> wallet =
      ValueNotifier<AppState<CrediWallet>>(AppState());

  Package? selectedPackage;

  void selecTPackage(Package package) {
    selectedPackage = package;
  }

  Future<void> getWallet() async {
    try {
      wallet.value = AppState.loading();
      notifyListeners();
      final data = await creditService.getWallet();
      wallet.value = AppState.completed(data);
      notifyListeners();
    } catch (e) {
      wallet.value = AppState.error(returnError(e));
      notifyListeners();
    }
  }

  Future<void> fetchPackages() async {
    try {
      packagesList.value = AppState.loading();
      notifyListeners();
      final data = await creditService.fetchPackages();
      packagesList.value = AppState.completed(data);
      notifyListeners();
    } catch (e) {
      packagesList.value = AppState.error(returnError(e));
      notifyListeners();
    }
  }

  Future<void> purchasePackage({VoidCallback? onsuCess}) async {
    try {
      packageTransaction.value = AppState.loading();
      notifyListeners();
      final data = await creditService.purchasePackage(selectedPackage!.id);
      packageTransaction.value = AppState.completed(data);
      notifyListeners();
    } catch (e) {
      packageTransaction.value = AppState.error(returnError(e));
      notifyListeners();
    } finally {
      notifyListeners();
      if (packageTransaction.value.hasError) {
        VAppAlert.showErrorSnackBarWithoutContext(
          message: packageTransaction.value.errorModel?.error ??
              "Une erreur est survenue lors de l'achat du forfait. Veuillez réessayer.",
        );
      } else if (packageTransaction.value.hasNotNullData) {
        if (packageTransaction.value.hasError) {
          getWallet();
          if (onsuCess == null) {
            VAppAlert.showSuccessSnackBarWithoutContext(
              message:
                  "Votre achat est en cours de traitement. Veuillez patienter...",
            );
          } else {
            onsuCess.call();
          }
        }
      }
    }
  }

  Future<void> fetchTransactions() async {
    try {
      packageTransactionsList.value = AppState.loading();
      notifyListeners();
      final data =
          await creditService.fetchTransactions(page: page, limit: limit);
      packageTransactionsList.value = AppState.completed(data);
      notifyListeners();
    } catch (e) {
      packageTransactionsList.value = AppState.error(returnError(e));
      notifyListeners();
    }
  }
}
