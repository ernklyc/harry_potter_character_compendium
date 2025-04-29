import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/core/navigation/app_router.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'dart:async';

// Uygulama çökmelerini yakalayacak olan fonksiyon
void _handleError(Object error, StackTrace stack) {
  // Burada hata günlüğü tutabilir veya bir analitik servise gönderebilirsiniz
  debugPrint('Yakalanan hata: $error');
  debugPrint('Stack trace: $stack');
}

Future<void> main() async {
  // Flutter bağlamını başlat
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tüm hataları yakalamak için bir hata yakalayıcı ekle
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    _handleError(details.exception, details.stack ?? StackTrace.empty);
  };
  
  // Platformdan gelen asenkron hataları yakala
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    _handleError(error, stack);
    return true;
  };
  
  // Zone içinde çalıştırarak yakalanmamış tüm hataları ele al
  runZonedGuarded(() {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  }, _handleError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Harry Potter Karakter Ansiklopedisi',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
