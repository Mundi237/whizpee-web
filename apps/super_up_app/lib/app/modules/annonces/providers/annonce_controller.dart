import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/city.dart';
import 'package:super_up/app/modules/annonces/datas/services/annonce_service.dart';
import 'package:super_up/app/modules/annonces/datas/utils.dart';
import 'package:super_up/app/modules/annonces/presentation/announcement_detail_page.dart';
import 'package:super_up/app/modules/annonces/presentation/boost_annoncement.dart';
import 'package:super_up/app/modules/annonces/presentation/credit_pay_bottom_sheet.dart';
import 'package:super_up/app/modules/annonces/providers/boost_controller.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
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
  TextEditingController priceController = TextEditingController();

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
    // Vérifier le solde avant de créer la conversation
    final creditProvider = GetIt.I.get<CreditProvider>();

    // Charger le solde si non disponible
    if (creditProvider.wallet.value.data == null) {
      await creditProvider.getWallet();
    }

    // Vérifier si l'utilisateur a au moins 10 crédits
    final currentCredits =
        creditProvider.wallet.value.data?.credits.toInt() ?? 0;
    if (currentCredits < 10) {
      // Afficher dialog proposant l'achat de crédits
      final shouldBuy = await VAppAlert.showAskYesNoDialog(
        context: context,
        title: "Crédits insuffisants",
        content:
            "Vous avez besoin de 10 crédits pour contacter cet annonceur. Votre solde actuel est de $currentCredits crédits. Souhaitez-vous acheter des crédits maintenant?",
      );

      if (shouldBuy == 1) {
        // Ouvrir le bottom sheet d'achat de crédits
        await _showCreditPurchaseBottomSheet(context, creditProvider);
        return null;
      }
      return null;
    }

    try {
      final result = await annonceService.createConversation(annonceId);
      Utils.printLog(result);

      // Validation: vérifier que result n'est pas null et contient les champs requis
      if (result == null) {
        VAppAlert.showOkAlertDialog(
            context: context,
            title: S.of(context).error,
            content: "Réponse invalide du serveur");
        return null;
      }

      // Validation: vérifier les champs requis pour VRoom.fromMap
      // L'API retourne: roomId, title, image au lieu de rId, t, img
      if (result['roomId'] == null ||
          result['title'] == null ||
          result['image'] == null) {
        Utils.printLog("Champs manquants dans la réponse API:");
        Utils.printLog("roomId: ${result['roomId']}");
        Utils.printLog("title: ${result['title']}");
        Utils.printLog("image: ${result['image']}");
        VAppAlert.showOkAlertDialog(
            context: context,
            title: S.of(context).error,
            content: "Données de conversation incomplètes");
        return null;
      }

      // Mapper la structure API vers la structure attendue par VRoom.fromMap
      Map<String, dynamic> vRoomMap = {
        'rId': result['roomId'], // roomId -> rId
        't': result['title'], // title -> t
        'img': result['image'], // image -> img
        'tTo': null, // transTo (optionnel)
        'mentionsCount': 0, // mentionsCount (par défaut)
        'isA': false, // isArchived (par défaut)
        'isOneSeen': false, // isOneSeen (par défaut)
        'rT': 's', // roomType: 's' pour single (pas "single")
        'createdAt': result['createdAt'] ?? DateTime.now().toIso8601String(),
        'uC': 0, // unReadCount (par défaut)
        'isM': false, // isMuted (par défaut)
        'isD': false, // isDeleted (par défaut)
        'nTitle': null, // nickName (optionnel)
        'pId': result['announcementOwnerId'], // peerId
      };

      return VRoom.fromMap(vRoomMap);
    } catch (e) {
      Utils.logger(e.toString());

      // Gérer l'erreur 400 (solde insuffisant)
      if (e.toString().contains('400') ||
          e.toString().toLowerCase().contains('insufficient')) {
        final shouldBuy = await VAppAlert.showAskYesNoDialog(
          context: context,
          title: "Crédits insuffisants",
          content:
              "Vous n'avez pas assez de crédits pour contacter cet annonceur. Souhaitez-vous acheter des crédits maintenant?",
        );

        if (shouldBuy == 1) {
          final creditProvider = GetIt.I.get<CreditProvider>();
          await _showCreditPurchaseBottomSheet(context, creditProvider);
        }
      } else {
        VAppAlert.showOkAlertDialog(
            context: context,
            title: S.of(context).error,
            content:
                "Une erreur est survenue lors de la création de la conversation");
      }
      return null;
    }
  }

  // Méthode helper pour afficher le bottom sheet d'achat de crédits
  Future<void> _showCreditPurchaseBottomSheet(
      BuildContext context, CreditProvider creditProvider) async {
    // Charger les packages si nécessaire
    if (creditProvider.packagesList.value.data == null ||
        (creditProvider.packagesList.value.data ?? []).isEmpty) {
      await creditProvider.fetchPackages();
    }

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const CreditPayBottomSheet(),
      ),
    );
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
    villeController.clear();
    priceController.clear();
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

    // Validation des images
    final finalImages = images ?? this.images;
    if (finalImages.isEmpty) {
      VAppAlert.showErrorSnackBar(
          message: "Veuillez ajouter au moins une image", context: context);
      return;
    }

    annonceState.value = AppState.loading();
    notifyListeners();
    try {
      final annonce = await annonceService.createAnnonce(
        title: titleController.text,
        description: descriptionController.text,
        categorieId: selectedCategorie?.id.toString() ?? '',
        images: finalImages,
        quartier: quartier,
        ville: villeController.text,
        price: priceController.text.isNotEmpty ? priceController.text : null,
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
        // Set the created announcement in boost controller
        final boostController = GetIt.I.get<BoostController>();
        boostController.changeAnnonce(annonceState.value.data!);
        // Navigate to boost page instead of detail page
        context.toPage(
          BoostAnnoncementScreen(
            annonces: annonceState.value.data!,
          ),
        );
      }
    }
  }
}
