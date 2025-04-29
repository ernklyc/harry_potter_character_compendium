import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list_shimmer.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';

// Karakter filtreleme durumunu yönetmek için state provider
final characterFiltersProvider = StateProvider<CharacterFilters>((ref) {
  return CharacterFilters();
});

// Filtreleme için kullanılacak model
class CharacterFilters {
  final String searchQuery;
  final Set<String> houses;
  final bool? isStudent;
  final bool? isStaff;
  final bool? isWizard;
  final Set<String> species;
  final Set<String> genders;
  final Set<String> ancestries;

  CharacterFilters({
    this.searchQuery = '',
    this.houses = const {},
    this.isStudent,
    this.isStaff,
    this.isWizard,
    this.species = const {},
    this.genders = const {},
    this.ancestries = const {},
  });

  CharacterFilters copyWith({
    String? searchQuery,
    Set<String>? houses,
    bool? isStudent,
    bool? isStaff,
    bool? isWizard,
    Set<String>? species,
    Set<String>? genders,
    Set<String>? ancestries,
  }) {
    return CharacterFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      houses: houses ?? this.houses,
      isStudent: isStudent ?? this.isStudent,
      isStaff: isStaff ?? this.isStaff,
      isWizard: isWizard ?? this.isWizard,
      species: species ?? this.species,
      genders: genders ?? this.genders,
      ancestries: ancestries ?? this.ancestries,
    );
  }

  bool hasFilters() {
    return searchQuery.isNotEmpty || 
           houses.isNotEmpty || 
           isStudent != null || 
           isStaff != null || 
           isWizard != null || 
           species.isNotEmpty || 
           genders.isNotEmpty || 
           ancestries.isNotEmpty;
  }

  bool matchesCharacter(Character character) {
    // Arama sorgusuna göre filtreleme
    if (searchQuery.isNotEmpty && 
        !character.name.toLowerCase().contains(searchQuery.toLowerCase())) {
      return false;
    }
    
    // Eve göre filtreleme
    if (houses.isNotEmpty && 
        character.house.isNotEmpty && 
        !houses.contains(character.house.toLowerCase())) {
      return false;
    }
    
    // Öğrenci durumuna göre filtreleme
    if (isStudent != null && character.hogwartsStudent != isStudent) {
      return false;
    }
    
    // Personel durumuna göre filtreleme
    if (isStaff != null && character.hogwartsStaff != isStaff) {
      return false;
    }
    
    // Büyücü durumuna göre filtreleme
    if (isWizard != null && character.wizard != isWizard) {
      return false;
    }
    
    // Türe göre filtreleme
    if (species.isNotEmpty && 
        character.species.isNotEmpty && 
        !species.contains(character.species.toLowerCase())) {
      return false;
    }
    
    // Cinsiyete göre filtreleme
    if (genders.isNotEmpty && 
        character.gender.isNotEmpty && 
        !genders.contains(character.gender.toLowerCase())) {
      return false;
    }
    
    // Soy durumuna göre filtreleme
    if (ancestries.isNotEmpty && 
        character.ancestry.isNotEmpty && 
        !ancestries.contains(character.ancestry.toLowerCase())) {
      return false;
    }
    
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
  String _currentTitle = "Karakterler"; // Başlangıç başlığı
  final List<String> _tabTitles = const ["Tümü", "Ögrenciler", "Personel", "Gryffindor"]; // Sekme başlıkları
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  bool _showFilterDialog = false; // Filtreleme diyaloğunun açık olup olmadığını izler

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      case 3:
        ref.invalidate(houseCharactersProvider('gryffindor'));
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
    bool? isStudent = currentFilters.isStudent;
    bool? isStaff = currentFilters.isStaff;
    bool? isWizard = currentFilters.isWizard;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Karakterleri Filtrele'),
              contentPadding: const EdgeInsets.only(top: 16),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Durum', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildTriStateFilter(
                        'Ögrenci', 
                        isStudent, 
                        (value) => setState(() => isStudent = value)
                      ),
                      _buildTriStateFilter(
                        'Personel', 
                        isStaff, 
                        (value) => setState(() => isStaff = value)
                      ),
                      _buildTriStateFilter(
                        'Büyücü', 
                        isWizard, 
                        (value) => setState(() => isWizard = value)
                      ),
                      
                      const Divider(),
                      const Text('Ev', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildFilterChips(
                        houses, 
                        selectedHouses, 
                        (value) => setState(() => selectedHouses = value)
                      ),
                      
                      const Divider(),
                      const Text('Tür', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildFilterChips(
                        species, 
                        selectedSpecies, 
                        (value) => setState(() => selectedSpecies = value)
                      ),
                      
                      const Divider(),
                      const Text('Cinsiyet', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildFilterChips(
                        genders, 
                        selectedGenders, 
                        (value) => setState(() => selectedGenders = value)
                      ),
                      
                      const Divider(),
                      const Text('Soy', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildFilterChips(
                        ancestries, 
                        selectedAncestries, 
                        (value) => setState(() => selectedAncestries = value)
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _showFilterDialog = false; // Filtreleme diyaloğu kapandı
                    });
                  },
                  child: const Text('Iptal'),
                ),
                TextButton(
                  onPressed: () {
                    // Filtreleri temizle
                    _clearFilters();
                    Navigator.of(context).pop();
                    setState(() {
                      _showFilterDialog = false; // Filtreleme diyaloğu kapandı
                    });
                  },
                  child: const Text('Temizle'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Filtreleri uygula
                    ref.read(characterFiltersProvider.notifier).state = CharacterFilters(
                      searchQuery: currentFilters.searchQuery,
                      houses: selectedHouses,
                      isStudent: isStudent,
                      isStaff: isStaff,
                      isWizard: isWizard,
                      species: selectedSpecies,
                      genders: selectedGenders,
                      ancestries: selectedAncestries,
                    );
                    Navigator.of(context).pop();
                    this.setState(() {
                      _showFilterDialog = false; // Filtreleme diyaloğu kapandı
                    });
                  },
                  child: const Text('Uygula'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Dialog kapatıldığında _showFilterDialog'u false yap
      setState(() {
        _showFilterDialog = false;
      });
    });
  }

  // Üç durumlu filtre (evet/hayır/önemsiz)
  Widget _buildTriStateFilter(String label, bool? value, Function(bool?) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(label),
        ),
        Switch(
          value: value ?? false,
          onChanged: (newValue) {
            if (value == null) {
              onChanged(true);
            } else if (value == true) {
              onChanged(false);
            } else {
              onChanged(null);
            }
          },
        ),
        SizedBox(width: 8),
        Text(value == null ? 'Fark Etmez' : (value ? 'Evet' : 'Hayır')),
      ],
    );
  }

  // Çoklu seçim filtreleri için chip'ler
  Widget _buildFilterChips(Set<String> options, Set<String> selectedOptions, Function(Set<String>) onChanged) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: options.map((option) {
        final capitalizedOption = option.isNotEmpty 
            ? option.substring(0, 1).toUpperCase() + option.substring(1) 
            : option;
            
        return FilterChip(
          label: Text(capitalizedOption),
          selected: selectedOptions.contains(option),
          onSelected: (selected) {
            final newSelection = Set<String>.from(selectedOptions);
            if (selected) {
              newSelection.add(option);
            } else {
              newSelection.remove(option);
            }
            onChanged(newSelection);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allCharacters = ref.watch(allCharactersProvider);
    final hogwartsStudents = ref.watch(hogwartsStudentsProvider);
    final hogwartsStaff = ref.watch(hogwartsStaffProvider);
    final gryffindorCharacters = ref.watch(houseCharactersProvider('gryffindor'));
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: _showSearchBar 
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
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
                  decoration: const InputDecoration(
                    hintText: 'Karakter Ara...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  autofocus: true,
                  cursorColor: Colors.white,
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
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
          actions: [
            // Arama butonu
            IconButton(
              icon: Icon(_showSearchBar ? Icons.clear : Icons.search),
              onPressed: () {
                setState(() {
                  _showSearchBar = !_showSearchBar;
                  if (!_showSearchBar) {
                    _searchController.clear();
                  }
                });
              },
            ),
            // Filtreleme butonu
            Container(
              decoration: BoxDecoration(
                color: filters.hasFilters() || _showFilterDialog
                    ? Colors.white.withOpacity(0.15) // Aktif filtre varsa veya dialog açıksa beyaz arkaplan
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list),
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
                icon: const Icon(Icons.clear_all),
                onPressed: _clearFilters,
                tooltip: 'Filtreleri Temizle',
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
            labelColor: AppTheme.goldAccent, // Gryffindor altın rengi
            unselectedLabelColor: Colors.white, // Seçili olmayan beyaz
            indicator: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // Hafif beyaz arka plan
              borderRadius: BorderRadius.circular(8.0), // Yuvarlak köşeler
            ),
            tabs: const [
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'Tümü'),
              Tab(icon: Icon(Icons.school_outlined), text: 'Ögrenciler'),
              Tab(icon: Icon(Icons.work_outline), text: 'Personel'),
              Tab(icon: Icon(Icons.shield_outlined), text: 'Gryffindor'),
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
                  message: 'Karakterler yüklenemedi.',
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
                  message: 'Ögrenciler yüklenemedi.',
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
                  message: 'Personel yüklenemedi.',
                  onRetry: () => _retryLoad(ref, 2),
                ),
              ),
            ),
            
            gryffindorCharacters.when(
              data: (characters) {
                final filteredCharacters = _filterCharacters(characters);
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(houseCharactersProvider('gryffindor').future),
                  child: CharacterList(
                    characters: filteredCharacters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
                );
              },
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => RefreshIndicator(
                onRefresh: () => ref.refresh(houseCharactersProvider('gryffindor').future),
                child: ErrorDisplay(
                  message: 'Gryffindor üyeleri yüklenemedi.',
                  onRetry: () => _retryLoad(ref, 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 