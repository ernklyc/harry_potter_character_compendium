import 'package:harry_potter_character_compendium/core/network/api_client.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';

class CharactersRepository {
  final ApiClient _apiClient;

  CharactersRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<Character>> getAllCharacters() async {
    try {
      final data = await _apiClient.getAllCharacters();
      return data.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Karakterler yüklenirken bir hata oluştu: $e');
    }
  }

  Future<Character?> getCharacterById(String id) async {
    try {
      final data = await _apiClient.getCharacterById(id);
      if (data.isEmpty) return null;
      return Character.fromJson(data.first);
    } catch (e) {
      throw Exception('Karakter detayları yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<Character>> getHogwartsStudents() async {
    try {
      final data = await _apiClient.getHogwartsStudents();
      return data.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Hogwarts öğrencileri yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<Character>> getHogwartsStaff() async {
    try {
      final data = await _apiClient.getHogwartsStaff();
      return data.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Hogwarts personeli yüklenirken bir hata oluştu: $e');
    }
  }

  Future<List<Character>> getCharactersByHouse(String house) async {
    try {
      final data = await _apiClient.getCharactersByHouse(house);
      return data.map((json) => Character.fromJson(json)).toList();
    } catch (e) {
      throw Exception('$house üyeleri yüklenirken bir hata oluştu: $e');
    }
  }
} 