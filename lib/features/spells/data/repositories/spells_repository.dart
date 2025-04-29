import 'package:harry_potter_character_compendium/core/network/api_client.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';

class SpellsRepository {
  final ApiClient _apiClient;

  SpellsRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<Spell>> getAllSpells() async {
    try {
      final data = await _apiClient.getAllSpells();
      return data.map((json) => Spell.fromJson(json)).toList();
    } catch (e) {
      throw Exception('${AppStrings.spellsLoadingError} Detay: $e');
    }
  }
} 