import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
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
    return DefaultTabController(
      length: 2, // İki sekme: Karakterler ve Büyüler
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Favorilerim', // Başlık güncellendi
            style: GoogleFonts.cinzelDecorative(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppTheme.gryffindorPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: AppTheme.goldAccent, // Gryffindor altın rengi
            labelColor: AppTheme.goldAccent,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Karakterler', icon: Icon(Icons.person_outline)),
              Tab(text: 'Büyüler', icon: Icon(Icons.auto_fix_high_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFavoriteCharacters(context, ref), // Favori karakterler sekmesi
            _buildFavoriteSpells(context, ref),    // Favori büyüler sekmesi
          ],
        ),
      ),
    );
  }

  // Favori karakterleri listeleyen widget
  Widget _buildFavoriteCharacters(BuildContext context, WidgetRef ref) {
    final favoriteCharacterIds = ref.watch(favoriteCharactersProvider);
    final allCharactersAsync = ref.watch(allCharactersProvider);

    return allCharactersAsync.when(
      data: (allCharacters) {
        final favoriteCharacters = allCharacters
            .where((char) => favoriteCharacterIds.contains(char.id))
            .toList();

        if (favoriteCharacters.isEmpty) {
          return _buildEmptyFavoritesView('karakter');
        }

        return GridView.builder(
          key: const PageStorageKey('fav_chars_grid'), // Keep scroll position
          padding: const EdgeInsets.all(12.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
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
        message: 'Favori karakterler yüklenirken bir hata oluştu.',
        onRetry: () => ref.invalidate(allCharactersProvider),
      ),
    );
  }

  // Favori büyüleri listeleyen widget
  Widget _buildFavoriteSpells(BuildContext context, WidgetRef ref) {
    final favoriteSpellIds = ref.watch(favoriteSpellsProvider);
    final allSpellsAsync = ref.watch(allSpellsProvider);

    return allSpellsAsync.when(
      data: (allSpells) {
        final favoriteSpells = allSpells
            .where((spell) => favoriteSpellIds.contains(spell.id)) // Use spell.id
            .toList();

        if (favoriteSpells.isEmpty) {
          return _buildEmptyFavoritesView('büyü');
        }

        // Büyüler için ListView daha uygun olabilir
        return ListView.builder(
          key: const PageStorageKey('fav_spells_list'), // Keep scroll position
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          itemCount: favoriteSpells.length,
          itemBuilder: (context, index) {
            final spell = favoriteSpells[index];
            // SpellCard doğrudan tıklama işlevi almıyor, 
            // bu yüzden bir GestureDetector ile sarılabilir veya 
            // SpellCard'a onTap eklenebilir.
            // Şimdilik sadece kartı gösterelim.
            return SpellCard(spell: spell);
          },
        );
      },
      loading: () => const SpellListShimmer(), // Büyü shimmer'ı
      error: (err, stack) => ErrorDisplay(
        message: 'Favori büyüler yüklenirken bir hata oluştu.',
        onRetry: () => ref.invalidate(allSpellsProvider),
      ),
    );
  }

  // Boş favori listesi görünümü
  Widget _buildEmptyFavoritesView(String type) {
     return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Henüz favori $type\n bulunmuyor.', // Dinamik metin
            style: GoogleFonts.lato(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 