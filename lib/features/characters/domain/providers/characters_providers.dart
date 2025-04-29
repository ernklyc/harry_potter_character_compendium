import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/data/repositories/characters_repository.dart';

// Repository provider
final charactersRepositoryProvider = Provider<CharactersRepository>((ref) {
  return CharactersRepository();
});

// Tüm karakterler için provider
final allCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final repository = ref.watch(charactersRepositoryProvider);
  return repository.getAllCharacters();
});

// Hogwarts öğrencileri için provider
final hogwartsStudentsProvider = FutureProvider<List<Character>>((ref) async {
  final repository = ref.watch(charactersRepositoryProvider);
  return repository.getHogwartsStudents();
});

// Hogwarts personeli için provider
final hogwartsStaffProvider = FutureProvider<List<Character>>((ref) async {
  final repository = ref.watch(charactersRepositoryProvider);
  return repository.getHogwartsStaff();
});

// Ev üyeleri için provider
final houseCharactersProvider = FutureProvider.family<List<Character>, String>((ref, house) async {
  final repository = ref.watch(charactersRepositoryProvider);
  return repository.getCharactersByHouse(house);
});

// Karakter detayları için provider
final characterDetailProvider = FutureProvider.family<Character?, String>((ref, id) async {
  final repository = ref.watch(charactersRepositoryProvider);
  return repository.getCharacterById(id);
}); 