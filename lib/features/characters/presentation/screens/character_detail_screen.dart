import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart';
import 'package:harry_potter_character_compendium/core/theme/app_text_styles.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';

class CharacterDetailScreen extends ConsumerWidget {
  final String characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  // Bu fonksiyonlar artık doğrudan AppTheme'den alınabilir veya burada kalabilir
  Color _getHouseColor(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor': return AppTheme.gryffindorPrimary;
      case 'slytherin': return AppTheme.slytherinPrimary;
      case 'ravenclaw': return AppTheme.ravenclawPrimary;
      case 'hufflepuff': return AppTheme.hufflepuffPrimary;
      default: return Colors.grey[800]!;
    }
  }

   Color _getHouseAccentColor(String house) {
     switch (house.toLowerCase()) {
      case 'gryffindor': return AppTheme.gryffindorSecondary;
      case 'slytherin': return AppTheme.slytherinSecondary;
      case 'ravenclaw': return AppTheme.ravenclawSecondary;
      case 'hufflepuff': return AppTheme.hufflepuffSecondary;
      default: return AppTheme.goldAccent;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterDetailAsync = ref.watch(characterDetailProvider(characterId));
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: characterDetailAsync.when(
        data: (character) {
          if (character == null) {
            return Center(
              child: ErrorDisplay(message: AppStrings.characterNotFound),
            );
          }

          final primaryColor = _getHouseColor(character.house);
          final accentColor = _getHouseAccentColor(character.house);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 380.0, // Bu değer de dimensions'a taşınabilir
                pinned: true,
                floating: false,
                stretch: true,
                elevation: AppDimensions.paddingZero, // Sabit kullanıldı
                backgroundColor: primaryColor,
                iconTheme: const IconThemeData(color: Colors.white),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  // Padding için sabit kullanıldı
                  titlePadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingExtraLarge * 2, vertical: AppDimensions.paddingLarge),
                  title: Text(
                    character.name,
                    // AppTextStyles içindeki stil kullanıldı
                    style: AppTextStyles.cardTitleLarge.copyWith(shadows: [], fontSize: 20), // Gölge kaldırıldı, boyut ayarlandı
                    textAlign: TextAlign.center,
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'character_image_${character.id}',
                        child: character.image != null && character.image!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: character.image!,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                placeholder: (context, url) => Container(color: primaryColor.withOpacity(0.5)),
                                errorWidget: (context, url, error) => Container(
                                  color: primaryColor.withOpacity(0.5),
                                  child: Icon(Icons.person, size: 150, color: Colors.white.withOpacity(0.7)),
                                ),
                              )
                            : Container(
                                color: primaryColor.withOpacity(0.5),
                                child: Icon(Icons.person, size: 150, color: Colors.white.withOpacity(0.7)),
                              ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                              primaryColor.withOpacity(0.7),
                            ],
                            stops: const [0.4, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                  stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
                ),
              ),
              SliverPadding(
                // Padding için sabit kullanıldı
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingPageHorizontal, vertical: AppDimensions.paddingPageVertical),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildInfoSection(
                      context,
                      AppStrings.characterInfoBasic,
                      primaryColor,
                      accentColor,
                      [
                        if (character.alternateNames.isNotEmpty) _buildInfoRow(context, Icons.theater_comedy, AppStrings.characterAlternateNames, character.alternateNames.join(", "), accentColor),
                        if (character.house.isNotEmpty) _buildInfoRow(context, Icons.home_filled, AppStrings.characterHouse, character.house, accentColor),
                        if (character.species.isNotEmpty) _buildInfoRow(context, Icons.pets, AppStrings.characterSpecies, character.species, accentColor),
                        if (character.gender.isNotEmpty) _buildInfoRow(context, Icons.transgender, AppStrings.characterGender, character.gender, accentColor),
                        if (character.dateOfBirth != null) _buildInfoRow(context, Icons.cake, AppStrings.characterDob, character.dateOfBirth!, accentColor),
                        if (character.yearOfBirth != null) _buildInfoRow(context, Icons.calendar_today, AppStrings.characterYob, character.yearOfBirth.toString(), accentColor),
                        _buildInfoRow(context, Icons.auto_awesome, AppStrings.characterIsWizard, character.wizard ? AppStrings.yes : AppStrings.no, accentColor),
                        if (character.ancestry.isNotEmpty) _buildInfoRow(context, Icons.bloodtype, AppStrings.characterAncestry, character.ancestry, accentColor),
                        _buildInfoRow(context, Icons.favorite, AppStrings.characterIsAlive, character.alive ? AppStrings.yes : AppStrings.no, accentColor),
                      ],
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                    if (character.eyeColour.isNotEmpty || character.hairColour.isNotEmpty)
                      _buildInfoSection(
                        context,
                        AppStrings.characterInfoPhysical,
                        primaryColor,
                        accentColor,
                        [
                          if (character.eyeColour.isNotEmpty) _buildInfoRow(context, Icons.visibility, AppStrings.characterEyeColor, character.eyeColour, accentColor),
                          if (character.hairColour.isNotEmpty) _buildInfoRow(context, Icons.brush, AppStrings.characterHairColor, character.hairColour, accentColor),
                        ],
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

                    if (character.wand != null && (character.wand!.wood.isNotEmpty || character.wand!.core.isNotEmpty || character.wand!.length != null))
                      _buildInfoSection(
                        context,
                        AppStrings.characterInfoWand,
                        primaryColor,
                        accentColor,
                        [
                          if (character.wand!.wood.isNotEmpty) _buildInfoRow(context, Icons.park_outlined, AppStrings.characterWandWood, character.wand!.wood, accentColor),
                          if (character.wand!.core.isNotEmpty) _buildInfoRow(context, Icons.flash_on_outlined, AppStrings.characterWandCore, character.wand!.core, accentColor),
                          if (character.wand!.length != null) _buildInfoRow(context, Icons.straighten_outlined, AppStrings.characterWandLength, '${character.wand!.length} inç', accentColor),
                        ],
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                    if (character.patronus.isNotEmpty)
                      _buildInfoSection(
                        context,
                        AppStrings.characterInfoPatronus,
                        primaryColor,
                        accentColor,
                        [
                          _buildInfoRow(context, Icons.shield_moon_outlined, AppStrings.characterPatronusLabel, character.patronus, accentColor),
                        ],
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

                    _buildInfoSection(
                      context,
                      AppStrings.characterInfoHogwarts,
                      primaryColor,
                      accentColor,
                      [
                        _buildInfoRow(context, Icons.school, AppStrings.characterIsStudent, character.hogwartsStudent ? AppStrings.yes : AppStrings.no, accentColor),
                        _buildInfoRow(context, Icons.work, AppStrings.characterIsStaff, character.hogwartsStaff ? AppStrings.yes : AppStrings.no, accentColor),
                      ],
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),

                    if (character.actor.isNotEmpty || character.alternateActors.isNotEmpty)
                      _buildInfoSection(
                        context,
                        AppStrings.characterInfoFilm,
                        primaryColor,
                        accentColor,
                        [
                          if (character.actor.isNotEmpty) _buildInfoRow(context, Icons.person, AppStrings.characterActor, character.actor, accentColor),
                          if (character.alternateActors.isNotEmpty) _buildInfoRow(context, Icons.people, AppStrings.characterAlternateActors, character.alternateActors.join(", "), accentColor),
                        ],
                      ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),

                    // Alt boşluk için sabit kullanıldı
                    const SizedBox(height: AppDimensions.paddingLarge), 
                  ]),
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppDimensions.paddingLarge),
              Text(
               AppStrings.characterDetailsLoading,
               style: AppTextStyles.bodyRegular(context),
              ),
            ],
          ),
        ),
        error: (err, stack) => ErrorDisplay(
          message: AppStrings.characterLoadingError,
          onRetry: () => ref.invalidate(characterDetailProvider(characterId)),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, Color primaryColor, Color accentColor, List<Widget> children) {
    final validChildren = children.where((w) => w is! SizedBox || (w is SizedBox && w.height == null)).toList();
    if (validChildren.isEmpty) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final sectionBgColor = primaryColor.withOpacity(isDark ? 0.1 : 0.04);

    return Container(
      // Margin için sabit kullanıldı
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
      // Padding için sabit kullanıldı
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge, vertical: AppDimensions.paddingLarge - 2), // Biraz daha az dikey padding
      decoration: BoxDecoration(
        color: sectionBgColor,
        // Radius için sabit kullanıldı
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all( 
          color: accentColor.withOpacity(isDark ? 0.5 : 0.3),
          // Border width için sabit kullanıldı
          width: AppDimensions.cardBorderWidth, 
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            // AppTextStyles içindeki stil kullanıldı
            style: AppTextStyles.sectionTitle.copyWith(color: accentColor), 
          ),
          // Boşluk için sabit kullanıldı
          const SizedBox(height: AppDimensions.paddingSmall + 2),
          ...validChildren,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, Color accentColor) {
    final theme = Theme.of(context);
    // AppTextStyles içindeki stiller kullanıldı
    final labelStyle = AppTextStyles.detailLabel.copyWith(color: accentColor);
    final valueStyle = AppTextStyles.detailValue(context);

    if (value.isEmpty || value == 'null') return const SizedBox.shrink();

    return Padding(
      // Padding için sabit kullanıldı
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall - 1), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // İkon boyutu ve rengi için sabitler kullanıldı
          Icon(icon, size: AppDimensions.iconSizeMedium - 2, color: accentColor.withOpacity(0.9)), 
          // Boşluk için sabit kullanıldı
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: '$label: ', style: labelStyle),
                  TextSpan(text: value, style: valueStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}