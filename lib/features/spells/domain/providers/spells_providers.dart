import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';
import 'package:harry_potter_character_compendium/features/spells/data/repositories/spells_repository.dart';

// Repository provider
final spellsRepositoryProvider = Provider<SpellsRepository>((ref) {
  return SpellsRepository();
});

// Tüm büyüler için provider
final allSpellsProvider = FutureProvider<List<Spell>>((ref) async {
  final repository = ref.watch(spellsRepositoryProvider);
  return repository.getAllSpells();
}); 