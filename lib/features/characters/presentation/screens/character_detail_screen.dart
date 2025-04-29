import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';

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
      default: return Colors.grey[800]!; // Default renk biraz daha koyu
    }
  }

   Color _getHouseAccentColor(String house) {
     switch (house.toLowerCase()) {
      case 'gryffindor': return AppTheme.gryffindorSecondary;
      case 'slytherin': return AppTheme.slytherinSecondary;
      case 'ravenclaw': return AppTheme.ravenclawSecondary;
      case 'hufflepuff': return AppTheme.hufflepuffSecondary;
      default: return AppTheme.goldAccent; // Varsayılan vurgu rengi altın sarısı
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterDetailAsync = ref.watch(characterDetailProvider(characterId));
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Ana arkaplan rengi
      body: characterDetailAsync.when(
        data: (character) {
          if (character == null) {
            return const Center(
              child: ErrorDisplay(message: 'Karakter bulunamadı.'),
            );
          }

          final primaryColor = _getHouseColor(character.house);
          final accentColor = _getHouseAccentColor(character.house);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 380.0, // Biraz daha yüksek
                pinned: true,
                floating: false,
                stretch: true,
                elevation: 0, // AppBar gölgesi yok
                backgroundColor: primaryColor, 
                iconTheme: const IconThemeData(color: Colors.white), // Geri butonu beyaz
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16), // Padding ayarlandı
                  title: Text(
                    character.name,
                    style: GoogleFonts.cinzelDecorative(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // Gölge kaldırıldı
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
                                alignment: Alignment.topCenter, // Hizalamayı üst-orta olarak değiştir
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
                      // Başlık okunabilirliği için gradient overlay
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                              primaryColor.withOpacity(0.7), // Daha belirgin geçiş
                            ],
                            stops: const [0.4, 0.7, 1.0], // Stoplar ayarlandı
                          ),
                        ),
                      ),
                    ],
                  ),
                  stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
                ),
              ),
              // Bilgi Alanı
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Bilgi bölümleri
                    _buildInfoSection(
                      context,
                      'Temel Bilgiler',
                      primaryColor,
                      accentColor,
                      [
                        if (character.alternateNames.isNotEmpty) _buildInfoRow(context, Icons.theater_comedy, 'Diğer İsimler', character.alternateNames.join(", "), accentColor),
                        if (character.house.isNotEmpty) _buildInfoRow(context, Icons.home_filled, 'Ev', character.house, accentColor),
                        if (character.species.isNotEmpty) _buildInfoRow(context, Icons.pets, 'Tür', character.species, accentColor),
                        if (character.gender.isNotEmpty) _buildInfoRow(context, Icons.transgender, 'Cinsiyet', character.gender, accentColor),
                        if (character.dateOfBirth != null) _buildInfoRow(context, Icons.cake, 'Doğum Tarihi', character.dateOfBirth!, accentColor),
                        if (character.yearOfBirth != null) _buildInfoRow(context, Icons.calendar_today, 'Doğum Yılı', character.yearOfBirth.toString(), accentColor),
                        _buildInfoRow(context, Icons.auto_awesome, 'Büyücü', character.wizard ? 'Evet' : 'Hayır', accentColor),
                        if (character.ancestry.isNotEmpty) _buildInfoRow(context, Icons.bloodtype, 'Soy', character.ancestry, accentColor),
                        _buildInfoRow(context, Icons.favorite, 'Hayatta Mı', character.alive ? 'Evet' : 'Hayır', accentColor),
                      ],
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),

                    if (character.eyeColour.isNotEmpty || character.hairColour.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Fiziksel Özellikler',
                        primaryColor,
                        accentColor,
                        [
                          if (character.eyeColour.isNotEmpty) _buildInfoRow(context, Icons.visibility, 'Göz Rengi', character.eyeColour, accentColor),
                          if (character.hairColour.isNotEmpty) _buildInfoRow(context, Icons.brush, 'Saç Rengi', character.hairColour, accentColor),
                        ],
                      ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

                    if (character.wand != null && (character.wand!.wood.isNotEmpty || character.wand!.core.isNotEmpty || character.wand!.length != null))
                      _buildInfoSection(
                        context,
                        'Asa Bilgileri',
                        primaryColor,
                        accentColor,
                        [
                          if (character.wand!.wood.isNotEmpty) _buildInfoRow(context, Icons.park_outlined, 'Odun', character.wand!.wood, accentColor),
                          if (character.wand!.core.isNotEmpty) _buildInfoRow(context, Icons.flash_on_outlined, 'Öz', character.wand!.core, accentColor),
                          if (character.wand!.length != null) _buildInfoRow(context, Icons.straighten_outlined, 'Uzunluk', '${character.wand!.length} inç', accentColor),
                        ],
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                    if (character.patronus.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Patronus',
                        primaryColor,
                        accentColor,
                        [
                          _buildInfoRow(context, Icons.shield_moon_outlined, 'Patronus', character.patronus, accentColor),
                        ],
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

                    _buildInfoSection(
                      context,
                      'Hogwarts Bilgileri',
                      primaryColor,
                      accentColor,
                      [
                        _buildInfoRow(context, Icons.school, 'Hogwarts Öğrencisi', character.hogwartsStudent ? 'Evet' : 'Hayır', accentColor),
                        _buildInfoRow(context, Icons.work, 'Hogwarts Personeli', character.hogwartsStaff ? 'Evet' : 'Hayır', accentColor),
                      ],
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1),

                    if (character.actor.isNotEmpty || character.alternateActors.isNotEmpty)
                      _buildInfoSection(
                        context,
                        'Film Bilgileri',
                        primaryColor,
                        accentColor,
                        [
                          if (character.actor.isNotEmpty) _buildInfoRow(context, Icons.person, 'Aktör', character.actor, accentColor),
                          if (character.alternateActors.isNotEmpty) _buildInfoRow(context, Icons.people, 'Diğer Aktörler', character.alternateActors.join(", "), accentColor),
                        ],
                      ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.1),

                    const SizedBox(height: 20), // Alt boşluk
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
              CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 20),
              Text('Karakter bilgileri yükleniyor...', style: GoogleFonts.lato(fontSize: 16)),
            ],
          )
        ),
        error: (err, stack) => ErrorDisplay(
          message: 'Karakter yüklenirken bir hata oluştu.',
          onRetry: () => ref.invalidate(characterDetailProvider(characterId)),
        ),
      ),
    );
  }

  // Bilgi bölümü widget'ı - Card yerine Container ve BoxDecoration ile
  Widget _buildInfoSection(BuildContext context, String title, Color primaryColor, Color accentColor, List<Widget> children) {
    final validChildren = children.where((w) => w is! SizedBox || (w is SizedBox && w.height == null)).toList();
    if (validChildren.isEmpty) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final sectionBgColor = primaryColor.withOpacity(isDark ? 0.1 : 0.04); // Çok hafif arkaplan

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12), // Bölümler arası boşluk
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // İç boşluk
      decoration: BoxDecoration(
        color: sectionBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all( // Vurgu rengiyle kenarlık
          color: accentColor.withOpacity(isDark ? 0.5 : 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cinzelDecorative(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accentColor, // Başlık vurgu rengi
              // Gölge kaldırıldı
            ),
          ),
          const SizedBox(height: 10), // Başlık altı boşluk
          ...validChildren, // Bilgi satırları
        ],
      ),
    );
  }

  // Bilgi satırı widget'ı - RichText ile
  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, Color accentColor) {
    final theme = Theme.of(context);
    final labelStyle = GoogleFonts.lato(
      color: accentColor, // Etiket rengi vurgulu
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final valueStyle = GoogleFonts.lato(
      color: theme.colorScheme.onSurface.withOpacity(0.85), // Değer rengi daha okunaklı
      fontSize: 15,
      height: 1.3, // Satır yüksekliği
    );

    if (value.isEmpty || value == 'null') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0), // Satırlar arası boşluk
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: accentColor.withOpacity(0.9)), // İkon rengi vurgulu
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style, // Varsayılan stil temel alınsın
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