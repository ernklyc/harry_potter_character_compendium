import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod import
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';
import 'package:harry_potter_character_compendium/features/favorites/domain/providers/favorite_providers.dart'; // Favori provider import

// SpellCard artık ConsumerWidget olacak
class SpellCard extends ConsumerWidget { 
  final Spell spell;

  const SpellCard({super.key, required this.spell});

  @override
  // build metodu WidgetRef alacak
  Widget build(BuildContext context, WidgetRef ref) { 
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final Color accentColor = AppTheme.goldAccent; // Temadan altın rengini alalım

    // Favori durumunu izle
    final favoriteSpellIds = ref.watch(favoriteSpellsProvider); 
    final isFavorite = favoriteSpellIds.contains(spell.id);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.withOpacity(isDark ? 0.3 : 0.2), width: 1),
      ),
      color: cardColor,
      child: Stack( // Stack widget'ı favori butonu için eklendi
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spell.name,
                  style: GoogleFonts.cinzelDecorative( // Tematik font
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accentColor, // Başlık için altın rengi
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  spell.description,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.4, // Satır yüksekliği
                  ),
                ),
              ],
            ),
          ),
          // Favori Butonu (Sağ Üst Köşe - farklı bir konum)
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent, // Veya hafif bir arkaplan: cardColor.withOpacity(0.5)
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // Favori durumunu değiştir
                  ref.read(favoriteSpellsProvider.notifier).toggleFavorite(spell.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0), // Padding ayarlandı
                  child: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    color: isFavorite ? accentColor : (isDark ? Colors.white60 : Colors.black45),
                    size: 22, // Boyut ayarlandı
                    shadows: isFavorite ? [Shadow(blurRadius: 3.0, color: accentColor.withOpacity(0.5))] : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms); // Animasyon kalabilir
  }
} 