import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart'; // Character modeli için

class CharacterDetailScreen extends ConsumerWidget {
  final String characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  // Renk yardımcı fonksiyonları (AppTheme'den alınabilir veya burada kalabilir)
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
  Widget build(BuildContext context, WidgetRef ref) {
    final characterDetailAsync = ref.watch(characterDetailProvider(characterId));

    return Scaffold(
      // AppBar kaldırıldı, CustomScrollView kullanılacak
      body: characterDetailAsync.when(
        data: (character) {
          if (character == null) {
            return const Center(
              child: ErrorDisplay(message: 'Karakter bulunamadı.'),
            );
          }

          final houseColor = _getHouseColor(character.house);
          final houseAccentColor = _getHouseAccentColor(character.house);
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          final screenWidth = MediaQuery.of(context).size.width;
          // Use Gryffindor colors as a base if house is unknown - REVERTED
          // final primaryColor = character.house.isNotEmpty ? houseColor : AppTheme.gryffindorPrimary;
          // final accentColor = character.house.isNotEmpty ? houseAccentColor : AppTheme.goldAccent;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0, // REVERTED
                pinned: true,
                floating: false,
                stretch: true,
                backgroundColor: houseColor, // REVERTED
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    character.name,
                    style: GoogleFonts.cinzelDecorative(
                      color: Colors.white, // REVERTED
                      fontSize: 18, // REVERTED
                      fontWeight: FontWeight.bold,
                      shadows: [ // REVERTED
                        Shadow(blurRadius: 2.0, color: Colors.black.withOpacity(0.7))
                      ]
                    ),
                    // textAlign: TextAlign.center, // REVERTED
                  ),
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16.0), // REVERTED
                  background: Hero( // REVERTED structure
                    tag: 'character_image_${character.id}',
                    child: character.image != null && character.image!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: character.image!,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            placeholder: (context, url) => Container(color: Colors.grey[400]), // REVERTED placeholder
                            errorWidget: (context, url, error) => Container( // REVERTED error
                              color: Colors.grey[400],
                              child: Icon(Icons.person, size: 150, color: Colors.grey[600]),
                            ),
                          )
                        : Container( // REVERTED fallback
                            color: Colors.grey[400],
                            child: Icon(Icons.person, size: 150, color: Colors.grey[600]),
                          ),
                  ),
                  // Removed Stack and Gradient Overlay
                  stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
                ),
                iconTheme: IconThemeData(
                  color: Colors.white, // REVERTED
                  shadows: [Shadow(blurRadius: 1.0, color: Colors.black.withOpacity(0.5))] // REVERTED
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                   decoration: BoxDecoration(
                     gradient: LinearGradient( // REVERTED gradient
                       colors: [
                         houseColor.withOpacity(isDark ? 0.2 : 0.05),
                         Theme.of(context).colorScheme.background,
                         Theme.of(context).colorScheme.background,
                       ],
                       stops: const [0.0, 0.3, 1.0],
                       begin: Alignment.topCenter,
                       end: Alignment.bottomCenter,
                     )
                   ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // REVERTED padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20), // REVERTED spacing
                        _buildInfoSection( // REVERTED call structure
                          context,
                          'Temel Bilgiler',
                          houseAccentColor, // REVERTED accent usage
                          [ // REVERTED _buildInfoRow calls without accentColor param
                            if (character.alternateNames.isNotEmpty) _buildInfoRow(context, Icons.theater_comedy, 'Diğer İsimler', character.alternateNames.join(", ")),
                            if (character.house.isNotEmpty) _buildInfoRow(context, Icons.home_filled, 'Ev', character.house),
                            if (character.species.isNotEmpty) _buildInfoRow(context, Icons.pets, 'Tür', character.species),
                            if (character.gender.isNotEmpty) _buildInfoRow(context, Icons.transgender, 'Cinsiyet', character.gender),
                            if (character.dateOfBirth != null) _buildInfoRow(context, Icons.cake, 'Dogum Tarihi', character.dateOfBirth!),
                            if (character.yearOfBirth != null) _buildInfoRow(context, Icons.calendar_today, 'Dogum Yılı', character.yearOfBirth.toString()),
                            _buildInfoRow(context, Icons.auto_awesome, 'Büyücü', character.wizard ? 'Evet' : 'Hayır'),
                            if (character.ancestry.isNotEmpty) _buildInfoRow(context, Icons.bloodtype, 'Soy', character.ancestry),
                            _buildInfoRow(context, Icons.favorite, 'Hayatta Mı', character.alive ? 'Evet' : 'Hayır'),
                          ]
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                        const SizedBox(height: 20), // REVERTED
                        // Check only based on presence, not combined - REVERTED logic structure
                        _buildInfoSection(
                          context,
                          'Fiziksel Özellikler',
                          houseAccentColor,
                          [
                            if (character.eyeColour.isNotEmpty) _buildInfoRow(context, Icons.visibility, 'Göz Rengi', character.eyeColour),
                            if (character.hairColour.isNotEmpty) _buildInfoRow(context, Icons.brush, 'Saç Rengi', character.hairColour),
                          ]
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

                         // REVERTED the conditional structure and spacing
                         if (character.wand != null && (character.wand!.wood.isNotEmpty || character.wand!.core.isNotEmpty || character.wand!.length != null))
                         const SizedBox(height: 20),
                         if (character.wand != null && (character.wand!.wood.isNotEmpty || character.wand!.core.isNotEmpty || character.wand!.length != null))
                            _buildInfoSection(
                              context,
                              'Asa Bilgileri',
                              houseAccentColor,
                              [
                                if (character.wand!.wood.isNotEmpty) _buildInfoRow(context, Icons.park_outlined, 'Odun', character.wand!.wood),
                                if (character.wand!.core.isNotEmpty) _buildInfoRow(context, Icons.flash_on_outlined, 'Öz', character.wand!.core),
                                if (character.wand!.length != null) _buildInfoRow(context, Icons.straighten_outlined, 'Uzunluk', '${character.wand!.length} inç'),
                              ],
                            ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                        // REVERTED the conditional structure and spacing
                        if (character.patronus.isNotEmpty)
                         const SizedBox(height: 20),
                        if (character.patronus.isNotEmpty)
                            _buildInfoSection(
                              context,
                              'Patronus',
                              houseAccentColor,
                              [
                                _buildInfoRow(context, Icons.shield_moon_outlined, 'Patronus', character.patronus),
                              ],
                            ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

                         const SizedBox(height: 20), // REVERTED
                        _buildInfoSection(
                          context,
                          'Hogwarts Bilgileri',
                          houseAccentColor,
                          [
                            _buildInfoRow(context, Icons.school, 'Hogwarts Öğrencisi', character.hogwartsStudent ? 'Evet' : 'Hayır'),
                            _buildInfoRow(context, Icons.work, 'Hogwarts Personeli', character.hogwartsStaff ? 'Evet' : 'Hayır'),
                          ],
                        ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),

                        // REVERTED the conditional structure and spacing
                        if (character.actor.isNotEmpty || character.alternateActors.isNotEmpty)
                          const SizedBox(height: 20),
                        if (character.actor.isNotEmpty || character.alternateActors.isNotEmpty)
                           _buildInfoSection(
                            context,
                            'Film Bilgileri',
                            houseAccentColor,
                            [
                              if (character.actor.isNotEmpty) _buildInfoRow(context, Icons.person, 'Aktör', character.actor),
                              if (character.alternateActors.isNotEmpty) _buildInfoRow(context, Icons.people, 'Diğer Aktörler', character.alternateActors.join(", ")),
                            ],
                          ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),

                        const SizedBox(height: 40), // REVERTED
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               CircularProgressIndicator(color: Theme.of(context).colorScheme.primary), // REVERTED
               const SizedBox(height: 20),
               Text('Karakter bilgileri yükleniyor...', style: GoogleFonts.lato()), // REVERTED
             ],
           )
        ),
        error: (err, stack) => ErrorDisplay(
          message: 'Karakter yüklenirken bir hata oluştu.',
          onRetry: () => ref.invalidate(characterDetailProvider(characterId)), // REVERTED
        ),
      ),
    );
  }

