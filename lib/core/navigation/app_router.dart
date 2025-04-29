import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/characters_screen.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/screens/spells_screen.dart';
import 'package:harry_potter_character_compendium/features/favorites/presentation/screens/profile_screen.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

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
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          if (navigationShell.currentIndex != index) {
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
          }
        },
        backgroundColor: isDark ? colors.surface.withOpacity(0.5) : AppTheme.gryffindorRed,
        indicatorColor: Colors.white.withOpacity(0.15), // Hafif beyaz arka plan
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: const Duration(milliseconds: 500),
        
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.white),
            selectedIcon: Icon(Icons.person, color: AppTheme.goldAccent),
            label: 'Karakterler',
            tooltip: 'Karakterleri Görüntüle',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_fix_high_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.auto_fix_high, color: AppTheme.goldAccent),
            label: 'Büyüler',
            tooltip: 'Büyüleri Görüntüle',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.white),
            selectedIcon: Icon(Icons.person, color: AppTheme.goldAccent),
            label: 'Profil',
            tooltip: 'Profili Görüntüle',
          ),
        ],
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
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
    );
  }
} 