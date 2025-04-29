import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allCharacters = ref.watch(allCharactersProvider);
    final hogwartsStudents = ref.watch(hogwartsStudentsProvider);
    final hogwartsStaff = ref.watch(hogwartsStaffProvider);
    final gryffindorCharacters = ref.watch(houseCharactersProvider('gryffindor'));

    void navigateToCharacterDetail(Character character) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailScreen(characterId: character.id),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Karakterleri'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tümü'),
            Tab(text: 'Öğrenciler'),
            Tab(text: 'Personel'),
            Tab(text: 'Gryffindor'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tüm karakterler sekmesi
          allCharacters.when(
            data: (characters) => CharacterList(
              characters: characters,
              onCharacterTap: navigateToCharacterDetail,
            ),
            loading: () => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              isLoading: true,
            ),
            error: (err, stack) => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              errorMessage: 'Karakterler yüklenirken bir hata oluştu: $err',
            ),
          ),
          
          // Öğrenciler sekmesi
          hogwartsStudents.when(
            data: (characters) => CharacterList(
              characters: characters,
              onCharacterTap: navigateToCharacterDetail,
            ),
            loading: () => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              isLoading: true,
            ),
            error: (err, stack) => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              errorMessage: 'Öğrenciler yüklenirken bir hata oluştu: $err',
            ),
          ),
          
          // Personel sekmesi
          hogwartsStaff.when(
            data: (characters) => CharacterList(
              characters: characters,
              onCharacterTap: navigateToCharacterDetail,
            ),
            loading: () => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              isLoading: true,
            ),
            error: (err, stack) => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              errorMessage: 'Personel yüklenirken bir hata oluştu: $err',
            ),
          ),
          
          // Gryffindor sekmesi
          gryffindorCharacters.when(
            data: (characters) => CharacterList(
              characters: characters,
              onCharacterTap: navigateToCharacterDetail,
            ),
            loading: () => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              isLoading: true,
            ),
            error: (err, stack) => CharacterList(
              characters: const [],
              onCharacterTap: (_) {}, // Boş fonksiyon
              errorMessage: 'Gryffindor üyeleri yüklenirken bir hata oluştu: $err',
            ),
          ),
        ],
      ),
    );
  }
} 