import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';

// StatelessWidget'a geri dönüldü, ExpansionTile state'i yönetecek
class SpellCard extends StatelessWidget {
  final Spell spell;

  const SpellCard({super.key, required this.spell});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleStyle = GoogleFonts.cinzelDecorative(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: isDark ? AppTheme.goldAccent : AppTheme.gryffindorRed,
    );
    final descriptionStyle = GoogleFonts.lato(
      fontSize: 14,
      color: colors.onSurface.withOpacity(0.7),
    );

    return Card(
      elevation: 2, // ExpansionTile kendi gölgesini yönetebilir
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias, // Önemli: ExpansionTile içeriği kırpılmalı
      child: ExpansionTile(
        // Görünüm Özelleştirmeleri
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        backgroundColor: Theme.of(context).cardTheme.color, // Kart rengiyle aynı
        collapsedBackgroundColor: Theme.of(context).cardTheme.color,
        iconColor: colors.onSurface.withOpacity(0.6),
        collapsedIconColor: colors.onSurface.withOpacity(0.5),
        textColor: titleStyle.color, // Başlık rengi açıkken de aynı
        collapsedTextColor: titleStyle.color,
        shape: const Border(), // İç kenarlıkları kaldır
        collapsedShape: const Border(), // İç kenarlıkları kaldır

        // Başlık Kısmı (Kapalıyken Görünen)
        title: Row(
          children: [
            Icon(Icons.auto_fix_high, color: AppTheme.goldAccent, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(spell.name, style: titleStyle),
            ),
          ],
        ),
        // Genişletme İkonu Sağda
        trailing: const Icon(Icons.expand_more), // Varsayılan ikon, tile çevirecek
        // childrenPadding: EdgeInsets.zero, // İsteğe bağlı padding
        // expandedAlignment: Alignment.centerLeft, // İçerik hizalaması
        // expandedCrossAxisAlignment: CrossAxisAlignment.start,

        // Açılınca Görünen Çocuklar (Açıklama)
        children: [
          if (spell.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16.0 + 28.0 + 16.0, right: 16.0, bottom: 16.0, top: 0), // İkona göre hizala
              child: Text(
                spell.description,
                style: descriptionStyle,
              ),
            ),
        ],
        // onExpansionChanged: (bool expanding) => print('${spell.name} expanded: $expanding'),
      ),
    );
  }
} 