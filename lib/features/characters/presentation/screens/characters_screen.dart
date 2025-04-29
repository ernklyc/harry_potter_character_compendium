import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list_shimmer.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart'; // Boyutlar import edildi
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart'; // Metin stilleri import edildi
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart'; // AppStrings import edildi

// Karakter filtreleme durumunu yönetmek için state provider
final characterFiltersProvider = StateProvider<CharacterFilters>((ref) {
  return CharacterFilters();
});

// Filtreleme için kullanılacak model
class CharacterFilters {
  final String searchQuery;
  final Set<String> houses;
  final Set<String> species;
  final Set<String> genders;
  final Set<String> ancestries;

  CharacterFilters({
    this.searchQuery = '',
    this.houses = const {},
    this.species = const {},
    this.genders = const {},
    this.ancestries = const {},
  });

  CharacterFilters copyWith({
    String? searchQuery,
    Set<String>? houses,
    Set<String>? species,
    Set<String>? genders,
    Set<String>? ancestries,
  }) {
    return CharacterFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      houses: houses ?? this.houses,
      species: species ?? this.species,
      genders: genders ?? this.genders,
      ancestries: ancestries ?? this.ancestries,
    );
  }

  bool hasFilters() {
    return searchQuery.isNotEmpty ||
           houses.isNotEmpty ||
           species.isNotEmpty ||
           genders.isNotEmpty ||
           ancestries.isNotEmpty;
  }

  bool matchesCharacter(Character character) {
    // Normalize search query once
    final lowerCaseSearchQuery = searchQuery.toLowerCase();
    
    // 1. Search Query Filter
    if (searchQuery.isNotEmpty && 
        !character.name.toLowerCase().contains(lowerCaseSearchQuery)) {
      // print('Character ${character.name} filtered out by SEARCH: ${searchQuery}'); // İsteğe bağlı arama logu
      return false; // No match for search query
    }
    
    // 2. House Filter
    if (houses.isNotEmpty) {
        if (character.house.isEmpty || !houses.contains(character.house.toLowerCase())) {
            // print('Character ${character.name} filtered out by HOUSE: ${character.house} not in ${houses}'); // İsteğe bağlı ev logu
            return false; // Character house doesn't match selected houses or is empty
        }
    }
    
    // 3. Species Filter
    if (species.isNotEmpty) {
        if (character.species.isEmpty || !species.contains(character.species.toLowerCase())) {
           // print('Character ${character.name} filtered out by SPECIES: ${character.species} not in ${species}'); // İsteğe bağlı tür logu
           return false; // Character species doesn't match or is empty
        }
    }
    
    // 4. Gender Filter
    if (genders.isNotEmpty) {
        if (character.gender.isEmpty || !genders.contains(character.gender.toLowerCase())) {
            // print('Character ${character.name} filtered out by GENDER: ${character.gender} not in ${genders}'); // İsteğe bağlı cinsiyet logu
            return false; // Character gender doesn't match or is empty
        }
    }
    
    // 5. Ancestry Filter
    if (ancestries.isNotEmpty) {
        if (character.ancestry.isEmpty || !ancestries.contains(character.ancestry.toLowerCase())) {
             // print('Character ${character.name} filtered out by ANCESTRY: ${character.ancestry} not in ${ancestries}'); // İsteğe bağlı soy logu
             return false; // Character ancestry doesn't match or is empty
        }
    }
    
    // If all active filters passed, the character is a match
    // print('Character ${character.name} MATCHED ALL FILTERS'); // Eşleşti logu
    return true;
  }
}

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentTitle = AppStrings.charactersTitle; // Başlangıç başlığı AppStrings'ten
  final List<String> _tabTitles = const [
    AppStrings.charactersTabAll, 
    AppStrings.charactersTabStudents, 
    AppStrings.charactersTabStaff
  ]; 
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  bool _showFilterDialog = false; // Filtreleme diyaloğunun açık olup olmadığını izler

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentTitle = _tabTitles[_tabController.index]; // İlk başlığı ayarla
    _tabController.addListener(_handleTabSelection); // Listener ekle
    _searchController.addListener(_onSearchChanged);
  }

  // Arama değiştiğinde çağrılır
  void _onSearchChanged() {
    final filters = ref.read(characterFiltersProvider);
    ref.read(characterFiltersProvider.notifier).state = 
        filters.copyWith(searchQuery: _searchController.text);
  }

  // Listener fonksiyonu
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Sekme değişimi henüz bitmediyse işlem yapma (opsiyonel)
    } else {
      // Sekme tamamen değiştiğinde başlığı güncelle
      setState(() {
        _currentTitle = _tabTitles[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection); // Listener'ı kaldır
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _retryLoad(WidgetRef ref, int tabIndex) {
    switch (tabIndex) {
      case 0:
        ref.invalidate(allCharactersProvider);
        break;
      case 1:
        ref.invalidate(hogwartsStudentsProvider);
        break;
      case 2:
        ref.invalidate(hogwartsStaffProvider);
        break;
    }
  }

  // Aktif filtreleri temizle
  void _clearFilters() {
    ref.read(characterFiltersProvider.notifier).state = CharacterFilters();
    _searchController.clear();
  }

  // Filtreleme diyalogunu göster
  void _showFilterDialogUI(BuildContext context, List<Character> allCharacters) {
    setState(() {
      _showFilterDialog = true; // Filtreleme diyaloğu açıldı
    });
    
    // Mevcut filtreleri al
    final currentFilters = ref.read(characterFiltersProvider);
    
    // Karakter verilerinden benzersiz değerleri topla
    final houses = allCharacters
        .where((c) => c.house.isNotEmpty)
        .map((c) => c.house.toLowerCase())
        .toSet();
    
    final species = allCharacters
        .where((c) => c.species.isNotEmpty)
        .map((c) => c.species.toLowerCase())
        .toSet();
    
    final genders = allCharacters
        .where((c) => c.gender.isNotEmpty)
        .map((c) => c.gender.toLowerCase())
        .toSet();
    
    final ancestries = allCharacters
        .where((c) => c.ancestry.isNotEmpty)
        .map((c) => c.ancestry.toLowerCase())
        .toSet();
    
    // Çalışma kopyası filtreleri
    Set<String> selectedHouses = Set.from(currentFilters.houses);
    Set<String> selectedSpecies = Set.from(currentFilters.species);
    Set<String> selectedGenders = Set.from(currentFilters.genders);
    Set<String> selectedAncestries = Set.from(currentFilters.ancestries);
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final theme = Theme.of(context);
            final dialogBackgroundColor = AppTheme.gryffindorPrimary.withOpacity(0.95);
            final accentColor = AppTheme.goldAccent;
            final primaryTextColor = Colors.white;
            final secondaryTextColor = Colors.white70;

            return AlertDialog(
              backgroundColor: dialogBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusExtraLarge)),
              title: Text(
                AppStrings.charactersFilterTitle,
                style: AppTextStyles.sectionTitle.copyWith(color: accentColor, fontSize: 20),
              ),
              contentPadding: const EdgeInsets.only(top: AppDimensions.paddingSmall, left: AppDimensions.paddingLarge, right: AppDimensions.paddingLarge, bottom: AppDimensions.paddingZero),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.paddingLarge),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterSection(
                        title: AppStrings.charactersFilterHouse,
                        options: houses,
                        selectedOptions: selectedHouses,
                        onChanged: (value) => setState(() => selectedHouses = value),
                        accentColor: accentColor,
                        primaryTextColor: theme.colorScheme.onPrimary, 
                        backgroundColor: dialogBackgroundColor,
                      ),
                      Divider(color: theme.colorScheme.onPrimary.withOpacity(0.24), thickness: AppDimensions.dividerThickness),
                      _buildFilterSection(
                        title: AppStrings.charactersFilterSpecies,
                        options: species,
                        selectedOptions: selectedSpecies,
                        onChanged: (value) => setState(() => selectedSpecies = value),
                        accentColor: accentColor,
                        primaryTextColor: theme.colorScheme.onPrimary,
                        backgroundColor: dialogBackgroundColor,
                      ),
                      Divider(color: theme.colorScheme.onPrimary.withOpacity(0.24), thickness: AppDimensions.dividerThickness),
                      _buildFilterSection(
                        title: AppStrings.charactersFilterGender,
                        options: genders,
                        selectedOptions: selectedGenders,
                        onChanged: (value) => setState(() => selectedGenders = value),
                        accentColor: accentColor,
                        primaryTextColor: theme.colorScheme.onPrimary,
                        backgroundColor: dialogBackgroundColor,
                      ),
                      Divider(color: theme.colorScheme.onPrimary.withOpacity(0.24), thickness: AppDimensions.dividerThickness),
                      _buildFilterSection(
                        title: AppStrings.charactersFilterAncestry,
                        options: ancestries,
                        selectedOptions: selectedAncestries,
                        onChanged: (value) => setState(() => selectedAncestries = value),
                        accentColor: accentColor,
                        primaryTextColor: theme.colorScheme.onPrimary,
                        backgroundColor: dialogBackgroundColor,
                      ),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge, vertical: AppDimensions.paddingMedium),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary.withOpacity(0.7)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.setState(() { // Use this.setState as we are in _CharactersScreenState
                      _showFilterDialog = false; // Filtreleme diyaloğu kapandı
                    });
                  },
                  child: Text(AppStrings.cancel, style: AppTextStyles.button(context).copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.7))),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onPrimary.withOpacity(0.7)),
                  onPressed: () {
                    // Filtreleri temizle
                    _clearFilters(); // _clearFilters will reset the provider
                    Navigator.of(context).pop();
                    this.setState(() { // Use this.setState
                      _showFilterDialog = false; // Filtreleme diyaloğu kapandı
                    });
                  },
                  child: Text(AppStrings.clear, style: AppTextStyles.button(context).copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.7))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor, // Altın rengi arkaplan
                    foregroundColor: AppTheme.gryffindorPrimary, // Kırmızı metin
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                  ),
                  onPressed: () {
                    // Filtreleri uygula
                    ref.read(characterFiltersProvider.notifier).state = CharacterFilters(
                      searchQuery: currentFilters.searchQuery, // Keep existing search query
                      houses: selectedHouses,
                      species: selectedSpecies,
                      genders: selectedGenders,
                      ancestries: selectedAncestries,
                    );
                    Navigator.of(context).pop();
                    this.setState(() { // Use this.setState
                      _showFilterDialog = false; // Filtreleme diyaloğu kapandı
                    });
                  },
                  child: Text(AppStrings.apply, style: AppTextStyles.button(context).copyWith(color: AppTheme.gryffindorPrimary)),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Dialog kapatıldığında _showFilterDialog'u false yap (widget hala mounted ise)
      if (mounted) {
          setState(() {
            _showFilterDialog = false;
          });
      }
    });
  }

  // Helper widget for filter sections to avoid repetition
  Widget _buildFilterSection({
    required String title,
    required Set<String> options,
    required Set<String> selectedOptions,
    required Function(Set<String>) onChanged,
    required Color accentColor,
    required Color primaryTextColor,
    required Color backgroundColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
          child: Text(
            title, 
            style: AppTextStyles.sectionTitle.copyWith(color: accentColor, fontSize: 16)
          ),
        ),
        _buildFilterChips(
          options,
          selectedOptions,
          onChanged,
          accentColor,
          primaryTextColor,
          backgroundColor,
        ),
      ],
    );
  }

  // Çoklu seçim filtreleri için chip'ler
  Widget _buildFilterChips(
    Set<String> options, 
    Set<String> selectedOptions, 
    Function(Set<String>) onChanged,
    Color accentColor,      // Added theme colors
    Color primaryTextColor, // Added theme colors
    Color backgroundColor,  // Added theme colors
  ) {
    // Ensure options are not empty before creating chips
    if (options.isEmpty) {
        return Text(
          AppStrings.filterOptionsNotFound,
          style: AppTextStyles.bodySmall(context).copyWith(fontStyle: FontStyle.italic, color: Colors.white54)
        );
    }
    return Wrap(
      spacing: AppDimensions.paddingSmall,
      runSpacing: AppDimensions.paddingExtraSmall,
      children: options.map((option) {
        final capitalizedOption = option.isNotEmpty
            ? option.substring(0, 1).toUpperCase() + option.substring(1)
            : option;
        final isSelected = selectedOptions.contains(option);

        return FilterChip(
          label: Text(capitalizedOption),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = Set<String>.from(selectedOptions);
            if (selected) {
              newSelection.add(option);
            } else {
              newSelection.remove(option);
            }
            onChanged(newSelection);
          },
          padding: AppDimensions.chipPadding,
          backgroundColor: backgroundColor.withOpacity(0.5), // Hafif arkaplan
          labelStyle: AppTextStyles.filterChip(context, isSelected),
          selectedColor: accentColor, // Seçili arkaplan altın rengi
          checkmarkColor: primaryTextColor, // Checkmark rengi Beyaz
          shape: StadiumBorder(side: BorderSide(color: isSelected ? accentColor : Colors.white30, width: 1.0)),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allCharacters = ref.watch(allCharactersProvider);
    final hogwartsStudents = ref.watch(hogwartsStudentsProvider);
    final hogwartsStaff = ref.watch(hogwartsStaffProvider);
    final filters = ref.watch(characterFiltersProvider);
    
    void navigateToCharacterDetail(Character character) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailScreen(characterId: character.id),
        ),
      );
    }

    // Arama ve filtrelemeye göre karakterleri filtrele
    List<Character> _filterCharacters(List<Character> characters) {
      if (!filters.hasFilters()) return characters;
      return characters.where((character) => filters.matchesCharacter(character)).toList();
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: _showSearchBar 
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, size: AppDimensions.iconSizeLarge),
                  onPressed: () {
                    setState(() {
                      _showSearchBar = false;
                    });
                    // Aramayı temizle
                    _searchController.clear();
                  },
                )
              : null,
          title: _showSearchBar 
              ? TextField(
                  controller: _searchController,
                  style: AppTextStyles.bodyRegular(context).copyWith(color: Colors.white),
                  cursorColor: AppTheme.goldAccent,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: AppStrings.charactersSearchHint,
                    border: InputBorder.none,
                    hintStyle: AppTextStyles.bodyRegular(context).copyWith(color: Colors.white.withOpacity(0.7)),
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                       opacity: animation,
                       child: child,
                     );
                  },
                  child: Text(
                    _currentTitle,
                    key: ValueKey<String>(_currentTitle),
                  ),
                ),
          actions: [
            // Arama butonu
            Container(
              decoration: BoxDecoration(
                color: _showSearchBar
                    ? Colors.white.withOpacity(0.15) // Arama aktifken beyaz arkaplan
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: IconButton(
                // İkon rengi arama durumuna göre değişiyor
                icon: Icon(_showSearchBar ? Icons.clear : Icons.search, color: _showSearchBar ? AppTheme.goldAccent : Colors.white, size: AppDimensions.iconSizeLarge),
                onPressed: () {
                  setState(() {
                    _showSearchBar = !_showSearchBar;
                    if (!_showSearchBar) {
                      _searchController.clear();
                    }
                  });
                },
              ),
            ),
            // Filtreleme butonu
            Container(
              decoration: BoxDecoration(
                color: filters.hasFilters() || _showFilterDialog
                    ? Colors.white.withOpacity(0.15) // Aktif filtre varsa veya dialog açıksa beyaz arkaplan
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list, size: AppDimensions.iconSizeLarge),
                onPressed: () {
                  // API'den tüm karakterleri alma durumuna göre filtreleme diyalogunu göster
                  if (allCharacters.hasValue) {
                    _showFilterDialogUI(context, allCharacters.value!);
                  }
                },
              ),
            ),
            // Aktif filtreler varsa, temizleme butonu
            if (filters.hasFilters())
              IconButton(
                icon: const Icon(Icons.close, size: AppDimensions.iconSizeLarge),
                onPressed: _clearFilters,
                tooltip: AppStrings.charactersFilterClearTooltip,
              ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.gryffindorPrimary.withOpacity(0.9),
                  AppTheme.gryffindorPrimary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppTheme.goldAccent, 
            unselectedLabelColor: Colors.white, 
            indicator: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.0),
            ),
            tabs: const [
              Tab(icon: Icon(Icons.people_alt_outlined), text: AppStrings.charactersTabAll),
              Tab(icon: Icon(Icons.school_outlined), text: AppStrings.charactersTabStudents),
              Tab(icon: Icon(Icons.work_outline), text: AppStrings.charactersTabStaff),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            allCharacters.when(
              data: (characters) {
                final filteredCharacters = _filterCharacters(characters);
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(allCharactersProvider.future),
                  child: CharacterList(
                    characters: filteredCharacters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
                );
              },
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => RefreshIndicator(
                onRefresh: () => ref.refresh(allCharactersProvider.future),
                child: ErrorDisplay(
                  message: AppStrings.charactersLoadingError,
                  onRetry: () => _retryLoad(ref, 0),
                ),
              ),
            ),
            
            hogwartsStudents.when(
              data: (characters) {
                final filteredCharacters = _filterCharacters(characters);
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(hogwartsStudentsProvider.future),
                  child: CharacterList(
                    characters: filteredCharacters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
                );
              },
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => RefreshIndicator(
                onRefresh: () => ref.refresh(hogwartsStudentsProvider.future),
                child: ErrorDisplay(
                  message: AppStrings.studentsLoadingError,
                  onRetry: () => _retryLoad(ref, 1),
                ),
              ),
            ),
            
            hogwartsStaff.when(
              data: (characters) {
                final filteredCharacters = _filterCharacters(characters);
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(hogwartsStaffProvider.future),
                  child: CharacterList(
                    characters: filteredCharacters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
                );
              },
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => RefreshIndicator(
                onRefresh: () => ref.refresh(hogwartsStaffProvider.future),
                child: ErrorDisplay(
                  message: AppStrings.staffLoadingError,
                  onRetry: () => _retryLoad(ref, 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 