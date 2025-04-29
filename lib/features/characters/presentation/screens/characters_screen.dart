import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list_shimmer.dart';

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

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(icon: Icon(Icons.people_alt_outlined)),
              Tab(icon: Icon(Icons.school_outlined)),
              Tab(icon: Icon(Icons.work_outline)),
              Tab(icon: Icon(Icons.shield_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            allCharacters.when(
              data: (characters) => CharacterList(
                characters: characters,
                onCharacterTap: navigateToCharacterDetail,
              ),
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => ErrorDisplay(
                message: 'Karakterler yüklenemedi.',
                onRetry: () => _retryLoad(ref, 0),
              ),
            ),
            
            hogwartsStudents.when(
              data: (characters) => CharacterList(
                characters: characters,
                onCharacterTap: navigateToCharacterDetail,
              ),
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => ErrorDisplay(
                message: 'Öğrenciler yüklenemedi.',
                onRetry: () => _retryLoad(ref, 1),
              ),
            ),
            
            hogwartsStaff.when(
              data: (characters) => CharacterList(
                characters: characters,
                onCharacterTap: navigateToCharacterDetail,
              ),
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => ErrorDisplay(
                message: 'Personel yüklenemedi.',
                onRetry: () => _retryLoad(ref, 2),
              ),
            ),
            
            gryffindorCharacters.when(
              data: (characters) => CharacterList(
                characters: characters,
                onCharacterTap: navigateToCharacterDetail,
              ),
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => ErrorDisplay(
                message: 'Gryffindor üyeleri yüklenemedi.',
                onRetry: () => _retryLoad(ref, 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 