import 'package:flutter/cupertino.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/services/boost_services.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces, Boost;

class BoostController extends ChangeNotifier {
  final BoostServices boostServices;

  BoostController(this.boostServices);
  ValueNotifier<AppState<List<Boost>>> boostsListState =
      ValueNotifier(AppState());
  ValueNotifier<AppState<Annonces>> boostsState = ValueNotifier(AppState());
  Boost? selectedBoost;
  Annonces? selectedAnnonce;

  void changeBoost(Boost? boost) {
    selectedBoost = boost;
    notifyListeners();
  }

  void changeAnnonce(Annonces? annonce) {
    selectedAnnonce = annonce;
  }

  Future<void> getBoosts() async {
    try {
      boostsListState.value = AppState.loading();
      notifyListeners();
      final boosts = await boostServices.getBoosts();
      boostsListState.value = AppState.completed(boosts);
    } catch (e) {
      boostsListState.value = AppState.trash(e);
    }
  }

  Future<void> boosAnnonce(int duration, BuildContext context) async {
    try {
      boostsState.value = AppState.loading();
      notifyListeners();
      final boosts = await boostServices.boostAnnonce(
        duration: duration,
        annonceId: selectedAnnonce!.id,
        boostId: selectedBoost!.id,
      );
      boostsState.value = AppState.completed(boosts);
    } catch (e) {
      boostsState.value = AppState.trash(e);
    } finally {
      if (boostsState.value.hasNotNullData) {
        VAppAlert.showSuccessSnackBar(
            message: "Annoncement booted successfully", context: context);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }
}
