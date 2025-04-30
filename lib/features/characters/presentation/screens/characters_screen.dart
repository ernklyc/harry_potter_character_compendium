import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list_shimmer.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart';
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';
import 'package:harry_potter_character_compendium/core/navigation/app_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

final characterFiltersProvider = StateProvider<CharacterFilters>((ref) {
  return CharacterFilters();
});

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
    final lowerCaseSearchQuery = searchQuery.toLowerCase();
    if (searchQuery.isNotEmpty && 
        !character.name.toLowerCase().contains(lowerCaseSearchQuery)) {
      return false;
    }
    if (houses.isNotEmpty) {
        if (character.house.isEmpty || !houses.contains(character.house.toLowerCase())) {
            return false;
        }
    }
    if (species.isNotEmpty) {
        if (character.species.isEmpty || !species.contains(character.species.toLowerCase())) {
           return false;
        }
    }
    if (genders.isNotEmpty) {
        if (character.gender.isEmpty || !genders.contains(character.gender.toLowerCase())) {
            return false;
        }
    }
    if (ancestries.isNotEmpty) {
        if (character.ancestry.isEmpty || !ancestries.contains(character.ancestry.toLowerCase())) {
             return false;
        }
    }
    return true;
  }
}

class CharactersScreen extends HookConsumerWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final searchController = useTextEditingController();
    final showSearchBar = useState(false);
    final currentTabIndex = useState(0);
    final theme = Theme.of(context);

    final List<String> tabTitles = [
      AppStrings.charactersTabAll, 
      AppStrings.charactersTabStudents, 
      AppStrings.charactersTabStaff
    ];

    useEffect(() {
      void updateCurrentTab() {
        if (!tabController.indexIsChanging) {
          currentTabIndex.value = tabController.index;
        }
      }
      tabController.addListener(updateCurrentTab);
      return () => tabController.removeListener(updateCurrentTab);
    }, [tabController]);

    useEffect(() {
      void onSearchChanged() {
        final filters = ref.read(characterFiltersProvider);
        if (filters.searchQuery != searchController.text) {
          ref.read(characterFiltersProvider.notifier).state =
              filters.copyWith(searchQuery: searchController.text);
        }
      }
      searchController.addListener(onSearchChanged);
      return () => searchController.removeListener(onSearchChanged);
    }, [searchController, ref]);

    final allCharactersAsync = ref.watch(allCharactersProvider);
    final hogwartsStudentsAsync = ref.watch(hogwartsStudentsProvider);
    final hogwartsStaffAsync = ref.watch(hogwartsStaffProvider);
    final filters = ref.watch(characterFiltersProvider);

    void clearFilters() {
      ref.read(characterFiltersProvider.notifier).state = CharacterFilters();
      searchController.clear();
    }

    List<Character> filterCharacters(List<Character> characters) {
      if (!filters.hasFilters()) return characters;
      return characters.where((character) => filters.matchesCharacter(character)).toList();
    }

    void navigateToCharacterDetail(Character character) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailScreen(characterId: character.id),
        ),
      );
    }

    void showFilterDialog(List<Character> allCharacters) {
      final currentFilters = ref.read(characterFiltersProvider);
      final houses = allCharacters.where((c) => c.house.isNotEmpty).map((c) => c.house.toLowerCase()).toSet();
      final species = allCharacters.where((c) => c.species.isNotEmpty).map((c) => c.species.toLowerCase()).toSet();
      final genders = allCharacters.where((c) => c.gender.isNotEmpty).map((c) => c.gender.toLowerCase()).toSet();
      final ancestries = allCharacters.where((c) => c.ancestry.isNotEmpty).map((c) => c.ancestry.toLowerCase()).toSet();

      Set<String> selectedHouses = Set.from(currentFilters.houses);
      Set<String> selectedSpecies = Set.from(currentFilters.species);
      Set<String> selectedGenders = Set.from(currentFilters.genders);
      Set<String> selectedAncestries = Set.from(currentFilters.ancestries);

      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
            backgroundColor: theme.colorScheme.surface,
            titlePadding: const EdgeInsets.fromLTRB(AppDimensions.paddingLarge, AppDimensions.paddingLarge, AppDimensions.paddingLarge, AppDimensions.paddingSmall),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall, vertical: AppDimensions.paddingMedium),
            actionsPadding: const EdgeInsets.fromLTRB(AppDimensions.paddingMedium, 0, AppDimensions.paddingMedium, AppDimensions.paddingSmall),
            title: Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: AppTheme.goldAccent),
                const SizedBox(width: AppDimensions.paddingSmall),
                Text(
                  AppStrings.charactersFilterTitle,
                  style: theme.textTheme.titleLarge?.copyWith(color: AppTheme.goldAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium - AppDimensions.paddingSmall),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilterSection(context, theme, AppStrings.charactersFilterHouse, houses, selectedHouses, setState),
                        _buildFilterSection(context, theme, AppStrings.charactersFilterSpecies, species, selectedSpecies, setState),
                        _buildFilterSection(context, theme, AppStrings.charactersFilterGender, genders, selectedGenders, setState),
                        _buildFilterSection(context, theme, AppStrings.charactersFilterAncestry, ancestries, selectedAncestries, setState),
                      ],
                    ),
                  ),
                );
              }
            ),
            actions: [
              TextButton(
                child: Text(
                  'Tümünü Temizle',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                onPressed: () {
                  clearFilters(); 
                  Navigator.of(dialogContext).pop();
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, size: AppDimensions.iconSizeSmall),
                label: Text(AppStrings.apply),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall)),
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium, vertical: AppDimensions.paddingSmall / 2),
                  textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  ref.read(characterFiltersProvider.notifier).state = CharacterFilters(
                    searchQuery: currentFilters.searchQuery,
                    houses: selectedHouses,
                    species: selectedSpecies,
                    genders: selectedGenders,
                    ancestries: selectedAncestries,
                  );
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
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
                   final currentFilters = ref.read(characterFiltersProvider);
                   if (currentFilters.searchQuery.isNotEmpty) {
                     ref.read(characterFiltersProvider.notifier).state = currentFilters.copyWith(searchQuery: '');
                     searchController.clear();
                   }
                   },
                 )
               : IconButton(
                   icon: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(
                       color: AppTheme.goldAccent,
                       borderRadius: BorderRadius.circular(8),
                       border: Border.all(color: Colors.white, width: 1),
                     ),
                     child: Text(
                       AppStrings.getCurrentLanguage().toUpperCase(),
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: AppTheme.gryffindorRed,
                         fontSize: 14,
                       ),
                     ),
                   ),
                   onPressed: () {
                     final newLang = AppStrings.getCurrentLanguage() == 'tr' ? 'en' : 'tr';
                     AppStrings.setLanguage(newLang);
                     ref.read(currentLanguageProvider.notifier).state = newLang;
                     ref.invalidate(allCharactersProvider);
                     ref.invalidate(hogwartsStudentsProvider);
                     ref.invalidate(hogwartsStaffProvider);
                   },
                   tooltip: AppStrings.getCurrentLanguage() == 'tr' 
                       ? 'Switch to English' 
                       : 'Türkçe\'ye Geç',
                 ),
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
             : Text(tabTitles[currentTabIndex.value]),
           actions: [
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
                   final currentFilters = ref.read(characterFiltersProvider);
                   if (currentFilters.searchQuery.isNotEmpty) {
                     ref.read(characterFiltersProvider.notifier).state = currentFilters.copyWith(searchQuery: '');
                     searchController.clear();
                   }
                 }
               },
             ),
           ),
           Container(
             margin: const EdgeInsets.symmetric(horizontal: 4),
             decoration: BoxDecoration(
               color: filters.houses.isNotEmpty || filters.species.isNotEmpty || filters.genders.isNotEmpty || filters.ancestries.isNotEmpty
                   ? Colors.white.withOpacity(0.15)
                   : Colors.transparent,
               borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
             ),
             child: IconButton(
               icon: Icon(
                 Icons.filter_list,
                 color: filters.houses.isNotEmpty || filters.species.isNotEmpty || filters.genders.isNotEmpty || filters.ancestries.isNotEmpty 
                     ? AppTheme.goldAccent 
                     : Theme.of(context).colorScheme.onPrimary,
                 size: AppDimensions.iconSizeLarge,
               ),
               onPressed: () {
                 if (allCharactersAsync.value != null) {
                   if (showSearchBar.value && searchController.text.isNotEmpty) {
                     final currentFilters = ref.read(characterFiltersProvider);
                     ref.read(characterFiltersProvider.notifier).state = 
                         currentFilters.copyWith(searchQuery: searchController.text);
                   }
                   showFilterDialog(allCharactersAsync.value!);
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Veri yükleniyor, lütfen bekleyin...'), duration: 1.seconds)
                   );
                 }
               },
             ),
           ),
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
                   clearFilters(); 
                 },
                 tooltip: AppStrings.charactersFilterClearTooltip,
               ),
             ),
         ],
           bottom: TabBar(
           controller: tabController,
             tabs: [
             Tab(icon: Icon(Icons.people)),
             Tab(icon: Icon(Icons.school)),
             Tab(icon: Icon(Icons.work)),
             ],
           ),
         ),
      body: TabBarView(
        controller: tabController,
        children: [
          _buildCharacterList(context, ref, allCharactersProvider, AppStrings.noCharactersFound, filters, clearFilters, filterCharacters, navigateToCharacterDetail),
          _buildCharacterList(context, ref, hogwartsStudentsProvider, AppStrings.noStudentsFound, filters, clearFilters, filterCharacters, navigateToCharacterDetail),
          _buildCharacterList(context, ref, hogwartsStaffProvider, AppStrings.noStaffFound, filters, clearFilters, filterCharacters, navigateToCharacterDetail),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context, ThemeData theme, String title, Set<String> options, Set<String> selectedOptions, StateSetter setState) {
     if (options.isEmpty) return const SizedBox.shrink();

     return Padding(
       padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             title,
             style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
           ),
           const SizedBox(height: AppDimensions.paddingSmall),
           Wrap(
             spacing: AppDimensions.paddingSmall - 2,
             runSpacing: AppDimensions.paddingSmall - 4,
             children: options.map((option) {
               final isSelected = selectedOptions.contains(option);
               return FilterChip(
                 label: Text(option[0].toUpperCase() + option.substring(1)),
                 selected: isSelected,
                 onSelected: (selected) {
                   setState(() {
                     if (selected) {
                       selectedOptions.add(option);
                     } else {
                       selectedOptions.remove(option);
                     }
                   });
                 },
                 backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                 selectedColor: AppTheme.goldAccent.withOpacity(0.3),
                 checkmarkColor: AppTheme.goldAccent,
                 labelStyle: TextStyle(
                    color: isSelected ? AppTheme.goldAccent : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                 ),
                 shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    side: BorderSide(
                      color: isSelected ? AppTheme.goldAccent : theme.dividerColor,
                      width: isSelected ? 1.5 : 1.0,
                    )
                 ),
                 padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSmall + 2, vertical: AppDimensions.paddingSmall -2),
               );
             }).toList(),
           ),
         ],
       ),
     );
   }

  Widget _buildCharacterList(
      BuildContext context,
      WidgetRef ref,
      FutureProvider<List<Character>> provider,
      String emptyMessage,
      CharacterFilters filters,
      VoidCallback clearFilters,
      List<Character> Function(List<Character>) filterFunction,
      void Function(Character) onCharacterTap,
    ) {
    final asyncData = ref.watch(provider);
    final theme = Theme.of(context);

    return asyncData.when(
      data: (characters) {
        final filteredCharacters = filterFunction(characters);

        if (filteredCharacters.isEmpty) {
          return Center(
             child: Padding(
               padding: AppDimensions.pagePadding,
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
                         ? 'Filtrelerle eşleşen karakter bulunamadı.'
                         : emptyMessage,
                     textAlign: TextAlign.center,
                     style: AppTextStyles.emptyListText(context),
                   ),
                   if (filters.hasFilters()) ...[
                     const SizedBox(height: AppDimensions.paddingMedium),
                     ElevatedButton.icon(
                       onPressed: clearFilters,
                       icon: const Icon(Icons.clear_all),
                       label: Text(AppStrings.clear),
                     ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
                   ],
                 ],
               ),
             ),
           );
        }

        return RefreshIndicator(
          onRefresh: () => ref.refresh(provider.future),
          color: AppTheme.goldAccent,
          backgroundColor: theme.colorScheme.primary,
          child: CharacterList(
            controller: charactersScrollController,
            characters: filteredCharacters,
            onCharacterTap: onCharacterTap,
          ),
        );
      },
      loading: () => const CharacterListShimmer(),
      error: (err, stack) => ErrorDisplay(
         message: "${AppStrings.charactersLoadingError} (${emptyMessage})", 
         onRetry: () => ref.invalidate(provider),
       ),
    );
  }
} 