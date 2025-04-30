import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod import
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart'; // Boyutlar import edildi
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart'; // Metin stilleri import edildi
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
    final theme = Theme.of(context);
    // Renkler tema veya AppTheme'den
    final Color cardColor = Theme.of(context).cardTheme.color ?? (isDark ? Colors.grey[850]! : Colors.white);
    final Color accentColor = AppTheme.goldAccent;
    final Color defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? theme.colorScheme.onSurface.withOpacity(0.8);

    // Favori durumunu izle
    final favoriteSpellIds = ref.watch(favoriteSpellsProvider); 
    final isFavorite = favoriteSpellIds.contains(spell.id);

    return Card(
      elevation: AppDimensions.cardElevation, // Sabit kullanıldı
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium, vertical: AppDimensions.paddingSmall - 2),
      shape: Theme.of(context).cardTheme.shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3), width: 1),
      ),
      color: cardColor,
      child: Stack( // Stack widget'ı favori butonu için eklendi
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spell.name,
                  style: AppTextStyles.sectionTitle.copyWith(color: accentColor),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  spell.description,
                  style: AppTextStyles.bodyRegular(context).copyWith(color: defaultTextColor, height: 1.4),
                ),
              ],
            ),
          ),
          // Favori Butonu (Sağ Üst Köşe - farklı bir konum)
          Positioned(
            top: AppDimensions.paddingSmall,
            right: AppDimensions.paddingSmall,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                onTap: () {
                  // Favori durumunu değiştir
                  ref.read(favoriteSpellsProvider.notifier).toggleFavorite(spell.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall - 3),
                  child: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    color: isFavorite ? accentColor : theme.colorScheme.onSurface.withOpacity(0.5),
                    size: AppDimensions.iconSizeMedium,
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