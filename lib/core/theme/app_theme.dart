import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Temel Renkler
  static const Color primarySeed = Color(0xFF3A2A1D); // Koyu Kahverengi (Parşömen/Ahşap)
  static const Color gryffindorRed = Color(0xFF740001);
  static const Color goldAccent = Color(0xFFD3A625);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.light,
      primary: gryffindorRed,
      secondary: goldAccent,
      background: const Color(0xFFFDF8E1), // Açık Parşömen rengi
      surface: const Color(0xFFFDF8E1), // Açık Parşömen rengi
    ),
    appBarTheme: AppBarTheme(
      elevation: 1, // Hafif bir gölge
      centerTitle: true,
      backgroundColor: gryffindorRed, // AppBar Gryffindor Kırmızısı
      foregroundColor: Colors.white, // AppBar yazı rengi beyaz
      iconTheme: const IconThemeData(color: Colors.white), // Geri butonu vb. ikonlar için
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith( // Durum çubuğu stili
        statusBarColor: Colors.transparent, // Şeffaf arka plan (AppBar rengi görünür)
        statusBarIconBrightness: Brightness.light, // Durum çubuğu ikonları (saat, pil vb.) açık renk
        statusBarBrightness: Brightness.dark, // iOS için durum çubuğu metni
      ),
      titleTextStyle: GoogleFonts.cinzelDecorative( // Tematik başlık fontu
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    tabBarTheme: TabBarTheme( // TabBar özelleştirmesi
      labelColor: goldAccent,
      unselectedLabelColor: Colors.white.withOpacity(0.7),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // Hafif vurgu rengi
        borderRadius: BorderRadius.circular(8.0), // Yuvarlak köşeler
      ),
      labelStyle: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 11),
      unselectedLabelStyle: GoogleFonts.lato(fontSize: 11),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: gryffindorRed,
      indicatorColor: goldAccent.withOpacity(0.9),
      height: 65,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: primarySeed, size: 26);
        }
        return IconThemeData(color: Colors.white.withOpacity(0.8), size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final style = GoogleFonts.lato(fontSize: 11);
        if (states.contains(WidgetState.selected)) {
          return style.copyWith(fontWeight: FontWeight.bold, color: primarySeed);
        }
        return style.copyWith(color: Colors.white.withOpacity(0.8));
      }),
      elevation: 3,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: gryffindorRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0, // Gölge kaldırıldı
      clipBehavior: Clip.antiAlias, // Kenarları yuvarlatılmış resimler için
      color: const Color(0xFFF5EFE0), // Biraz daha koyu parşömen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.goldAccent, width: 2.0), // Çerçeve rengi ve kalınlığı güncellendi
      ),
    ),
    textTheme: GoogleFonts.latoTextTheme(), // Ana metin fontu Lato
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.dark,
      primary: gryffindorRed,
      secondary: goldAccent,
      background: const Color(0xFF1A120B), // Çok koyu kahverengi/siyah
      surface: const Color(0xFF2C211A), // Koyu yüzey rengi
    ),
    appBarTheme: AppBarTheme(
      elevation: 1,
      centerTitle: true,
      backgroundColor: gryffindorRed,
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith( // Durum çubuğu stili (Karanlık tema için de light ikonlar)
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: GoogleFonts.cinzelDecorative( // Tematik başlık fontu
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    tabBarTheme: TabBarTheme( // TabBar özelleştirmesi
      labelColor: goldAccent,
      unselectedLabelColor: Colors.white.withOpacity(0.7),
      indicatorColor: goldAccent,
      indicatorSize: TabBarIndicatorSize.tab, // Gösterge boyutu tab'ın genişliği kadar
      labelStyle: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 11), // Etiket font boyutu ayarlandı
      unselectedLabelStyle: GoogleFonts.lato(fontSize: 11), // Etiket font boyutu ayarlandı
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: ColorScheme.fromSeed(seedColor: primarySeed, brightness: Brightness.dark).surface.withOpacity(0.5), // Koyu tema arkaplanı
      indicatorColor: goldAccent.withOpacity(0.9),
      height: 65,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: primarySeed, size: 26);
        }
        return IconThemeData(color: Colors.white.withOpacity(0.8), size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final style = GoogleFonts.lato(fontSize: 11);
        if (states.contains(WidgetState.selected)) {
          return style.copyWith(fontWeight: FontWeight.bold, color: primarySeed);
        }
        return style.copyWith(color: Colors.white.withOpacity(0.8));
      }),
      elevation: 3,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: gryffindorRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0, // Gölge kaldırıldı
      clipBehavior: Clip.antiAlias,
      color: const Color(0xFF3A2E25), // Koyu kart rengi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.goldAccent, width: 2.0), // Çerçeve rengi ve kalınlığı güncellendi
      ),
    ),
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme, // Karanlık tema için Lato
    ),
  );

  // Hogwarts evleri renkleri (Bunları ColorScheme içinde de kullanabiliriz veya direkt erişebiliriz)
  static const gryffindorPrimary = Color(0xFF740001);
  static const gryffindorSecondary = Color(0xFFD3A625);
  static const slytherinPrimary = Color(0xFF1A472A);
  static const slytherinSecondary = Color(0xFF5D5D5D);
  static const ravenclawPrimary = Color(0xFF0E1A40);
  static const ravenclawSecondary = Color(0xFF946B2D);
  static const hufflepuffPrimary = Color(0xFFFFD800);
  static const hufflepuffSecondary = Color(0xFF000000);

  // Ek Renkler
  static const Color favoriteRed = Colors.redAccent; // Favori ikonu için
} 