import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/characters_screen.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/screens/spells_screen.dart';
import 'package:harry_potter_character_compendium/features/favorites/presentation/screens/profile_screen.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';

// Global ScrollController referansları
final charactersScrollController = ScrollController();
final spellsScrollController = ScrollController();
final favoritesScrollController = ScrollController();

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Karakterler sekmesi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) {
                  return const CharactersScreen();
                },
                routes: [
                  GoRoute(
                    path: 'character/:id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return CharacterDetailScreen(characterId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Büyüler sekmesi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/spells',
                builder: (context, state) => const SpellsScreen(),
              ),
            ],
          ),
          // Profil sekmesi
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Alt gezinti çubuğuna sahip temel iskelet yapısı
class ScaffoldWithNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  _ScaffoldWithNavBarState createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  // Çift tıklama algılaması için kullanılacak değişkenler
  int _lastTappedIndex = -1; // Son tıklanan buton indeksi
  DateTime _lastTapTime = DateTime.now(); // Son tıklama zamanı
  
  @override
  void initState() {
    super.initState();
    // Dil değişikliklerini dinlemek için listener ekle
    AppStrings.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    // Widget kaldırıldığında listener'ı kaldır
    AppStrings.removeListener(_onLanguageChanged);
    super.dispose();
  }

  // Dil değiştiğinde çağrılacak metod
  void _onLanguageChanged() {
    // Widget'ı yeniden çizmek için setState çağır
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarBackgroundColor = isDark ? colors.surface.withOpacity(0.5) : AppTheme.gryffindorRed;
    const double topCornerRadius = 20.0; // Üst köşe yuvarlaklık değeri

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: ClipPath( // NavigationBar'ı ClipPath ile sar
        clipper: TopRoundedClipper(topCornerRadius), // Özel clipper'ı kullan
        child: NavigationBar(
          height: 65 + topCornerRadius / 2, // Kırpılacak alanı hesaba katmak için yüksekliği biraz artırabiliriz
          backgroundColor: navBarBackgroundColor, // Arka plan rengini direkt ata
          indicatorColor: Colors.white.withOpacity(0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 500),
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            // Aynı sekmeye/butona tıklanıp tıklanmadığını kontrol et
            if (widget.navigationShell.currentIndex == index) {
              // Aynı sekmeye tıklandı, çift tıklama mı kontrol edelim
              final now = DateTime.now();
              final timeDiff = now.difference(_lastTapTime).inMilliseconds;
              
              if (_lastTappedIndex == index && timeDiff < 500) { // 500ms içinde çift tıklama
                // Çift tıklama tespit edildi, sayfa başına kaydır
                switch (index) {
                  case 0: // Karakterler sekmesi
                    print("Karakterler sekmesinde çift tıklama algılandı - başa sar");
                    // ScrollController'ı kullanarak sayfayı başa sar
                    if (charactersScrollController.hasClients) {
                      charactersScrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                    break;
                  case 1: // Büyüler sekmesi
                    print("Büyüler sekmesinde çift tıklama algılandı - başa sar");
                    // ScrollController'ı kullanarak sayfayı başa sar
                    if (spellsScrollController.hasClients) {
                      spellsScrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                    break;
                  case 2: // Favoriler sekmesi
                    print("Favoriler sekmesinde çift tıklama algılandı - başa sar");
                    // ScrollController'ı kullanarak sayfayı başa sar
                    if (favoritesScrollController.hasClients) {
                      favoritesScrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                    break;
                }
              }
              
              // Son tıklama bilgilerini güncelle
              _lastTappedIndex = index;
              _lastTapTime = now;
            } else {
              // Farklı sekmeye tıklandı, sekmeyi değiştir
              widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
              
              // Son tıklama bilgilerini güncelle
              _lastTappedIndex = index;
              _lastTapTime = DateTime.now();
            }
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.7)),
              selectedIcon: Icon(Icons.person, color: AppTheme.goldAccent),
              label: AppStrings.characters,
              tooltip: AppStrings.viewCharacters,
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_fix_high_outlined, color: Colors.white.withOpacity(0.7)),
              selectedIcon: Icon(Icons.auto_fix_high, color: AppTheme.goldAccent),
              label: AppStrings.spells,
              tooltip: AppStrings.viewSpells,
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border, color: Colors.white.withOpacity(0.7)),
              selectedIcon: Icon(Icons.favorite, color: AppTheme.goldAccent),
              label: AppStrings.favoritesTitle,
              tooltip: AppStrings.favoritesTitle,
            ),
          ],
          surfaceTintColor: Colors.transparent,
          elevation: 3, // İsteğe bağlı olarak elevation geri eklenebilir
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldAccent,
              );
            }
            return GoogleFonts.lato(
              fontSize: 11,
              color: Colors.white,
            );
          }),
        ),
      ),
    );
  }
}

// Sadece üst köşeleri yuvarlatan CustomClipper
class TopRoundedClipper extends CustomClipper<Path> {
  final double radius;

  TopRoundedClipper(this.radius);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height); // Sol alt köşe
    path.lineTo(0, radius); // Sol üste doğru düz çizgi (radius kadar aşağıda)
    // Sol üst köşe için yay
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0); // Üst kenar boyunca düz çizgi
    // Sağ üst köşe için yay
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height); // Sağ alta doğru düz çizgi
    path.close(); // Yolu kapat
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
} 