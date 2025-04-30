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

class CharacterDetailScreen extends ConsumerStatefulWidget {
  final String characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  @override
  ConsumerState<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends ConsumerState<CharacterDetailScreen> {

  @override
  void initState() {
    super.initState();
    AppStrings.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    AppStrings.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

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
  Widget build(BuildContext context) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    final characterDetailAsync = ref.watch(characterDetailProvider(widget.characterId));
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: ValueKey(currentLanguage),
      backgroundColor: theme.colorScheme.surface,
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
                expandedHeight: 380.0,
                pinned: true,
                floating: false,
                stretch: true,
                elevation: 0.0,
                backgroundColor: primaryColor,
                iconTheme: const IconThemeData(color: Colors.white, size: AppDimensions.iconSizeLarge),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge * 1.5, vertical: AppDimensions.paddingMedium),
                  title: Text(
                    character.name,
                    style: AppTextStyles.screenTitle.copyWith(
                       color: Colors.white,
                       shadows: [
                          Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 3, offset: const Offset(1,1))
                       ]
                    ),
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
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                     gradient: LinearGradient(
                                       colors: [primaryColor.withOpacity(0.2), primaryColor.withOpacity(0.5)],
                                       begin: Alignment.topLeft, end: Alignment.bottomRight
                                     )
                                  ),
                                  child: const Center(child: CircularProgressIndicator(color: Colors.white70)),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: primaryColor.withOpacity(0.3),
                                  child: Icon(Icons.person, size: 150, color: Colors.white.withOpacity(0.5)),
                                ),
                                fadeInDuration: 400.ms,
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
                              primaryColor.withOpacity(0.3),
                              primaryColor.withOpacity(0.8),
                            ],
                            stops: const [0.3, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                  stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
                ),
              ),
              SliverPadding(
                padding: AppDimensions.pagePadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ..._buildInfoSections(context, theme, isDark, character, primaryColor, accentColor)
                        .animate(interval: 100.ms).fadeIn(duration: 300.ms).slideY(begin: 0.1, curve: Curves.easeOutCubic),
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
              const CircularProgressIndicator(color: AppTheme.goldAccent),
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
          onRetry: () => ref.invalidate(characterDetailProvider(widget.characterId)),
        ),
      ),
    );
  }

  List<Widget> _buildInfoSections(BuildContext context, ThemeData theme, bool isDark, Character character, Color primaryColor, Color accentColor) {
    return [
       if (character.alternateNames.isNotEmpty || character.house.isNotEmpty || character.species.isNotEmpty || character.gender.isNotEmpty || character.dateOfBirth != null || character.yearOfBirth != null || character.ancestry.isNotEmpty)
         _buildInfoSection(
          context, theme, isDark, AppStrings.characterInfoBasic, primaryColor, accentColor,
           [
             if (character.alternateNames.isNotEmpty) _buildInfoRow(context, theme, Icons.theater_comedy, AppStrings.characterAlternateNames, character.alternateNames.join(", "), accentColor),
             if (character.house.isNotEmpty) _buildInfoRow(context, theme, Icons.fort_outlined, AppStrings.characterHouse, character.house, accentColor),
             if (character.species.isNotEmpty) _buildInfoRow(context, theme, Icons.pets_outlined, AppStrings.characterSpecies, character.species, accentColor),
             if (character.gender.isNotEmpty) _buildInfoRow(context, theme, Icons.transgender_outlined, AppStrings.characterGender, character.gender, accentColor),
             if (character.dateOfBirth != null) _buildInfoRow(context, theme, Icons.cake_outlined, AppStrings.characterDob, character.dateOfBirth!, accentColor),
             if (character.yearOfBirth != null) _buildInfoRow(context, theme, Icons.calendar_today_outlined, AppStrings.characterYob, character.yearOfBirth.toString(), accentColor),
             _buildInfoRow(context, theme, Icons.auto_awesome_outlined, AppStrings.characterIsWizard, character.wizard ? AppStrings.yes : AppStrings.no, accentColor),
             if (character.ancestry.isNotEmpty) _buildInfoRow(context, theme, Icons.bloodtype_outlined, AppStrings.characterAncestry, character.ancestry, accentColor),
             _buildInfoRow(context, theme, character.alive ? Icons.favorite_outlined : Icons.heart_broken_outlined, AppStrings.characterIsAlive, character.alive ? AppStrings.yes : AppStrings.no, accentColor),
           ],
         ),

       if (character.eyeColour.isNotEmpty || character.hairColour.isNotEmpty)
         _buildInfoSection(
           context, theme, isDark, AppStrings.characterInfoPhysical, primaryColor, accentColor,
           [
             if (character.eyeColour.isNotEmpty) _buildInfoRow(context, theme, Icons.visibility_outlined, AppStrings.characterEyeColor, character.eyeColour, accentColor),
             if (character.hairColour.isNotEmpty) _buildInfoRow(context, theme, Icons.brush_outlined, AppStrings.characterHairColor, character.hairColour, accentColor),
           ],
         ),

       if (character.wand != null && (character.wand!.wood.isNotEmpty || character.wand!.core.isNotEmpty || character.wand!.length != null))
         _buildInfoSection(
           context, theme, isDark, AppStrings.characterInfoWand, primaryColor, accentColor,
           [
             if (character.wand!.wood.isNotEmpty) _buildInfoRow(context, theme, Icons.park_outlined, AppStrings.characterWandWood, character.wand!.wood, accentColor),
             if (character.wand!.core.isNotEmpty) _buildInfoRow(context, theme, Icons.flare_outlined, AppStrings.characterWandCore, character.wand!.core, accentColor),
             if (character.wand!.length != null) _buildInfoRow(context, theme, Icons.straighten_outlined, AppStrings.characterWandLength, '${character.wand!.length} ${AppStrings.inchUnit}', accentColor),
           ],
         ),

       if (character.patronus.isNotEmpty)
         _buildInfoSection(
           context, theme, isDark, AppStrings.characterInfoPatronus, primaryColor, accentColor,
           [
             _buildInfoRow(context, theme, Icons.shield_moon_outlined, AppStrings.characterPatronusLabel, character.patronus, accentColor),
           ],
         ),

       if (character.hogwartsStudent || character.hogwartsStaff)
         _buildInfoSection(
           context, theme, isDark, AppStrings.characterInfoHogwarts, primaryColor, accentColor,
           [
             _buildInfoRow(context, theme, Icons.school_outlined, AppStrings.characterIsStudent, character.hogwartsStudent ? AppStrings.yes : AppStrings.no, accentColor),
             _buildInfoRow(context, theme, Icons.work_outline, AppStrings.characterIsStaff, character.hogwartsStaff ? AppStrings.yes : AppStrings.no, accentColor),
           ],
         ),

       if (character.actor.isNotEmpty || character.alternateActors.isNotEmpty)
         _buildInfoSection(
           context, theme, isDark, AppStrings.characterInfoFilm, primaryColor, accentColor,
           [
             if (character.actor.isNotEmpty) _buildInfoRow(context, theme, Icons.person_outline, AppStrings.characterActor, character.actor, accentColor),
             if (character.alternateActors.isNotEmpty) _buildInfoRow(context, theme, Icons.people_outline, AppStrings.characterAlternateActors, character.alternateActors.join(", "), accentColor),
           ],
         ),
    ];
  }

  Widget _buildInfoSection(BuildContext context, ThemeData theme, bool isDark, String title, Color primaryColor, Color accentColor, List<Widget> children) {
    final validChildren = children.where((w) => w is! SizedBox || (w.height == null)).toList();
    if (validChildren.isEmpty) return const SizedBox.shrink();
    
    final sectionBgColor = primaryColor.withOpacity(isDark ? 0.08 : 0.05);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall + 2),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge, vertical: AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: sectionBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all( 
          color: accentColor.withOpacity(isDark ? 0.3 : 0.2),
          width: AppDimensions.cardBorderWidth - 0.5,
        ),
         boxShadow: [
           BoxShadow(
             color: theme.shadowColor.withOpacity(0.05),
             blurRadius: 5,
             offset: const Offset(0, 2),
           )
         ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(color: accentColor, fontSize: 18),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          ...validChildren,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, ThemeData theme, IconData icon, String label, String value, Color accentColor) {
    final labelStyle = AppTextStyles.detailLabel.copyWith(color: accentColor.withOpacity(0.9));
    final valueStyle = AppTextStyles.detailValue(context);

    if (value.isEmpty || value == 'null') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconSizeMedium, color: accentColor.withOpacity(0.8)),
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