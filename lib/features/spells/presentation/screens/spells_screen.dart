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
  const SpellsScreen({super.key});

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

    void clearSearch() {
      ref.read(spellFiltersProvider.notifier).state = SpellFilters();
      searchController.clear();
    }

    void toggleSearchBar() {
       final willShow = !showSearchBar.value;
       showSearchBar.value = willShow;
       if (!willShow) {
         // Arama çubuğu kapanıyorsa, aramayı temizle
         clearSearch();
       }
    }

    // AppBar'ı ayrı bir widget olarak oluşturabiliriz veya burada bırakabiliriz.
    final appBar = AppBar(
      leading: showSearchBar.value
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: AppDimensions.iconSizeLarge), // Daha modern ikon
              tooltip: 'Geri', // Doğrudan metin kullanıldı
              onPressed: toggleSearchBar, // Fonksiyonu kullan
            )
          : null,
      title: AnimatedSwitcher(
        duration: 300.ms,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: showSearchBar.value
            ? TextField(
                key: const ValueKey('SearchBar'), // Animasyon için anahtar
                controller: searchController,
                style: AppTextStyles.bodyRegular(context).copyWith(color: theme.colorScheme.onPrimary, fontSize: 18), // Düzeltildi: Stil ayarlandı
                autofocus: true,
                cursorColor: AppTheme.goldAccent,
                decoration: InputDecoration(
                  hintText: AppStrings.spellsSearchHint,
                  border: InputBorder.none,
                  hintStyle: AppTextStyles.bodyRegular(context).copyWith(color: theme.colorScheme.onPrimary.withOpacity(0.6), fontSize: 18), // Düzeltildi: Stil ayarlandı
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, color: theme.colorScheme.onPrimary.withOpacity(0.8), size: AppDimensions.iconSizeMedium),
                          tooltip: 'Temizle', // Doğrudan metin kullanıldı
                          onPressed: clearSearch, // Sadece metni temizle
                        )
                      : null,
                ),
              )
            : Text(
                 key: const ValueKey('Title'), // Animasyon için anahtar
                 AppStrings.spellsTitle,
                 style: AppTextStyles.screenTitle, // Tema stilini kullan
               ),
      ),
      actions: [
        // Arama Butonu
        Padding(
          padding: const EdgeInsets.only(right: AppDimensions.paddingSmall), // Sağ boşluk
          child: IconButton(
            icon: Icon(
              showSearchBar.value ? Icons.close_rounded : Icons.search_rounded, // Daha modern ikonlar
              color: theme.colorScheme.onPrimary,
              size: AppDimensions.iconSizeLarge + 2,
            ),
            tooltip: showSearchBar.value ? 'Kapat' : 'Ara', // Doğrudan metin kullanıldı
            style: IconButton.styleFrom(
               backgroundColor: showSearchBar.value ? AppTheme.goldAccent.withOpacity(0.2) : Colors.transparent,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSmall))
            ),
            onPressed: toggleSearchBar, // Fonksiyonu kullan
          ),
        ),
      ],
      // AppBar alt gölgesi (opsiyonel)
      // elevation: showSearchBar.value ? 0 : AppBarTheme.of(context).elevation,
    );

    return Scaffold(
      appBar: appBar,
      body: allSpellsAsync.when(
        data: (spells) {
          final filteredSpells = filterSpells(spells);

          if (filteredSpells.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(allSpellsProvider.future),
              color: AppTheme.goldAccent,
              backgroundColor: theme.colorScheme.primary,
              child: ListView( // Kaydırılabilir olması için ListView içinde
                 children: [ Center(
                    child: Padding(
                      padding: AppDimensions.pagePadding.copyWith(top: AppDimensions.paddingExtraLarge * 2), // Üst boşluk artırıldı
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Ortala
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            filters.hasFilters() ? Icons.search_off_rounded : Icons.auto_stories_outlined, // Duruma göre ikon
                            size: AppDimensions.iconSizeExtraLarge * 2.5,
                            color: AppTheme.goldAccent.withOpacity(0.7),
                          ),
                          const SizedBox(height: AppDimensions.paddingLarge),
                          Text(
                            filters.hasFilters()
                                ? AppStrings.spellsSearchNotFound
                                : AppStrings.spellsNotFound,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.emptyListText(context).copyWith(fontSize: 18), // Boyut ayarlandı
                          ),
                          if (filters.hasFilters()) ...[
                            const SizedBox(height: AppDimensions.paddingLarge), // Boşluk artırıldı
                            ElevatedButton.icon(
                              onPressed: clearSearch, // Arama temizleme fonksiyonunu kullan
                              icon: const Icon(Icons.clear_all_rounded, size: AppDimensions.iconSizeMedium),
                              label: Text('Temizle'), // Doğrudan metin kullanıldı
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.gryffindorPrimary, // Tema rengi
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge + 4, vertical: AppDimensions.paddingMedium - 2),
                                textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold), // Düzeltildi: Tema Text Style kullanıldı
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                  side: BorderSide(
                                    color: AppTheme.goldAccent.withOpacity(0.8),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)), // Animasyon
                          ],
                        ],
                      ),
                    ),
                  ),
              ]),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(allSpellsProvider.future),
            color: AppTheme.goldAccent,
            backgroundColor: theme.colorScheme.primary, // Tema rengi
            child: ListView.builder(
              padding: const EdgeInsets.only(top: AppDimensions.paddingSmall, bottom: AppDimensions.paddingLarge), // Padding ayarlandı
              itemCount: filteredSpells.length,
              itemBuilder: (context, index) {
                final spell = filteredSpells[index];
                return SpellCard(spell: spell)
                    .animate()
                    // Giriş animasyonu listedeki index'e göre hafif gecikmeli
                    .fadeIn(duration: 300.ms, delay: (50 * (index % 10)).ms)
                    .slideY(begin: 0.1, duration: 300.ms, curve: Curves.easeOutQuart);
              },
            ),
          );
        },
        loading: () => const SpellListShimmer(),
        error: (err, stack) => RefreshIndicator(
          onRefresh: () => ref.refresh(allSpellsProvider.future),
          color: AppTheme.goldAccent,
          backgroundColor: theme.colorScheme.primary,
          child: ErrorDisplay(
            message: AppStrings.spellsLoadingError,
            onRetry: () => ref.invalidate(allSpellsProvider),
          ),
        ),
      ),
    );
  }
} 