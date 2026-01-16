// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:photofilters/photofilters.dart';
// import 'package:image/image.dart' as imageLib;
// import 'package:path_provider/path_provider.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/models/city.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/categorie_controller.dart';
// import 'package:super_up/app/core/theme/app_theme_manager.dart';
import 'package:super_up/app/modules/annonces/presentation/custom_text_field.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Categorie;
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_platform/v_platform.dart';

class BoostOption {
  final String level;
  final String description;
  final String? badge;
  final double amount;

  BoostOption(
      {required this.level,
      required this.description,
      required this.amount,
      this.badge});
}

class CreateAnnouncementPage extends StatefulWidget {
  const CreateAnnouncementPage({super.key});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  // final TextEditingController _titleController = TextEditingController();
  final TextEditingController quarterController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController categorie = TextEditingController();
  final List<File> _images = [];

  final AnnonceController annonceController = GetIt.I.get<AnnonceController>();
  final CategorieController categorieController =
      GetIt.I.get<CategorieController>();

  Future<VBaseMediaRes?> pickImage(bool camera) async {
    final VPlatformFile? image = await VAppPick.getImage(isFromCamera: camera);
    if (image == null) return null;
    final VBaseMediaRes? mediaAfterEdit = await onSubmitMedia(context, [image]);
    return mediaAfterEdit;
  }

  Future<VBaseMediaRes?> onSubmitMedia(
    BuildContext context,
    List<VPlatformFile> files,
  ) async {
    final fileRes = await context.toPage(VMediaEditorView(
      files: files,
    )) as List<VBaseMediaRes>?;
    if (fileRes == null || fileRes.isEmpty) return null;
    return fileRes.first;
  }

  File? vBaseMediaResToFile(VBaseMediaRes media) {
    try {
      final filePath = media.getVPlatformFile().fileLocalPath;
      if (filePath == null) return null;
      final file = File(filePath);
      return file;
    } catch (e) {
      print("Erreur conversion VBaseMediaRes en File: $e");
      return null;
    }
  }

