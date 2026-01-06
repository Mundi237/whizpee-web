import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
// import 'package:super_up/app/core/theme/app_theme_manager.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/services/api_services.dart';
import 'package:super_up/app/modules/annonces/presentation/annoncment_component.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces;

// import 'package:super_up_core/super_up_core.dart';

class AnnouncementsPage extends StatefulWidget {
  final bool withBack;
  const AnnouncementsPage({super.key, this.withBack = false});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  String? _selectedLocation;
  DateTime? _selectedDate;

  @override
  initState() {
    final AnnonceController controller = GetIt.I.get<AnnonceController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAnnonces(false);
      GetIt.I.get<CreditProvider>().fetchPackages();
      GetIt.I.get<CreditProvider>().getWallet();
      refreshToken();
    });
    super.initState();
  }

  void _showLocationPicker(BuildContext modalContext) {
    showModalBottomSheet(
      context: context, // Use the main context
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 250,
          decoration: const BoxDecoration(
            // color: bgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Toutes les localisations',
                  style: TextStyle(
                    // color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLocation = null;
                  });
                  Navigator.pop(context); // Close location picker
                  Navigator.pop(modalContext); // Close filter modal
                },
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: ListView.builder(
                  itemCount: 5, //locations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "locations[index]",
                        style: const TextStyle(
                            // color: white
                            ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedLocation = "locations[index]";
                        });
                        Navigator.pop(context); // Close location picker
                        Navigator.pop(modalContext); // Close filter modal
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        // Use a different context name to avoid confusion
        return Container(
          height: 250,
          decoration: const BoxDecoration(
            // color: bgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filtres',
                    style: TextStyle(
                        // color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // Location Filter
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Localisation',
                    style: TextStyle(
                      // color: white,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedLocation ?? 'Toutes',
                        style: const TextStyle(
                          // color: primary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        // color: primary,
                        size: 16,
                      ),
                    ],
                  ),
                  onTap: () => _showLocationPicker(modalContext),
                ),
                const Divider(color: Colors.grey),
                // Date Filter
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Date',
                    style: TextStyle(
                      // color: white,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'Toutes',
                        style: const TextStyle(
                          // color: primary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        // color: primary,
                        size: 16,
                      ),
                    ],
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                      if (modalContext.mounted) Navigator.pop(modalContext);
                      // Close the filter modal
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<AnnonceController>();
    return Scaffold(
      extendBody: true,
      // backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.getAnnonces(false);
          },
          child: CustomScrollView(
            // physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                //  backgroundColor: bgColor,
                border:
                    const Border(bottom: BorderSide(color: Colors.transparent)),
                leading: !widget.withBack
                    ? null
                    : GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          // color: white
                        ),
                      ),
                largeTitle: Text(
                  "Annonces",
                  style: TextStyle(
                      // color: white
                      ),
                ),
                trailing: IconButton(
                  onPressed: _showFilterModal,
                  icon: const Icon(
                    Icons.filter_list,
                    // color: white
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ListingsBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListingsBody extends StatelessWidget {
  const ListingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final AnnonceController controller = GetIt.I.get<AnnonceController>();
    return ValueListenableBuilder<AppState<List<Annonces>>>(
        valueListenable: controller.annoncesListState,
        builder: (_, state, __) {
          if (state.isLoading) {
            return Center(
              child: Column(
                children: [
                  SizedBox(height: 200),
                  CircularProgressIndicator(
                      // color: primary,
                      ),
                ],
              ),
            );
          }
          if (state.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 200),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      state.errorModel!.error,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.red.shade500, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  IconButton(
                      onPressed: () {
                        controller.getAnnonces(false);
                      },
                      icon: Icon(
                        Icons.refresh,
                        size: 30,
                      ))
                ],
              ),
            );
          }
          if ((state.data ?? []).isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 200.0),
                child: Column(
                  children: [
                    Text(
                      'Aucune annonce ne correspond à vos filtres.',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    IconButton(
                        onPressed: () {
                          controller.getAnnonces(false);
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

          final List<Annonces> announcements = state.data!;

          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSearch(),
            ),
            ...announcements.map(
              (announcement) => AnnoncmentComponent(
                announcement: announcement,
              ),
            )
          ]);
        });
  }

  Widget _buildSearch() {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        // color: textfieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: const TextStyle(
            // color: white
            ),
        // cursorColor: primary,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            // color: white.withOpacity(0.2)
          ),
          border: InputBorder.none,
          hintText: "Rechercher",
          hintStyle: TextStyle(
            // color: white.withOpacity(0.2)
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
