import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart';
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/spells/domain/providers/spells_providers.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_card.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_list_shimmer.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';


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

// ConsumerStatefulWidget yerine HookConsumerWidget kullanıldı
class SpellsScreen extends HookConsumerWidget { 
  const SpellsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hook'lar build metodunun başında tanımlanmalı
    final searchController = useTextEditingController();
    final showSearchBar = useState(false);

    // Provider'lar ve tema izleniyor
    final allSpellsAsync = ref.watch(allSpellsProvider);
    final filters = ref.watch(spellFiltersProvider);
    final theme = Theme.of(context);

    // Arama metni değişimini dinlemek için useEffect hook'u
    useEffect(() {
      void onSearchChanged() {
        final currentFilters = ref.read(spellFiltersProvider);
        // Sadece gerçekten değiştiyse provider'ı güncelle
        if (currentFilters.searchQuery != searchController.text) {
          ref.read(spellFiltersProvider.notifier).state =
              currentFilters.copyWith(searchQuery: searchController.text);
        }
      }
      searchController.addListener(onSearchChanged);
      // Listener'ı temizle
      return () => searchController.removeListener(onSearchChanged);
    }, [searchController, ref]); // ref bağımlılıklara eklendi

    // Yardımcı fonksiyonlar (build metodu içinde)
    List<Spell> filterSpells(List<Spell> spells) {
      if (!filters.hasFilters()) return spells;
      return spells.where((spell) => filters.matchesSpell(spell)).toList();
    }

    void clearFilters() {
      ref.read(spellFiltersProvider.notifier).state = SpellFilters();
      searchController.clear();
      // Arama çubuğu açıksa kapatılabilir (isteğe bağlı)
      // showSearchBar.value = false; 
    }

    return Scaffold(
      appBar: AppBar(
        leading: showSearchBar.value
            ? IconButton(
                icon: const Icon(Icons.arrow_back, size: AppDimensions.iconSizeLarge),
                onPressed: () {
                  showSearchBar.value = false;
                  // Arama çubuğu kapandığında filtreleri temizle
                  clearFilters(); 
                },
              )
            : null,
        title: showSearchBar.value
            ? TextField(
                controller: searchController, // Hook'tan gelen controller
                style: AppTextStyles.bodyRegular(context).copyWith(color: Colors.white),
                autofocus: true,
                cursorColor: AppTheme.goldAccent,
                decoration: InputDecoration(
                  hintText: AppStrings.spellsSearchHint,
                  border: InputBorder.none,
                  hintStyle: AppTextStyles.bodyRegular(context).copyWith(color: Colors.white.withOpacity(0.7)),
                  // suffixIcon state'e göre yönetiliyor
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: theme.colorScheme.onPrimary.withOpacity(0.7), size: AppDimensions.iconSizeMedium),
                          onPressed: () => searchController.clear(),
                        )
                      : null,
                ),
              )
            : Text(
                AppStrings.spellsTitle,
              ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: showSearchBar.value // useState değeri kullanılıyor
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: IconButton(
              icon: Icon(
                showSearchBar.value ? Icons.clear : Icons.search, // useState değeri
                color: showSearchBar.value ? AppTheme.goldAccent : theme.colorScheme.onPrimary,
                size: AppDimensions.iconSizeLarge,
              ),
              onPressed: () {
                showSearchBar.value = !showSearchBar.value;
                // Arama çubuğu kapatıldığında filtreleri temizle
                if (!showSearchBar.value) {
                  clearFilters();
                }
              },
            ),
          ),
          // Aktif filtreler varsa temizleme butonu
          if (filters.hasFilters())
            Container(
              margin: const EdgeInsets.only(right: AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: AppTheme.goldAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(
                  color: AppTheme.goldAccent.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.clear_all,
                  color: theme.colorScheme.onPrimary,
                  size: AppDimensions.iconSizeLarge,
                ),
                onPressed: clearFilters, // Temizleme fonksiyonunu kullan
                tooltip: AppStrings.spellsClearFilters,
              ),
            ),
        ],
      ),
      body: allSpellsAsync.when(
        data: (spells) {
          final filteredSpells = filterSpells(spells); // filterSpells fonksiyonu kullanılıyor
          
          if (filteredSpells.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(allSpellsProvider.future),
              child: Center(
                child: Padding(
                  padding: AppDimensions.pagePadding.copyWith(top: 0, bottom: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_fix_off,
                        size: AppDimensions.iconSizeExtraLarge * 2,
                        color: AppTheme.goldAccent.withOpacity(0.6),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      Text(
                        filters.hasFilters()
                            ? AppStrings.spellsSearchNotFound
                            : AppStrings.spellsNotFound,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.emptyListText(context),
                      ),
                      if (filters.hasFilters()) ...[
                        const SizedBox(height: AppDimensions.paddingMedium),
                        ElevatedButton.icon(
                          onPressed: clearFilters, // Temizleme fonksiyonunu kullan
                          icon: const Icon(Icons.clear_all, size: AppDimensions.iconSizeMedium),
                          label: Text(AppStrings.spellsClearFilters),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.gryffindorPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge, vertical: AppDimensions.paddingSmall),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              side: const BorderSide(
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
              padding: const EdgeInsets.only(top: AppDimensions.paddingMedium, bottom: AppDimensions.paddingMedium),
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
            message: AppStrings.spellsLoadingError,
            onRetry: () => ref.invalidate(allSpellsProvider),
          ),
        ),
      ),
    );
  }
} 