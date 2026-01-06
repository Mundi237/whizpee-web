import 'package:flutter/cupertino.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/services/categorie_services.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Categorie;

class CategorieController extends ChangeNotifier {
  CategorieServices categorieServices;

  CategorieController(this.categorieServices);

  ValueNotifier<AppState<List<Categorie>>> categoriesState =
      ValueNotifier(AppState());

  Future<void> getCategories() async {
    try {
      categoriesState.value = AppState.loading();
      notifyListeners();
      final data = await categorieServices.getCategorie();
      categoriesState.value = AppState.completed(data);
      notifyListeners();
    } catch (e) {
      categoriesState.value = AppState.trash(e);
      notifyListeners();
    }
  }
}
