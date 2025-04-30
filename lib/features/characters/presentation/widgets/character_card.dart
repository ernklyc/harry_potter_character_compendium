import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart';
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/favorites/domain/providers/favorite_providers.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CharacterCard extends ConsumerWidget {
  final Character character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final houseColor = _getHouseColor(character.house);
    final houseAccentColor = _getHouseAccentColor(character.house);
    final isDark = theme.brightness == Brightness.dark;

    final favoriteIds = ref.watch(favoriteCharactersProvider);
    final isFavorite = favoriteIds.contains(character.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: AppDimensions.cardElevation - 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        side: BorderSide(
          color: houseColor.withOpacity(0.7),
          width: AppDimensions.cardBorderWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: houseColor.withOpacity(0.2),
        highlightColor: houseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Hero(
                tag: 'character_image_${character.id}',
                child: character.image != null && character.image!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: character.image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               colors: [houseColor.withOpacity(0.1), houseColor.withOpacity(0.3)],
                               begin: Alignment.topLeft,
                               end: Alignment.bottomRight,
                              )
                           )
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(Icons.broken_image_outlined, size: AppDimensions.iconSizeExtraLarge, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                        ),
                        fadeInDuration: 300.ms,
                      )
                    : Container(
                        decoration: BoxDecoration(
                           gradient: LinearGradient(
                             colors: [houseColor.withOpacity(0.2), houseColor.withOpacity(0.4)],
                             begin: Alignment.topLeft,
                             end: Alignment.bottomRight,
                            )
                        ),
                        child: Icon(Icons.person_outline, size: AppDimensions.iconSizeExtraLarge * 1.5, color: houseAccentColor.withOpacity(0.6)),
                      ),
              ),
            ),
            Positioned(
              top: AppDimensions.paddingSmall - 2,
              left: AppDimensions.paddingSmall - 2,
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    ref.read(favoriteCharactersProvider.notifier).toggleFavorite(character.id);
                  },
                  splashColor: AppTheme.favoriteRed.withOpacity(0.3),
                  highlightColor: AppTheme.favoriteRed.withOpacity(0.15),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingSmall - 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.4),
                      boxShadow: isFavorite ? [
                        BoxShadow(
                          color: AppTheme.favoriteRed.withOpacity(0.5),
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                        )
                      ] : null,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFavorite ? AppTheme.favoriteRed : Colors.white.withOpacity(0.9),
                      size: AppDimensions.iconSizeMedium + 2,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium, vertical: AppDimensions.paddingSmall),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      houseColor.withOpacity(0.95),
                      houseColor.withOpacity(0.0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.8]
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      character.name,
                      style: AppTextStyles.cardTitleLarge.copyWith(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (character.house.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppDimensions.paddingExtraSmall / 2),
                        child: Text(
                          character.house,
                          style: AppTextStyles.cardSubtitle.copyWith(color: houseAccentColor.withOpacity(isDark ? 1.0 : 0.9), fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: AppDimensions.paddingSmall,
              right: AppDimensions.paddingSmall,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (character.hogwartsStudent)
                    _buildInfoChip(context, AppStrings.charactersTabStudents, Icons.school_outlined, houseColor, isDark),
                  if (character.hogwartsStaff)
                    _buildInfoChip(context, AppStrings.charactersTabStaff, Icons.work_outline, houseColor, isDark),
                  if (character.wizard && !character.hogwartsStudent && !character.hogwartsStaff)
                    _buildInfoChip(context, AppStrings.characterIsWizard, Icons.star_border_purple500_outlined, houseColor, isDark),
                ].animate(interval: 100.ms).fadeIn(duration: 200.ms).slideX(begin: 0.2),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon, Color bgColor, bool isDark) {
    final chipBgColor = isDark ? bgColor.withOpacity(0.8) : bgColor.withOpacity(0.9);
    final theme = Theme.of(context);
    final textColor = ThemeData.estimateBrightnessForColor(chipBgColor) == Brightness.dark
        ? Colors.white.withOpacity(0.95)
        : Colors.black.withOpacity(0.8);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingExtraSmall),
      padding: AppDimensions.chipPadding,
      decoration: BoxDecoration(
        color: chipBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(
           color: Colors.white.withOpacity(isDark ? 0.2 : 0.5),
           width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.25),
            blurRadius: 3,
            offset: const Offset(1, 2),
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSizeExtraSmall + 1, color: textColor),
          const SizedBox(width: AppDimensions.paddingExtraSmall),
          Text(
            label,
            style: AppTextStyles.bodySmall(context).copyWith(
               fontSize: 11.5,
               fontWeight: FontWeight.bold,
               color: textColor,
               letterSpacing: 0.2
            ),
          ),
        ],
      ),
    );
  }

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
} 