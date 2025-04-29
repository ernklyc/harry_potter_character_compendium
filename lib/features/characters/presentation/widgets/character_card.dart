import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart';
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/favorites/domain/providers/favorite_providers.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';

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
    final houseColor = _getHouseColor(character.house);
    final houseAccentColor = _getHouseAccentColor(character.house);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final favoriteIds = ref.watch(favoriteCharactersProvider);
    final isFavorite = favoriteIds.contains(character.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        side: BorderSide(
          color: houseColor,
          width: AppDimensions.cardBorderWidth + 0.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Stack(
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
                          child: Icon(Icons.person, size: AppDimensions.iconSizeExtraLarge * 2, color: Colors.grey[600]),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.person, size: AppDimensions.iconSizeExtraLarge * 2, color: Colors.grey[600]),
                      ),
              ),
            ),
            Positioned(
              top: AppDimensions.paddingExtraSmall,
              left: AppDimensions.paddingExtraSmall,
              child: Material(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                  onTap: () {
                    ref.read(favoriteCharactersProvider.notifier).toggleFavorite(character.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingSmall - 2),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppTheme.favoriteRed : Colors.white.withOpacity(0.9),
                      size: AppDimensions.iconSizeMedium,
                      shadows: isFavorite ? [Shadow(blurRadius: 3.0, color: AppTheme.favoriteRed.withOpacity(0.7))] : null,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppDimensions.paddingZero,
              left: AppDimensions.paddingZero,
              right: AppDimensions.paddingZero,
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
                      Text(
                        character.house,
                        style: AppTextStyles.cardSubtitle.copyWith(color: houseAccentColor.withOpacity(isDark ? 1.0 : 0.9), fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                    _buildInfoChip(context, AppStrings.charactersTabStudents, Icons.school, houseColor, isDark),
                  if (character.hogwartsStaff)
                    _buildInfoChip(context, AppStrings.charactersTabStaff, Icons.work, houseColor, isDark),
                  if (character.wizard && !character.hogwartsStudent && !character.hogwartsStaff)
                    _buildInfoChip(context, AppStrings.characterIsWizard, Icons.star, houseColor, isDark),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon, Color bgColor, bool isDark) {
    final chipColor = isDark ? bgColor.withOpacity(0.8) : bgColor;
    final theme = Theme.of(context);
    final textColor = ThemeData.estimateBrightnessForColor(chipColor) == Brightness.dark
        ? theme.colorScheme.onPrimary.withOpacity(0.9)
        : theme.colorScheme.onSurface.withOpacity(0.8);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingExtraSmall),
      padding: AppDimensions.chipPadding,
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(1, 1),
          )
        ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSizeExtraSmall, color: textColor),
          const SizedBox(width: AppDimensions.paddingExtraSmall),
          Text(
            label,
            style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
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