  @override
  dispose() {
    annonceController.clearFields();
    super.dispose();
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (builderContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            // color: black,
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Choisir une ville',
                  style: TextStyle(
                    // color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const Divider(color: Colors.grey),
              SizedBox(height: 10),
              ValueListenableBuilder<AppState<List<City>>>(
                  valueListenable: annonceController.citiesList,
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (value.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                value.errorModel!.error,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade500, fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    annonceController.getCities();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                      );
                    }
                    if ((value.data ?? []).isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Column(
                            children: [
                              Text(
                                'No city found.',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  annonceController.getCities();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }

                    return ValueListenableBuilder<List<City>>(
                        valueListenable: annonceController.villes,
                        builder: (context, villes, child) {
                          return Expanded(
                            child: Column(
                              children: [
                                CustomTextField(
                                  label: 'Rechercher',
                                  hint: 'Chercher la vile',
                                  // controller: _categorieController,
                                  suffixIcon: Icon(Icons.search,
                                      color: Colors.grey.shade500),
                                  onChanged: annonceController.searchVille,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: villes.length,
                                    itemBuilder: (listContext, index) {
                                      return ListTile(
                                        title: Text(
                                          villes[index].name,
                                          style: const TextStyle(
                                              // color: white
                                              ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            annonceController.villeController
                                                .text = villes[index].name;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  }),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: _locations.length,
              //     itemBuilder: (listContext, index) {
              //       return ListTile(
              //         title: Text(_locations[index],
              //             style: const TextStyle(color: white)),
              //         onTap: () {
              //           setState(() {
              //             annonceController.villeController.text =
              //                 _locations[index];
              //           });
              //           Navigator.of(context).pop();
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoriesPicker() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.transparent,
      builder: (builderContext) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            // color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Choisir une categorie',
                  style: TextStyle(
                    // color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(color: Colors.grey),
              ValueListenableBuilder<AppState<List<Categorie>>>(
                  valueListenable: categorieController.categoriesState,
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (value.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                value.errorModel!.error,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade500, fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    categorieController.getCategories();
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                      );
                    }
                    if ((value.data ?? []).isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Column(
                            children: [
                              Text(
                                'No categorie found.',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  categorieController.getCategories();
                                },
                                icon: Icon(
                                  Icons.refresh,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    final List<Categorie> categories = value.data!;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (listContext, index) {
                          return ListTile(
                            title: Text(
                              categories[index].name,
                              style: const TextStyle(
                                  // color: white
                                  ),
                            ),
                            onTap: () {
                              annonceController
                                  .changeCategorie(categories[index]);
                              setState(() {
                                _categorieController.text =
                                    categories[index].name;
                              });
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }

  final formKey = GlobalKey<FormState>();

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  // color: white
                ),
                title: const Text(
                  'Galerie',
                  style: TextStyle(
                      // color: white
                      ),
                ),
                onTap: () async {
                  final result = await pickImage(false);
                  if (result != null) {
                    final data = vBaseMediaResToFile(result);
                    if (data != null) {
                      _images.add(data);
                      setState(() {});
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  // color: white
                ),
                title: const Text(
                  'Appareil photo',
                  style: TextStyle(
                      // color: white
                      ),
                ),
                onTap: () async {
                  final result = await pickImage(true);
                  if (result != null) {
                    final data = vBaseMediaResToFile(result);
                    if (data != null) {
                      _images.add(data);
                      setState(() {});
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _geoLocate() {}

  Widget _buildImagePicker() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _images.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 150,
      ),
      itemBuilder: (context, index) {
        if (index < _images.length) {
          final imageFile = _images[index];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          );
        } else {
          // Dernier index : bouton +
          return GestureDetector(
            onTap: () => _showPicker(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: black,
      appBar: AppBar(
        // backgroundColor: black,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Préparez votre annonce',
          style: TextStyle(
              // color: white,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            // color: white
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.remove_red_eye, color: white),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            children: [
              SizedBox(height: 15),
              Text(
                'Optimisez le contenu et choisissez vos options avant de lancer votre campagne.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  // color: white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade900),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Contenu de l\'annonce',
                        style: TextStyle(
                          // color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: annonceController.titleController,
                        label: 'Titre',
                        validator: (title) {
                          if (title == null || title.trim().length < 3) {
                            return "Invalide title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: annonceController.descriptionController,
                        label: 'Description',
                        hint: 'Décrivez votre annonce...',
                        maxLines: 5,
                        validator: (title) {
                          if (title == null || title.trim().length < 10) {
                            return "Invalide description";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: annonceController.villeController,
                              onTap: () {
                                annonceController.getCities();
                                _showLocationPicker();
                              },
                              label: 'Localisation',
                              hint: 'Sélectionnez une ville',
                              validator: (title) {
                                if (title == null) {
                                  return "Invalide location";
                                }
                                return null;
                              },
                              suffixIcon: SizedBox(
                                height: 24,
                                width: 24,
                                child: GestureDetector(
                                  onTap: _geoLocate,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      // color: white,
                                    ),
                                  ),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Prix (XAF)',
                        hint: 'Entrez le prix en FCFA',
                        keyboardType: TextInputType.number,
                        controller: annonceController.priceController,
                        validator: (val) {
                          // Prix est optionnel selon l'API
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Quartier',
                        hint: 'Sélectionnez une quartier',
                        controller: quarterController,
                        validator: (title) {
                          if (title?.trim().isEmpty ?? true) {
                            return "Neighborhood is required ";
                          }
                          return null;
                        },
                        // onTap: () {
                        //   categorieController.getCategories();
                        //   _showCategoriesPicker();
                        // },
                        // readOnly: true,
                        // suffixIcon: Icon(
                        //   Icons.arrow_drop_down,
                        //   color: Colors.grey.shade500,
                        // ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Categorie',
                        hint: 'Sélectionnez une categorie',
                        controller: _categorieController,
                        validator: (val) {
                          if (annonceController.selectedCategorie == null) {
                            return "Categorie is required";
                          }
                          return null;
                        },
                        onTap: () {
                          categorieController.getCategories();
                          _showCategoriesPicker();
                        },
                        readOnly: true,
                        suffixIcon: Icon(Icons.arrow_drop_down,
                            color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Images *',
                            style: TextStyle(
                              // color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(Au moins une image requise)',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildImagePicker(),
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                          valueListenable: annonceController.annonceState,
                          builder: (context, value, child) {
                            return ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  // Validation supplémentaire pour les images
                                  if (_images.isEmpty) {
                                    VAppAlert.showErrorSnackBar(
                                      message:
                                          "Veuillez ajouter au moins une image pour créer une annonce",
                                      context: context,
                                    );
                                    return;
                                  }

                                  await annonceController.createAnnonce(
                                    context,
                                    images: _images,
                                    quartier: quarterController.text,
                                  );
                                  // if (annonceController
                                  //     .annonceState.value.hasNotNullData) {}
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: primary,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Creer l'annonce",
                                    style: TextStyle(
                                      fontSize: 18,
                                      // color: white
                                    ),
                                  ),
                                  if (value.isLoading) ...[
                                    SizedBox(width: 10),
                                    Container(
                                      height: 27,
                                      width: 27,
                                      padding: EdgeInsets.all(2),
                                      child: CircularProgressIndicator(
                                          // color: white
                                          ),
                                    )
                                  ]
                                ],
                              ),
                            );
                          }),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
