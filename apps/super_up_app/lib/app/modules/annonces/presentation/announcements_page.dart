import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:super_up/app/modules/annonces/cores/appstate.dart';
import 'package:super_up/app/modules/annonces/datas/services/api_services.dart';
import 'package:super_up/app/modules/annonces/presentation/annoncment_component.dart';
import 'package:super_up/app/core/widgets/app_header_logo.dart';
import 'package:super_up/app/modules/annonces/providers/annonce_controller.dart';
import 'package:super_up/app/modules/annonces/providers/credit_provider.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' show Annonces;

class AnnouncementsPage extends StatefulWidget {
  final bool withBack;
  const AnnouncementsPage({super.key, this.withBack = false});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage>
    with SingleTickerProviderStateMixin {
  String? _selectedLocation;
  DateTime? _selectedDate;
  int _selectedTabIndex = 0;
  late AnimationController _floatController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    final AnnonceController controller = GetIt.I.get<AnnonceController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAnnonces(false);
      GetIt.I.get<CreditProvider>().fetchPackages();
      GetIt.I.get<CreditProvider>().getWallet();
      refreshToken();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showLocationPicker(BuildContext modalContext) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                title: const Text(
                  'Toutes les localisations',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.public, color: AppTheme.primaryGreen),
                ),
                onTap: () {
                  setState(() {
                    _selectedLocation = null;
                  });
                  Navigator.pop(context);
                  Navigator.pop(modalContext);
                },
              ),
              const Divider(height: 1),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: GetIt.I.get<AnnonceController>().citiesList,
                  builder: (context, state, child) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final cities =
                        GetIt.I.get<AnnonceController>().villes.value;
                    if (cities.isEmpty) {
                      GetIt.I.get<AnnonceController>().getCities();
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        return ListTile(
                          title: Text(city.name),
                          leading: const Icon(Icons.location_on_outlined),
                          onTap: () {
                            setState(() {
                              _selectedLocation = city.name;
                            });
                            Navigator.pop(context);
                            Navigator.pop(modalContext);
                          },
                        );
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
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text('Filtres',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _buildFilterOption(
                  icon: Icons.location_on_rounded,
                  title: 'Localisation',
                  value: _selectedLocation ?? 'Toutes',
                  onTap: () => _showLocationPicker(modalContext),
                ),
                const SizedBox(height: 16),
                _buildFilterOption(
                  icon: Icons.calendar_today_rounded,
                  title: 'Date',
                  value: _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'Toutes',
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: AppTheme.primaryGreen,
                              onPrimary: Colors.white,
                              surface: const Color(0xFF1E1E1E),
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                      if (modalContext.mounted) Navigator.pop(modalContext);
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = GetIt.I.get<AnnonceController>();
    final isDark = VThemeListener.I.isDarkMode;

    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0D0D0D),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF2D1B4E),
                  ]
                : [
                    const Color(0xFF000000),
                    const Color(0xFF1A0E2E),
                    const Color(0xFF3D2257),
                  ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating glassmorphism circles
              Positioned(
                top: -100,
                right: -100,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 280 + (30 * _floatController.value),
                      height: 280 + (30 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGreen.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -120,
                left: -80,
                child: AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Container(
                      width: 300 - (30 * _floatController.value),
                      height: 300 - (30 * _floatController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.purple.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Main content
              RefreshIndicator(
                onRefresh: () async {
                  HapticFeedback.mediumImpact();
                  await controller.getAnnonces(false);
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Premium Header with AppHeaderLogo
                    SliverToBoxAdapter(
                      child: AppHeaderLogo(
                        icon: Icons.campaign_rounded,
                        title: 'Annonces',
                        actions: [
                          if (widget.withBack)
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          // Filter button
                          GestureDetector(
                            onTap: _showFilterModal,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                color: AppTheme.primaryGreen,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tabs
                    SliverToBoxAdapter(
                      child: _buildTabsSection(context),
                    ),
                    // Search bar
                    SliverToBoxAdapter(
                      child: _buildSearchBar(context),
                    ),
                    // Announcements list
                    SliverToBoxAdapter(
                      child: ListingsBody(
                        selectedTab: _selectedTabIndex,
                        searchQuery: _searchController.text,
                        locationFilter: _selectedLocation,
                        dateFilter: _selectedDate,
                      ),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabsSection(BuildContext context) {
    final tabs = ['Toutes', 'Boostées'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = _selectedTabIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedTabIndex = index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppTheme.primaryGreen,
                              AppTheme.primaryGreen.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Rechercher une annonce...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppTheme.primaryGreen,
                  size: 22,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
    );
  }
}

class ListingsBody extends StatelessWidget {
  final int selectedTab;
  final String searchQuery;
  final String? locationFilter;
  final DateTime? dateFilter;

  const ListingsBody({
    super.key,
    this.selectedTab = 0,
    this.searchQuery = '',
    this.locationFilter,
    this.dateFilter,
  });

  List<Annonces> _filterAnnonces(List<Annonces> list) {
    var filtered = list;

    // Filter by Tab
    if (selectedTab == 1) {
      // Boostées
      filtered = filtered.where((a) => a.isBoosted).toList();
    }

    // Filter by Search
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((a) {
        return a.title.toLowerCase().contains(query) ||
            a.description.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by Location
    if (locationFilter != null) {
      filtered = filtered.where((a) => a.ville == locationFilter).toList();
    }

    // Filter by Date
    if (dateFilter != null) {
      filtered = filtered.where((a) {
        final aDate = a.createdAt;
        return aDate.year == dateFilter!.year &&
            aDate.month == dateFilter!.month &&
            aDate.day == dateFilter!.day;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final AnnonceController controller = GetIt.I.get<AnnonceController>();

    return ValueListenableBuilder<AppState<List<Annonces>>>(
      valueListenable: controller.annoncesListState,
      builder: (_, state, __) {
        if (state.isLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            ),
          );
        }

        if (state.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 60, color: Colors.red.withValues(alpha: 0.7)),
                  const SizedBox(height: 16),
                  Text(
                    state.errorModel?.error ?? 'Une erreur est survenue',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => controller.getAnnonces(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Réessayer'),
                  )
                ],
              ),
            ),
          );
        }

        final allAnnonces = state.data ?? [];
        final filteredAnnonces = _filterAnnonces(allAnnonces);

        if (filteredAnnonces.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_off_rounded,
                      size: 40,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucune annonce trouvée',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: filteredAnnonces.map((announcement) {
            return AnnoncmentComponent(
              announcement: announcement,
            );
          }).toList(),
        );
      },
    );
  }
}
