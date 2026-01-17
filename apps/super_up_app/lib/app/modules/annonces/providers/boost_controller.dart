import 'package:flutter/cupertino.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/services/boost_services.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:get_it/get_it.dart';
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

  Future<void> boosAnnonce(int duration) async {
    try {
      boostsState.value = AppState.loading();
      notifyListeners();

      final boostedAnnonce = await boostServices.boostAnnonce(
        duration: duration,
        annonceId: selectedAnnonce!.id,
        boostId: selectedBoost!.id,
      );

      // Update the selected announcement with the boosted version
      selectedAnnonce = boostedAnnonce;

      boostsState.value = AppState.completed(boostedAnnonce);
      notifyListeners();
    } catch (e) {
      // Logger l'erreur pour le débogage
      debugPrint('Erreur lors du boost: $e');
      boostsState.value = AppState.trash(e);
      notifyListeners();
    }
  }

  Future<void> publishAnnonceWithoutBoost(String annonceId) async {
    try {
      boostsState.value = AppState.loading();
      notifyListeners();

      // Utiliser AnnonceController pour publier l'annonce
      final annonceController = GetIt.I.get<AnnonceController>();
      await annonceController.publishAnnonce(annonceId);

      // Mettre à jour l'annonce sélectionnée avec le statut publié
      if (selectedAnnonce != null) {
        // Créer une copie de l'annonce avec le statut publié
        final updatedAnnonce = Annonces.fromMap({
          ...selectedAnnonce!.toMap(),
          'isPublished': true,
        });
        selectedAnnonce = updatedAnnonce;
      }

      boostsState.value = AppState.completed(selectedAnnonce!);
      notifyListeners();
    } catch (e) {
      boostsState.value = AppState.trash(e);
      notifyListeners();
    }
  }
}
