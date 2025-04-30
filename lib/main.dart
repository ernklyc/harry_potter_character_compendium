import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';
import 'package:harry_potter_character_compendium/core/navigation/app_router.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';

// Uygulama çökmelerini yakalayacak olan fonksiyon
void _handleError(Object error, StackTrace stack) {
  // Burada hata günlüğü tutabilir veya bir analitik servise gönderebilirsiniz
  debugPrint('Yakalanan hata: $error');
  debugPrint('Stack trace: $stack');
}

Future<void> main() async {
  // Zone içinde çalıştırarak yakalanmamış tüm hataları ele al
  runZonedGuarded(() async {
    // Flutter bağlamını aynı zone içinde başlat
    WidgetsFlutterBinding.ensureInitialized();

    // Android sistem navigasyon çubuğunu tamamen şeffaf yap
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,       // Alt çubuğun arka planı
        systemNavigationBarDividerColor: Colors.transparent, // Ayrıcı da şeffaf
        systemNavigationBarIconBrightness: Brightness.light, // İkon renkleri (ikonlar beyaz)
      ),
    );

    // Uygulama başlamadan dili yükle
    await AppStrings.loadLanguage();

    // FlutterFramework hatalarını yakalamak için
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _handleError(details.exception, details.stack ?? StackTrace.empty);
    };

    // Platform kaynaklı asenkron hataları yakala
    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      _handleError(error, stack);
      return true;
    };

    // Uygulamayı çalıştır
    runApp(
      ProviderScope(
        overrides: [
          // currentLanguageProvider'ı yüklenen dil ile başlat
          currentLanguageProvider.overrideWith((ref) => AppStrings.getCurrentLanguage()),
        ],
        child: const MyApp(),
      ),
    );
  }, _handleError);
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Harry Potter Karakter Ansiklopedisi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      // Scaffold gövdesinin, alt çubuğun altına uzaması için
      builder: (context, router) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: router!,
        );
      },
    );
  }
}
