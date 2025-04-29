import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart'; // Renkler için

// Uygulama genelinde kullanılacak metin stilleri
class AppTextStyles {

  // Ana Font Aileleri (AppTheme'deki textTheme üzerine kurulu)
  static final String _primaryFontFamily = GoogleFonts.lato().fontFamily ?? 'sans-serif';
  static final String _decorativeFontFamily = GoogleFonts.cinzelDecorative().fontFamily ?? 'serif';

  // Genel Stil Oluşturucu (Tekrarlanan kodları azaltmak için)
  static TextStyle _baseStyle(String fontFamily, FontWeight fontWeight, double fontSize, Color color, {TextDecoration? decoration, double? height}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  // --- Cinzel Decorative (Başlıklar, Vurgular) ---
  static final TextStyle screenTitle = GoogleFonts.cinzelDecorative(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Genellikle AppBar'da kullanılır
  );

  static final TextStyle sectionTitle = GoogleFonts.cinzelDecorative(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppTheme.goldAccent, // Genellikle altın rengi
  );

  static final TextStyle cardTitleLarge = GoogleFonts.cinzelDecorative(
    fontSize: 18, 
    fontWeight: FontWeight.bold, 
    color: Colors.white, // Genellikle koyu gradient/resim üzerinde, beyaz kalabilir
    // Gölge rengi tema veya AppTheme'den alınmalı
    shadows: [Shadow(blurRadius: 2.0, color: AppTheme.primarySeed.withOpacity(0.6))] // Daha tematik gölge
  );
    static final TextStyle cardTitleSmall = GoogleFonts.cinzelDecorative(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Genellikle koyu gradient/resim üzerinde, beyaz kalabilir
     // Gölge rengi tema veya AppTheme'den alınmalı
    shadows: [Shadow(blurRadius: 1.0, color: AppTheme.primarySeed.withOpacity(0.6))] // Daha tematik gölge
  );

  // --- Lato (Ana Metinler, Açıklamalar, Butonlar) ---

  // Detay Ekranı Stilleri
  static final TextStyle detailLabel = GoogleFonts.lato(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppTheme.goldAccent, // Vurgu rengiyle etiket
  );

  static TextStyle detailValue(BuildContext context) { 
     final theme = Theme.of(context);
     return GoogleFonts.lato(
       fontSize: 15,
       height: 1.3,
        // Artık doğrudan tema rengi kullanılıyor
       color: theme.colorScheme.onSurface.withOpacity(0.87),
     );
  }

  // Kart İçeriği Stilleri
  static final TextStyle cardSubtitle = GoogleFonts.lato(
    fontSize: 12,
    // Bu stilin kullanıldığı yere göre renk tema'dan alınabilir, şimdilik beyaz
    color: Colors.white.withOpacity(0.85), 
  );

  // Filtreleme Diyaloğu Stilleri
   static TextStyle filterChip(BuildContext context, bool isSelected) { 
     final theme = Theme.of(context);
     final Color textColor = isSelected 
       ? AppTheme.gryffindorPrimary // Seçili metin rengi
       : theme.colorScheme.onPrimary; // Seçili olmayan metin rengi (Dialog BG'si primary varsayılırsa)
     return GoogleFonts.lato(
       color: textColor,
       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
     );
  }

  // Diğer Genel Stiller
  static TextStyle bodyRegular(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium ?? TextStyle(fontFamily: _primaryFontFamily, fontSize: 14);
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall ?? TextStyle(fontFamily: _primaryFontFamily, fontSize: 12);
  }

  static TextStyle button(BuildContext context) {
     return Theme.of(context).textTheme.labelLarge ?? TextStyle(fontFamily: _primaryFontFamily, fontWeight: FontWeight.bold, fontSize: 14);
  }
  
  static TextStyle errorText(BuildContext context) {
     return GoogleFonts.lato(
       fontSize: 16,
       color: Theme.of(context).colorScheme.error, // Hata rengi
     );
  }
  
   static TextStyle emptyListText(BuildContext context) {
     final theme = Theme.of(context);
     return GoogleFonts.lato(
       fontSize: 18, 
       // Tema rengi kullanıldı
       color: theme.colorScheme.onSurface.withOpacity(0.6)
     );
   }

} 