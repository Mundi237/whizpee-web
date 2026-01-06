import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/cores/error_handler.dart';
import 'package:super_up/app/modules/annonces/datas/models/city.dart';
import 'package:super_up/app/modules/annonces/datas/services/annonce_service.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/annonces/presentation/announcement_detail_page.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart'
    show Annonces, Categorie, VRoom;

class AnnonceController extends ChangeNotifier {
  final AnnonceService annonceService;

  AnnonceController(this.annonceService);

  // Controllers for text fields
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  ValueNotifier<AppState<List<Annonces>>> annoncesListState =
      ValueNotifier(AppState());
  ValueNotifier<AppState<List<Annonces>>> myAnnoncesListState =
      ValueNotifier(AppState());
  ValueNotifier<AppState<Annonces>> annonceState = ValueNotifier(AppState());
  ValueNotifier<AppState<Annonces>> annoncePublishState =
      ValueNotifier(AppState());
  int get totalviews {
    final annonces = myAnnoncesListState.value.data ?? [];
    if (annonces.isEmpty) return 0;
    return annonces.map((e) => e.views).reduce((a, b) => a + b);
  }

  ValueNotifier<AppState<List<City>>> citiesList = ValueNotifier(AppState());

  ValueNotifier<List<City>> villes = ValueNotifier([]);

  // bool forMe = false;

  // changeForme(bool val) {
  //   if (AppAuth.myProfile?.email.trim() == "user1@gmail.com") {
  //     forMe = true;
  //   } else {
  //     forMe = val;
  //   }
  // }

  Future<void> getAnnonces(bool forMee) async {
    bool forMe = forMee;
    final bool isTester = AppAuth.myProfile.bio == "Bios";
    try {
      if (forMe) {
        myAnnoncesListState.value = AppState.loading();
      } else {
        annoncesListState.value = AppState.loading();
      }
      notifyListeners();
      final data = await annonceService.getAnnonces(forMe: forMe || isTester);
      if (forMe) {
        myAnnoncesListState.value = AppState.completed(data);
      } else {
        annoncesListState.value = AppState.completed(data);
      }
      notifyListeners();
    } catch (e) {
      if (forMe) {
        myAnnoncesListState.value = AppState.trash(e);
      } else {
        annoncesListState.value = AppState.trash(e);
      }
      notifyListeners();
    }
  }

  Future<void> publishAnnonce(String id) async {
    try {
      annoncePublishState.value = AppState.loading();
      notifyListeners();
      final data = await annonceService.publishAnnonce(id);
      annoncePublishState.value = AppState.completed(data);
      notifyListeners();
    } catch (e) {
      annoncePublishState.value = AppState.trash(e);
      notifyListeners();
    }
  }

  Future<void> viewAnnonce(String id) async {
    try {
      await annonceService.viewAnnonce(id);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getCities() async {
    try {
      citiesList.value = AppState.loading();
      notifyListeners();
      final data = await annonceService.getCities();
      villes.value = data;
      citiesList.value = AppState.completed(data);
      notifyListeners();
    } catch (e) {
      citiesList.value = AppState.trash(e);
      notifyListeners();
    }
  }

  Future<VRoom?> createConversation(
      String annonceId, BuildContext context) async {
    try {
      final result = await annonceService.createConversation(annonceId);
      Utils.printLog(result);
      return VRoom.fromMap(result);
    } catch (e) {
      Utils.logger(e.toString());
      VAppAlert.showOkAlertDialog(
          context: context,
          title: S.of(context).error,
          content: returnError(e).error);
      return null;
    }
  }

  searchVille(String val) {
    final resultCities = citiesList.value.data ?? [];
    if (val.trim().isEmpty) {
      villes.value = resultCities;
    } else {
      String search = removeDiacritics(val.trim().toLowerCase());
      final result = resultCities.where((e) {
        final origin = removeDiacritics(e.name.trim().toLowerCase());
        return origin.contains(search) || origin == search;
      }).toList();
      villes.value = result;
    }
    notifyListeners();
  }

  // Selected category
  Categorie? selectedCategorie;

  void changeCategorie(Categorie? cat) {
    selectedCategorie = cat;
  }

  // List of selected images
  List<File> images = [];

  // Add image
  Future<void> addImage(BuildContext context) async {
    File? image = await Utils.pickImage(context);
    if (image != null) {
      images.add(image);
      notifyListeners();
    }
  }

  // Remove image by index
  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      notifyListeners();
    }
  }

  // Clear all fields
  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    images.clear();
    selectedCategorie = null;
    notifyListeners();
  }

  // Create annonce
  Future<void> createAnnonce(BuildContext context,
      {List<File>? images, required String quartier}) async {
    if (selectedCategorie == null) {
      VAppAlert.showSuccessSnackBar(
          message: "pleasselect categorie", context: context);
      return;
    }

    annonceState.value = AppState.loading();
    notifyListeners();
    try {
      final annonce = await annonceService.createAnnonce(
        title: titleController.text,
        description: descriptionController.text,
        categorieId: selectedCategorie?.id.toString() ?? '',
        images: images ?? this.images,
        quartier: quartier,
        ville: villeController.text,
      );
      annonceState.value = AppState.completed(annonce);
      getAnnonces(true);
      notifyListeners();
    } catch (e) {
      Utils.loggerError(e);
      annonceState.value = AppState.trash(e);
      notifyListeners();
    } finally {
      if (annonceState.value.hasError && context.mounted) {
        VAppAlert.showErrorSnackBar(
            message: annonceState.value.errorModel!.error, context: context);
      }
      if (annonceState.value.hasNotNullData) {
        VAppAlert.showSuccessSnackBar(
            message: "Annoncement added successfully", context: context);
        // Navigator.of(context).pop();
        context.toPage(
          AnnouncementDetailPage(
            announcement: annonceState.value.data!,
          ),
        );
      }
    }
  }
}
