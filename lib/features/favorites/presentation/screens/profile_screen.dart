import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart'; // Kaldırıldı
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart'; // Artık AppStrings kullanılacak
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart'; 
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart'; 
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart'; // Stringler import edildi
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart'; // Detay ekranına gitmek için
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_card.dart'; // Karakter kartını kullanmak için
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list_shimmer.dart'; // Shimmer efekti için
import 'package:harry_potter_character_compendium/features/spells/domain/providers/spells_providers.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_card.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_list_shimmer.dart';
import 'package:harry_potter_character_compendium/features/favorites/domain/providers/favorite_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context); // Tema alındı
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.favoritesTitle),
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.favoritesTabCharacters, icon: Icon(Icons.person_outline)),
              Tab(text: AppStrings.favoritesTabSpells, icon: Icon(Icons.auto_fix_high_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFavoriteCharacters(context, ref),
            _buildFavoriteSpells(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCharacters(BuildContext context, WidgetRef ref) {
    final favoriteCharacterIds = ref.watch(favoriteCharactersProvider);
    final allCharactersAsync = ref.watch(allCharactersProvider);

    return allCharactersAsync.when(
      data: (allCharacters) {
        final favoriteCharacters = allCharacters
            .where((char) => favoriteCharacterIds.contains(char.id))
            .toList();

        if (favoriteCharacters.isEmpty) {
          return _buildEmptyFavoritesView(context, AppStrings.favoritesEmptyCharacters);
        }

        return GridView.builder(
          key: const PageStorageKey('fav_chars_grid'),
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: AppDimensions.paddingMedium,
            mainAxisSpacing: AppDimensions.paddingMedium,
          ),
          itemCount: favoriteCharacters.length,
          itemBuilder: (context, index) {
            final character = favoriteCharacters[index];
            return CharacterCard(
              character: character,
              onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => CharacterDetailScreen(characterId: character.id),
                   ),
                 );
              },
            );
          },
        );
      },
      loading: () => const CharacterListShimmer(),
      error: (err, stack) => ErrorDisplay(
        message: AppStrings.favoritesLoadingErrorCharacters,
        onRetry: () => ref.invalidate(allCharactersProvider),
      ),
    );
  }

  Widget _buildFavoriteSpells(BuildContext context, WidgetRef ref) {
    final favoriteSpellIds = ref.watch(favoriteSpellsProvider);
    final allSpellsAsync = ref.watch(allSpellsProvider);

    return allSpellsAsync.when(
      data: (allSpells) {
        final favoriteSpells = allSpells
            .where((spell) => favoriteSpellIds.contains(spell.id))
            .toList();

        if (favoriteSpells.isEmpty) {
          return _buildEmptyFavoritesView(context, AppStrings.favoritesEmptySpells);
        }

        return ListView.builder(
          key: const PageStorageKey('fav_spells_list'),
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium, horizontal: AppDimensions.paddingSmall),
          itemCount: favoriteSpells.length,
          itemBuilder: (context, index) {
            final spell = favoriteSpells[index];
            return SpellCard(spell: spell);
          },
        );
      },
      loading: () => const SpellListShimmer(),
      error: (err, stack) => ErrorDisplay(
        message: AppStrings.favoritesLoadingErrorSpells,
        onRetry: () => ref.invalidate(allSpellsProvider),
      ),
    );
  }

  Widget _buildEmptyFavoritesView(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: AppDimensions.iconSizeExtraLarge * 2.5,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            message,
            style: AppTextStyles.emptyListText(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 