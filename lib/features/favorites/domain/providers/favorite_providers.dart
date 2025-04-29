import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _favoritesKey = 'favoriteCharacterIds';

// Favori karakter ID'lerini yöneten StateNotifier
class FavoriteCharactersNotifier extends StateNotifier<Set<String>> {
  FavoriteCharactersNotifier() : super({}) {
    _loadFavorites(); // Başlangıçta favorileri yükle
  }

  SharedPreferences? _prefs;

  // SharedPreferences'ı yükle
  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    final favoriteIds = _prefs?.getStringList(_favoritesKey)?.toSet() ?? {};
    state = favoriteIds;
  }

  // Favorileri SharedPreferences'a kaydet
  Future<void> _saveFavorites() async {
    await _prefs?.setStringList(_favoritesKey, state.toList());
  }

  // Bir karakterin favori olup olmadığını kontrol et
  bool isFavorite(String characterId) {
    return state.contains(characterId);
  }

  // Favori durumunu değiştir (ekle/kaldır)
  Future<void> toggleFavorite(String characterId) async {
    if (state.contains(characterId)) {
      state = {...state}..remove(characterId); // Set'in kopyasını oluşturup elemanı kaldır
    } else {
      state = {...state, characterId}; // Set'in kopyasını oluşturup elemanı ekle
    }
    await _saveFavorites(); // Değişikliği kaydet
  }
}

// FavoriteCharactersNotifier'ı sağlayan provider
final favoriteCharactersProvider = StateNotifierProvider<FavoriteCharactersNotifier, Set<String>>((ref) {
  return FavoriteCharactersNotifier();
});

// ----- Büyü Favorileri -----

const _favoriteSpellsKey = 'favoriteSpellIds';

// Favori büyü ID'lerini yöneten StateNotifier
class FavoriteSpellsNotifier extends StateNotifier<Set<String>> {
  FavoriteSpellsNotifier() : super({}) {
    _loadFavorites(); // Başlangıçta favorileri yükle
  }

  SharedPreferences? _prefs;

  // SharedPreferences'ı yükle
  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    // Use a different key for spells
    final favoriteIds = _prefs?.getStringList(_favoriteSpellsKey)?.toSet() ?? {}; 
    state = favoriteIds;
  }

  // Favorileri SharedPreferences'a kaydet
  Future<void> _saveFavorites() async {
    // Use a different key for spells
    await _prefs?.setStringList(_favoriteSpellsKey, state.toList()); 
  }

  // Bir büyünün favori olup olmadığını kontrol et
  bool isFavorite(String spellId) {
    return state.contains(spellId);
  }

  // Favori durumunu değiştir (ekle/kaldır)
  Future<void> toggleFavorite(String spellId) async {
    if (state.contains(spellId)) {
      state = {...state}..remove(spellId);
    } else {
      state = {...state, spellId};
    }
    await _saveFavorites(); // Değişikliği kaydet
  }
}

// FavoriteSpellsNotifier'ı sağlayan provider
final favoriteSpellsProvider = StateNotifierProvider<FavoriteSpellsNotifier, Set<String>>((ref) {
  return FavoriteSpellsNotifier();
}); 