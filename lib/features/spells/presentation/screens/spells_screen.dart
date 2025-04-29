import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harry_potter_character_compendium/features/spells/domain/providers/spells_providers.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_list.dart';

class SpellsScreen extends ConsumerWidget {
  const SpellsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSpells = ref.watch(allSpellsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Büyüler'),
      ),
      body: allSpells.when(
        data: (spells) => SpellList(spells: spells),
        loading: () => const SpellList(
          spells: [],
          isLoading: true,
        ),
        error: (err, stack) => SpellList(
          spells: [],
          errorMessage: 'Büyüler yüklenirken bir hata oluştu: $err',
        ),
      ),
    );
  }
} 