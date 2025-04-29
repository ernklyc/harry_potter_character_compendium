import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/screens/character_detail_screen.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_list_shimmer.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';

class CharactersScreen extends ConsumerStatefulWidget {
  const CharactersScreen({super.key});

  @override
  ConsumerState<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends ConsumerState<CharactersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentTitle = "Karakterler"; // Başlangıç başlığı
  final List<String> _tabTitles = const ["Tümü", "Öğrenciler", "Personel", "Gryffindor"]; // Sekme başlıkları

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentTitle = _tabTitles[_tabController.index]; // İlk başlığı ayarla
    _tabController.addListener(_handleTabSelection); // Listener ekle
  }

  // Listener fonksiyonu
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Sekme değişimi henüz bitmediyse işlem yapma (opsiyonel)
    } else {
      // Sekme tamamen değiştiğinde başlığı güncelle
      setState(() {
        _currentTitle = _tabTitles[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection); // Listener'ı kaldır
    _tabController.dispose();
    super.dispose();
  }

  void _retryLoad(WidgetRef ref, int tabIndex) {
    switch (tabIndex) {
      case 0:
        ref.invalidate(allCharactersProvider);
        break;
      case 1:
        ref.invalidate(hogwartsStudentsProvider);
        break;
      case 2:
        ref.invalidate(hogwartsStaffProvider);
        break;
      case 3:
        ref.invalidate(houseCharactersProvider('gryffindor'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCharacters = ref.watch(allCharactersProvider);
    final hogwartsStudents = ref.watch(hogwartsStudentsProvider);
    final hogwartsStaff = ref.watch(hogwartsStaffProvider);
    final gryffindorCharacters = ref.watch(houseCharactersProvider('gryffindor'));

    void navigateToCharacterDetail(Character character) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailScreen(characterId: character.id),
        ),
      );
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                 opacity: animation,
                 child: child,
               );
            },
            child: Text(
              _currentTitle,
              key: ValueKey<String>(_currentTitle),
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.gryffindorPrimary.withOpacity(0.9),
                  AppTheme.gryffindorPrimary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppTheme.goldAccent, // Gryffindor altın rengi
            unselectedLabelColor: Colors.white, // Seçili olmayan beyaz
            indicator: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // Hafif beyaz arka plan
              borderRadius: BorderRadius.circular(8.0), // Yuvarlak köşeler
            ),
            tabs: const [
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'Tümü'),
              Tab(icon: Icon(Icons.school_outlined), text: 'Öğrenciler'),
              Tab(icon: Icon(Icons.work_outline), text: 'Personel'),
              Tab(icon: Icon(Icons.shield_outlined), text: 'Gryffindor'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            allCharacters.when(
              data: (characters) => RefreshIndicator(
                 onRefresh: () => ref.refresh(allCharactersProvider.future),
                 child: CharacterList(
                    characters: characters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
              ),
              loading: () => const CharacterListShimmer(),
              error: (err, stack) => RefreshIndicator(
                 onRefresh: () => ref.refresh(allCharactersProvider.future),
                 child: ErrorDisplay(
                    message: 'Karakterler yüklenemedi.',
                    onRetry: () => _retryLoad(ref, 0),
                  ),
              ),
            ),
            
            hogwartsStudents.when(
               data: (characters) => RefreshIndicator(
                 onRefresh: () => ref.refresh(hogwartsStudentsProvider.future),
                 child: CharacterList(
                    characters: characters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
              ),
              loading: () => const CharacterListShimmer(),
               error: (err, stack) => RefreshIndicator(
                 onRefresh: () => ref.refresh(hogwartsStudentsProvider.future),
                 child: ErrorDisplay(
                    message: 'Öğrenciler yüklenemedi.',
                    onRetry: () => _retryLoad(ref, 1),
                  ),
              ),
            ),
            
            hogwartsStaff.when(
               data: (characters) => RefreshIndicator(
                 onRefresh: () => ref.refresh(hogwartsStaffProvider.future),
                 child: CharacterList(
                    characters: characters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
              ),
              loading: () => const CharacterListShimmer(),
               error: (err, stack) => RefreshIndicator(
                 onRefresh: () => ref.refresh(hogwartsStaffProvider.future),
                 child: ErrorDisplay(
                    message: 'Personel yüklenemedi.',
                    onRetry: () => _retryLoad(ref, 2),
                  ),
              ),
            ),
            
            gryffindorCharacters.when(
               data: (characters) => RefreshIndicator(
                 onRefresh: () => ref.refresh(houseCharactersProvider('gryffindor').future),
                 child: CharacterList(
                    characters: characters,
                    onCharacterTap: navigateToCharacterDetail,
                  ),
              ),
              loading: () => const CharacterListShimmer(),
               error: (err, stack) => RefreshIndicator(
                 onRefresh: () => ref.refresh(houseCharactersProvider('gryffindor').future),
                 child: ErrorDisplay(
                    message: 'Gryffindor üyeleri yüklenemedi.',
                    onRetry: () => _retryLoad(ref, 3),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 