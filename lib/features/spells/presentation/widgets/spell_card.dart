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
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium, vertical: AppDimensions.paddingSmall - 1), // Dikey margin azaltıldı
      // Şekil ve kenarlık tema tarafından yönetiliyor
      color: cardColor,
      clipBehavior: Clip.antiAlias, // Mürekkep efektinin taşmasını önlemek için
      child: InkWell( // Tüm karta tıklama efekti
        onTap: () {
           // İsteğe bağlı: Karta tıklanınca detay sayfasına gitmek için buraya kod eklenebilir.
           // Şimdilik boş bırakıldı.
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB( // Padding düzenlendi
                AppDimensions.paddingLarge,
                AppDimensions.paddingLarge,
                AppDimensions.paddingLarge + AppDimensions.paddingMedium, // Sağ padding artırıldı (buton için yer)
                AppDimensions.paddingLarge
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row( // İkon ve Başlık için Row
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon( // Büyü ikonu
                        Icons.auto_stories_outlined, // Veya Icons.flash_on_outlined
                        color: accentColor.withOpacity(0.8),
                        size: AppDimensions.iconSizeMedium + 2, // Biraz daha büyük ikon
                      ),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      Expanded( // Başlığın taşmasını engelle
                        child: Text(
                          spell.name,
                          style: AppTextStyles.sectionTitle.copyWith(color: accentColor, fontSize: 17), // Boyut ayarlandı
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium), // Başlık ve açıklama arası boşluk
                  Text(
                    spell.description,
                    style: AppTextStyles.bodyRegular(context).copyWith(color: defaultTextColor, height: 1.45), // Satır yüksekliği ayarlandı
                  ),
                ],
              ),
            ),
            // Favori Butonu
            Positioned(
              top: AppDimensions.paddingSmall / 2,
              right: AppDimensions.paddingSmall / 2,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(), // Dairesel şekil
                clipBehavior: Clip.antiAlias, // Dairesel kırpma
                child: InkWell(
                  onTap: () {
                    ref.read(favoriteSpellsProvider.notifier).toggleFavorite(spell.id);
                  },
                  splashColor: accentColor.withOpacity(0.2), // Tıklama efekti rengi
                  highlightColor: accentColor.withOpacity(0.1), // Vurgu rengi
                  child: Padding(
                    // Padding biraz azaltıldı
                    padding: const EdgeInsets.all(AppDimensions.paddingSmall - 2),
                    child: Icon(
                      isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, // Daha dolgun ikonlar
                      color: isFavorite ? accentColor : theme.iconTheme.color?.withOpacity(0.6), // Normal ikon rengi temadan
                      size: AppDimensions.iconSizeMedium + 4, // Biraz daha büyük
                      shadows: isFavorite
                          ? [
                              Shadow(blurRadius: 4.0, color: accentColor.withOpacity(0.6)),
                              Shadow(blurRadius: 8.0, color: accentColor.withOpacity(0.4)),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.03, curve: Curves.easeOutCubic); // Animasyon ayarlandı
  }
} 