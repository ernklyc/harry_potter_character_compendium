import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';
import 'package:harry_potter_character_compendium/core/widgets/error_display.dart';
import 'package:harry_potter_character_compendium/features/spells/domain/providers/spells_providers.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_card.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_list_shimmer.dart';

class SpellsScreen extends ConsumerWidget {
  const SpellsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSpellsAsync = ref.watch(allSpellsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Büyüler'),
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
      ),
      body: allSpellsAsync.when(
        data: (spells) {
          if (spells.isEmpty) {
            return RefreshIndicator(
               onRefresh: () => ref.refresh(allSpellsProvider.future),
               child: const Center(
                child: Text('Gösterilecek büyü bulunamadı.'),
               ),
             );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(allSpellsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: spells.length,
              itemBuilder: (context, index) {
                final spell = spells[index];
                return SpellCard(spell: spell)
                    .animate()
                    .fadeIn(duration: 200.ms, delay: (30 * index).ms)
                    .slideY(begin: 0.05, duration: 200.ms, curve: Curves.easeOut);
              },
            ),
          );
        },
        loading: () => const SpellListShimmer(),
        error: (err, stack) => RefreshIndicator(
           onRefresh: () => ref.refresh(allSpellsProvider.future),
           child: ErrorDisplay(
            message: 'Büyüler yüklenirken bir hata oluştu.',
            onRetry: () => ref.invalidate(allSpellsProvider),
          ),
        ),
      ),
    );
  }
} 