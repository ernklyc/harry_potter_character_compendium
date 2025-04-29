import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;
  final bool isListView;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
    this.isListView = false,
  });

  Color _getHouseColor(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor': return AppTheme.gryffindorPrimary;
      case 'slytherin': return AppTheme.slytherinPrimary;
      case 'ravenclaw': return AppTheme.ravenclawPrimary;
      case 'hufflepuff': return AppTheme.hufflepuffPrimary;
      default: return Colors.grey[700]!;
    }
  }

  Color _getHouseAccentColor(String house) {
     switch (house.toLowerCase()) {
      case 'gryffindor': return AppTheme.gryffindorSecondary;
      case 'slytherin': return AppTheme.slytherinSecondary;
      case 'ravenclaw': return AppTheme.ravenclawSecondary;
      case 'hufflepuff': return AppTheme.hufflepuffSecondary;
      default: return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final houseColor = _getHouseColor(character.house);
    final houseAccentColor = _getHouseAccentColor(character.house);
    final cardBackgroundColor = Theme.of(context).cardTheme.color ?? Colors.white;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (isListView) {
      return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: houseColor,
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Hero(
                tag: 'character_image_${character.id}',
                child: SizedBox(
                  width: 80,
                  height: 100,
                  child: character.image != null && character.image!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: character.image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
                      ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name,
                        style: GoogleFonts.cinzelDecorative(
                          color: houseColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (character.house.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          character.house,
                          style: GoogleFonts.lato(
                            color: houseAccentColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: [
                          if (character.hogwartsStudent)
                            _buildListInfoChip('Öğrenci', Icons.school, houseColor, isDark),
                          if (character.hogwartsStaff)
                            _buildListInfoChip('Personel', Icons.work, houseColor, isDark),
                          if (character.wizard && !character.hogwartsStudent && !character.hogwartsStaff)
                            _buildListInfoChip('Büyücü', Icons.star, houseColor, isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: houseColor,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: Hero(
                  tag: 'character_image_${character.id}',
                  child: character.image != null && character.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: character.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.grey[300]),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        houseColor.withOpacity(0.9),
                        houseColor.withOpacity(0.0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        character.name,
                        style: GoogleFonts.cinzelDecorative(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.5))
                          ]
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (character.house.isNotEmpty)
                        Text(
                          character.house,
                          style: GoogleFonts.lato(
                            color: houseAccentColor.withOpacity(isDark ? 1.0 : 0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(blurRadius: 1.0, color: Colors.black.withOpacity(0.4))
                            ]
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (character.hogwartsStudent)
                      _buildInfoChip('Öğrenci', Icons.school, houseColor, isDark),
                    if (character.hogwartsStaff)
                      _buildInfoChip('Personel', Icons.work, houseColor, isDark),
                    if (character.wizard && !character.hogwartsStudent && !character.hogwartsStaff)
                       _buildInfoChip('Büyücü', Icons.star, houseColor, isDark),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color bgColor, bool isDark) {
    final chipColor = isDark ? bgColor.withOpacity(0.8) : bgColor;
    final textColor = ThemeData.estimateBrightnessForColor(chipColor) == Brightness.dark
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.8);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(1, 1),
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListInfoChip(String label, IconData icon, Color bgColor, bool isDark) {
    final chipColor = isDark ? bgColor.withOpacity(0.2) : bgColor.withOpacity(0.15);
    final textColor = isDark ? Colors.white.withOpacity(0.9) : bgColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: bgColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: textColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
} 