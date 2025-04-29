import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';

// StatefulWidget'a dönüştürüldü
class SpellCard extends StatefulWidget {
  final Spell spell;

  const SpellCard({super.key, required this.spell});

  @override
  State<SpellCard> createState() => _SpellCardState();
}

class _SpellCardState extends State<SpellCard> {
  bool _isExpanded = false; // Genişleme durumu için state

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: _isExpanded ? 4 : 2, // Genişleyince gölge artsın
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // Belki hafif bir kenarlık?
        // side: BorderSide(color: AppTheme.goldAccent.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Durumu değiştirip yeniden çizim tetikle
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.auto_fix_high,
                color: AppTheme.goldAccent,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.spell.name,
                        style: GoogleFonts.cinzelDecorative(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.goldAccent : AppTheme.gryffindorRed,
                        ),
                      ),
                      if (widget.spell.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            widget.spell.description,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              color: colors.onSurface.withOpacity(0.7),
                            ),
                            // Genişleme durumuna göre maxLines ayarı
                            maxLines: _isExpanded ? null : 2,
                            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Genişletme/Daraltma İkonu
              Padding(
                padding: const EdgeInsets.only(left: 8.0), // İkonu sağa yasla
                child: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: colors.onSurface.withOpacity(0.5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
} 