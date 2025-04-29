import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/spells/domain/providers/spells_providers.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_card.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_list_shimmer.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';
import 'package:google_fonts/google_fonts.dart';

// Büyü filtreleme durumunu yönetmek için state provider
final spellFiltersProvider = StateProvider<SpellFilters>((ref) {
  return SpellFilters();
});

// Filtreleme için kullanılacak model
class SpellFilters {
  final String searchQuery;

  SpellFilters({
    this.searchQuery = '',
  });

  SpellFilters copyWith({
    String? searchQuery,
  }) {
    return SpellFilters(
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool hasFilters() {
    return searchQuery.isNotEmpty;
  }

  bool matchesSpell(Spell spell) {
    // Arama sorgusuna göre filtreleme
    if (searchQuery.isNotEmpty) {
      // Büyü adında arama
      final nameMatch = spell.name.toLowerCase().contains(searchQuery.toLowerCase());
      // Büyü açıklamasında arama
      final descMatch = spell.description.toLowerCase().contains(searchQuery.toLowerCase());
      
      // İsim veya açıklamada eşleşme yoksa false döndür
      if (!nameMatch && !descMatch) {
        return false;
      }
    }
    
    return true;
  }
}

class SpellsScreen extends ConsumerStatefulWidget {
  const SpellsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SpellsScreen> createState() => _SpellsScreenState();
}

class _SpellsScreenState extends ConsumerState<SpellsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  // Arama değiştiğinde çağrılır
  void _onSearchChanged() {
    final filters = ref.read(spellFiltersProvider);
    ref.read(spellFiltersProvider.notifier).state = 
        filters.copyWith(searchQuery: _searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Aktif filtreleri temizle
  void _clearFilters() {
    ref.read(spellFiltersProvider.notifier).state = SpellFilters();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final allSpellsAsync = ref.watch(allSpellsProvider);
    final filters = ref.watch(spellFiltersProvider);

    // Arama ve filtrelemeye göre büyüleri filtrele
    List<Spell> _filterSpells(List<Spell> spells) {
      if (!filters.hasFilters()) return spells;
      return spells.where((spell) => filters.matchesSpell(spell)).toList();
    }

    return Scaffold(
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
                decoration: InputDecoration(
                  hintText: 'Büyü Ara...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                  suffixIcon: _searchController.text.isNotEmpty 
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.white70, size: 20),
                          onPressed: () => _searchController.clear(),
                        ) 
                      : null,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                cursorColor: AppTheme.goldAccent,
              )
            : Text(
                'Büyüler',
                style: GoogleFonts.cinzelDecorative(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          // Arama butonu
          Container(
            decoration: BoxDecoration(
              color: _showSearchBar
                  ? Colors.white.withOpacity(0.15) // Arama aktifken beyaz arkaplan
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: Icon(
                _showSearchBar ? Icons.clear : Icons.search,
                color: _showSearchBar ? AppTheme.goldAccent : Colors.white,
              ),
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
          // Aktif filtreler varsa, temizleme butonu
          if (filters.hasFilters())
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppTheme.goldAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: AppTheme.goldAccent.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.clear_all,
                  color: Colors.white,
                ),
                onPressed: _clearFilters,
                tooltip: 'Filtreleri Temizle',
              ),
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
      ),
      body: allSpellsAsync.when(
        data: (spells) {
          final filteredSpells = _filterSpells(spells);
          
          if (filteredSpells.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(allSpellsProvider.future),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_fix_off,
                        size: 64,
                        color: AppTheme.goldAccent.withOpacity(0.6),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        filters.hasFilters() 
                            ? 'Arama kriterlerinize uygun büyü bulunamadı.' 
                            : 'Gösterilecek büyü bulunamadı.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cinzelDecorative(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      if (filters.hasFilters()) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _clearFilters,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Filtreleri Temizle'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.gryffindorPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: AppTheme.goldAccent,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () => ref.refresh(allSpellsProvider.future),
            color: AppTheme.goldAccent,
            backgroundColor: AppTheme.gryffindorPrimary,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              itemCount: filteredSpells.length,
              itemBuilder: (context, index) {
                final spell = filteredSpells[index];
                return SpellCard(spell: spell)
                    .animate()
                    .fadeIn(duration: 200.ms, delay: (30 * index).ms)
                    .slideY(begin: 0.05, duration: 200.ms, curve: Curves.easeOut);
              },
            ),
          );
        },
        loading: () => const SpellListShimmer(),
        error: (err, stack) => RefreshIndicator(
          onRefresh: () => ref.refresh(allSpellsProvider.future),
          color: AppTheme.goldAccent,
          backgroundColor: AppTheme.gryffindorPrimary,
          child: ErrorDisplay(
            message: 'Büyüler yüklenirken bir hata oluştu.',
            onRetry: () => ref.invalidate(allSpellsProvider),
          ),
        ),
      ),
    );
  }
} 