import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

class CharactersScreen extends HookConsumerWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hook tanımlamaları
    final tabController = useTabController(initialLength: 3);
    final searchController = useTextEditingController();
    final showSearchBar = useState(false);
    final currentTitle = useState(AppStrings.charactersTitle);
    
    final List<String> tabTitles = const [
      AppStrings.charactersTabAll, 
      AppStrings.charactersTabStudents, 
      AppStrings.charactersTabStaff
    ];
    
    // TabController listener için useEffect
    useEffect(() {
      void handleTabSelection() {
        if (!tabController.indexIsChanging) {
          currentTitle.value = tabTitles[tabController.index];
        }
      }
      
      tabController.addListener(handleTabSelection);
      return () => tabController.removeListener(handleTabSelection);
    }, [tabController]);
    
    // useEffect ile arama değişimini izlemek için useEffect
    useEffect(() {
      void onSearchChanged() {
        final filters = ref.read(characterFiltersProvider);
        ref.read(characterFiltersProvider.notifier).state = 
            filters.copyWith(searchQuery: searchController.text);
      }
      
      searchController.addListener(onSearchChanged);
      return () => searchController.removeListener(onSearchChanged);
    }, [searchController]);
    
    // Provider'ları izle
    final allCharactersAsync = ref.watch(allCharactersProvider);
    final hogwartsStudentsAsync = ref.watch(hogwartsStudentsProvider);
    final hogwartsStaffAsync = ref.watch(hogwartsStaffProvider);
    final filters = ref.watch(characterFiltersProvider);
    
    // Aktif filtreleri temizleme fonksiyonu
    void clearFilters() {
      ref.read(characterFiltersProvider.notifier).state = CharacterFilters();
      searchController.clear();
    }
    
    // Karakterleri filtreleme fonksiyonu
    List<Character> filterCharacters(List<Character> characters) {
      if (!filters.hasFilters()) return characters;
      return characters.where((character) => filters.matchesCharacter(character)).toList();
    }
    
    // Karakter detay sayfasına gitme fonksiyonu
    void navigateToCharacterDetail(Character character) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailScreen(characterId: character.id),
        ),
      );
    }
    
    // Filtreleme dialogu
    void showFilterDialog(List<Character> allCharacters) {
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
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: AppTheme.gryffindorRed, // Arka plan kırmızı olarak değiştirildi
                title: Text(
                  AppStrings.charactersFilterTitle,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ev filtresi
                      Text(
                        AppStrings.charactersFilterHouse,
                        style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: houses.map((house) {
                          return FilterChip(
                            label: Text(
                              house,
                              style: TextStyle(
                                color: selectedHouses.contains(house) 
                                    ? Colors.black // Seçiliyse siyah metin (turuncu üzerinde)
                                    : Colors.black87, // Seçili değilse koyu metin
                              ),
                            ),
                            selected: selectedHouses.contains(house),
                            selectedColor: AppTheme.goldAccent, // Seçili chip turuncu
                            backgroundColor: Colors.white.withOpacity(0.8), // Arka plan opak beyaz
                            checkmarkColor: Colors.black, // Tik işareti siyah
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedHouses.add(house);
                                } else {
                                  selectedHouses.remove(house);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tür filtresi
                      Text(
                        AppStrings.charactersFilterSpecies,
                        style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: species.map((specie) {
                          return FilterChip(
                            label: Text(
                              specie,
                              style: TextStyle(
                                color: selectedSpecies.contains(specie) 
                                    ? Colors.black 
                                    : Colors.black87,
                              ),
                            ),
                            selected: selectedSpecies.contains(specie),
                            selectedColor: AppTheme.goldAccent,
                            backgroundColor: Colors.white.withOpacity(0.8),
                            checkmarkColor: Colors.black,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedSpecies.add(specie);
                                } else {
                                  selectedSpecies.remove(specie);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Cinsiyet filtresi
                      Text(
                        AppStrings.charactersFilterGender,
                        style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: genders.map((gender) {
                          return FilterChip(
                            label: Text(
                              gender,
                              style: TextStyle(
                                color: selectedGenders.contains(gender) 
                                    ? Colors.black 
                                    : Colors.black87,
                              ),
                            ),
                            selected: selectedGenders.contains(gender),
                            selectedColor: AppTheme.goldAccent,
                            backgroundColor: Colors.white.withOpacity(0.8),
                            checkmarkColor: Colors.black,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedGenders.add(gender);
                                } else {
                                  selectedGenders.remove(gender);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Soy filtresi
                      Text(
                        AppStrings.charactersFilterAncestry,
                        style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ancestries.map((ancestry) {
                          return FilterChip(
                            label: Text(
                              ancestry,
                              style: TextStyle(
                                color: selectedAncestries.contains(ancestry) 
                                    ? Colors.black 
                                    : Colors.black87,
                              ),
                            ),
                            selected: selectedAncestries.contains(ancestry),
                            selectedColor: AppTheme.goldAccent,
                            backgroundColor: Colors.white.withOpacity(0.8),
                            checkmarkColor: Colors.black,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedAncestries.add(ancestry);
                                } else {
                                  selectedAncestries.remove(ancestry);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      AppStrings.apply,
                      style: TextStyle(color: AppTheme.goldAccent, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      ref.read(characterFiltersProvider.notifier).state = CharacterFilters(
                        searchQuery: currentFilters.searchQuery,
                        houses: selectedHouses,
                        species: selectedSpecies,
                        genders: selectedGenders,
                        ancestries: selectedAncestries,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      AppStrings.clear,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      clearFilters();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        leading: showSearchBar.value
            ? IconButton(
                icon: const Icon(Icons.arrow_back, size: AppDimensions.iconSizeLarge),
                onPressed: () {
                  showSearchBar.value = false;
                  clearFilters();
                },
              )
            : null,
        title: showSearchBar.value
            ? TextField(
                controller: searchController,
                style: AppTextStyles.bodyRegular(context).copyWith(color: Colors.white),
                autofocus: true,
                cursorColor: AppTheme.goldAccent,
                decoration: InputDecoration(
                  hintText: AppStrings.charactersSearchHint,
                  border: InputBorder.none,
                  hintStyle: AppTextStyles.bodyRegular(context).copyWith(color: Colors.white.withOpacity(0.7)),
                ),
              )
            : Text(currentTitle.value),
        actions: [
          // Arama butonu
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: showSearchBar.value
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: IconButton(
              icon: Icon(
                showSearchBar.value ? Icons.clear : Icons.search,
                color: showSearchBar.value ? AppTheme.goldAccent : Theme.of(context).colorScheme.onPrimary,
                size: AppDimensions.iconSizeLarge,
              ),
              onPressed: () {
                showSearchBar.value = !showSearchBar.value;
                if (!showSearchBar.value) {
                  clearFilters();
                }
              },
            ),
          ),
          
          // Filtre butonu
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: filters.hasFilters() // Sadece filtre varken arka plan rengini değiştir
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: IconButton(
              icon: Icon(
                Icons.filter_list,
                // Sadece filtre varken rengi değiştir
                color: filters.hasFilters() 
                    ? AppTheme.goldAccent 
                    : Theme.of(context).colorScheme.onPrimary,
                size: AppDimensions.iconSizeLarge,
              ),
              onPressed: () {
                // API'den tüm karakterleri aldıysak filtreleme dialogunu göster
                if (allCharactersAsync.value != null) {
                  // Eğer arama yapılıyorsa, şimdiki arama sorgusunu filtreye ekle
                  if (showSearchBar.value && searchController.text.isNotEmpty) {
                    final currentFilters = ref.read(characterFiltersProvider);
                    ref.read(characterFiltersProvider.notifier).state = 
                        currentFilters.copyWith(searchQuery: searchController.text);
                  }
                  showFilterDialog(allCharactersAsync.value!);
                }
              },
            ),
          ),
          
          // Birleştirilmiş temizleme butonu: ya arama aktifse ya da filtreler aktifse göster
          if ((showSearchBar.value && searchController.text.isNotEmpty) || filters.hasFilters())
            Container(
              margin: const EdgeInsets.only(left: 4, right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: IconButton(
                icon: const Icon(Icons.clear, size: AppDimensions.iconSizeLarge),
                color: AppTheme.goldAccent,
                onPressed: () {
                  // Hem arama metnini hem de tüm filtreleri temizle
                  searchController.clear();
                  clearFilters();
                },
                tooltip: AppStrings.charactersFilterClearTooltip,
              ),
            ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: AppStrings.charactersTabAll),
            Tab(text: AppStrings.charactersTabStudents),
            Tab(text: AppStrings.charactersTabStaff),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Tüm karakterler tab'ı
          allCharactersAsync.when(
            data: (characters) {
              final filteredCharacters = filterCharacters(characters);
              
              if (filteredCharacters.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        size: AppDimensions.iconSizeExtraLarge * 2,
                        color: AppTheme.goldAccent.withOpacity(0.6),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Text(
                        filters.hasFilters()
                            ? AppStrings.spellsSearchNotFound
                            : "Karakter bulunamadı",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.emptyListText(context),
                      ),
                      if (filters.hasFilters()) ...[
                        const SizedBox(height: AppDimensions.paddingMedium),
                        ElevatedButton.icon(
                          onPressed: clearFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text(AppStrings.clear),
                        ),
                      ],
                    ],
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () => ref.refresh(allCharactersProvider.future),
                child: CharacterList(
                  characters: filteredCharacters,
                  onCharacterTap: navigateToCharacterDetail,
                ),
              );
            },
            loading: () => const CharacterListShimmer(),
            error: (err, stack) => ErrorDisplay(
              message: AppStrings.charactersLoadingError,
              onRetry: () => ref.invalidate(allCharactersProvider),
            ),
          ),
          
          // Öğrenciler tab'ı
          hogwartsStudentsAsync.when(
            data: (characters) {
              final filteredCharacters = filterCharacters(characters);
              
              if (filteredCharacters.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        size: AppDimensions.iconSizeExtraLarge * 2,
                        color: AppTheme.goldAccent.withOpacity(0.6),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Text(
                        filters.hasFilters()
                            ? AppStrings.spellsSearchNotFound
                            : "Öğrenci bulunamadı",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.emptyListText(context),
                      ),
                      if (filters.hasFilters()) ...[
                        const SizedBox(height: AppDimensions.paddingMedium),
                        ElevatedButton.icon(
                          onPressed: clearFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text(AppStrings.clear),
                        ),
                      ],
                    ],
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () => ref.refresh(hogwartsStudentsProvider.future),
                child: CharacterList(
                  characters: filteredCharacters,
                  onCharacterTap: navigateToCharacterDetail,
                ),
              );
            },
            loading: () => const CharacterListShimmer(),
            error: (err, stack) => ErrorDisplay(
              message: AppStrings.studentsLoadingError,
              onRetry: () => ref.invalidate(hogwartsStudentsProvider),
            ),
          ),
          
          // Personel tab'ı
          hogwartsStaffAsync.when(
            data: (characters) {
              final filteredCharacters = filterCharacters(characters);
              
              if (filteredCharacters.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        size: AppDimensions.iconSizeExtraLarge * 2,
                        color: AppTheme.goldAccent.withOpacity(0.6),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Text(
                        filters.hasFilters()
                            ? AppStrings.spellsSearchNotFound
                            : "Personel bulunamadı",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.emptyListText(context),
                      ),
                      if (filters.hasFilters()) ...[
                        const SizedBox(height: AppDimensions.paddingMedium),
                        ElevatedButton.icon(
                          onPressed: clearFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text(AppStrings.clear),
                        ),
                      ],
                    ],
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () => ref.refresh(hogwartsStaffProvider.future),
                child: CharacterList(
                  characters: filteredCharacters,
                  onCharacterTap: navigateToCharacterDetail,
                ),
              );
            },
            loading: () => const CharacterListShimmer(),
            error: (err, stack) => ErrorDisplay(
              message: AppStrings.staffLoadingError,
              onRetry: () => ref.invalidate(hogwartsStaffProvider),
            ),
          ),
        ],
      ),
    );
  }
} 