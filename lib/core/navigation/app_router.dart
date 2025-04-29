import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/characters_screen.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/screens/spells_screen.dart';

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
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Karakterler',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_fix_high_outlined),
            selectedIcon: Icon(Icons.auto_fix_high),
            label: 'Büyüler',
          ),
        ],
      ),
    );
  }
} 