import 'package:flutter/material.dart';

// Uygulama genelinde kullanılacak boyut ve boşluk sabitleri
class AppDimensions {
  // Padding ve Margin Değerleri
  static const double paddingZero = 0.0;
  static const double paddingExtraSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 12.0;
  static const double paddingLarge = 16.0;
  static const double paddingExtraLarge = 24.0;
  static const double paddingPageHorizontal = paddingLarge;
  static const double paddingPageVertical = paddingExtraLarge;

  // Radius Değerleri
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 10.0;
  static const double radiusLarge = 12.0;
  static const double radiusExtraLarge = 16.0;
  static const double radiusCircular = 50.0; // Tamamen yuvarlak butonlar vb. için

  // İkon Boyutları
  static const double iconSizeExtraSmall = 12.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeExtraLarge = 30.0;

  // Diğer Boyutlar
  static const double cardElevation = 3.0;
  static const double cardBorderWidth = 1.5;
  static const double dividerThickness = 1.0;

  // EdgeInsets olarak hazır değerler (kolay kullanım için)
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: paddingPageHorizontal,
    vertical: paddingPageVertical,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(paddingLarge);
  static const EdgeInsets dialogPadding = EdgeInsets.all(paddingLarge);
   static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: paddingSmall, 
    vertical: paddingExtraSmall
  );
} 