  // Bilgi bölümü için kart widget'ı - REVERTED to original signature and styling
  Widget _buildInfoSection(BuildContext context, String title, Color accentColor, List<Widget> children) {
    // REVERTED empty check
    if (children.isEmpty) return const SizedBox.shrink();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2, // REVERTED
      margin: const EdgeInsets.symmetric(vertical: 8), // REVERTED
      shape: RoundedRectangleBorder( // REVERTED
         borderRadius: BorderRadius.circular(10),
         side: BorderSide(color: accentColor.withOpacity(isDark ? 0.5 : 0.3), width: 1.5)
       ),
       // Removed background color
      child: Padding(
        padding: const EdgeInsets.all(16), // REVERTED
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // REVERTED Title style
            Text(
              title,
              style: GoogleFonts.cinzelDecorative(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
                 color: accentColor,
               ),
            ),
            // REVERTED Divider style
            Divider(color: accentColor.withOpacity(0.5), height: 16, thickness: 1),
            // REVERTED child spreading
            ...children,
          ],
        ),
      ),
    );
  }

  // Bilgi satırı widget'ı (ikonlu) - REVERTED to original signature and styling
  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
     // Removed style variables and empty check - REVERTED

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // REVERTED
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // REVERTED Icon style
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
          const SizedBox(width: 12), // REVERTED
          Expanded(
            child: Column( // REVERTED to Column layout
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // REVERTED Label style
                 Text(
                   label,
                   style: GoogleFonts.lato(
                     fontWeight: FontWeight.bold,
                     fontSize: 14,
                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9)
                   ),
                 ),
                 const SizedBox(height: 2), // REVERTED
                 // REVERTED Value style
                 Text(
                   value,
                   style: GoogleFonts.lato(
                     fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                   ),
                 ),
               ],
            ),
          ),
        ],
      ),
    );
  }
}