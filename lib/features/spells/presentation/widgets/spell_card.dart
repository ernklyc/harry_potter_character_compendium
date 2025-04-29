import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';

class SpellCard extends StatelessWidget {
  final Spell spell;

  const SpellCard({super.key, required this.spell});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // Belki hafif bir kenarlık?
        // side: BorderSide(color: AppTheme.goldAccent.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Tıklama aksiyonu - belki detay modalı açılabilir?
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('${spell.name} büyüsü etkisi: ${spell.description}')),
           );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Büyü ikonu (örneğin, rastgele veya türe göre)
              Icon(
                Icons.auto_fix_high, // Şimdilik sabit ikon
                color: AppTheme.goldAccent,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spell.name,
                      style: GoogleFonts.cinzelDecorative(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.goldAccent : AppTheme.gryffindorRed,
                      ),
                    ),
                    if (spell.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          spell.description,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: colors.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              // Belki büyü türü veya zorluk seviyesi ikonu?
              // Icon(Icons.star_border, color: colors.onSurface.withOpacity(0.5))
            ],
          ),
        ),
      ),
    );
  }
} 