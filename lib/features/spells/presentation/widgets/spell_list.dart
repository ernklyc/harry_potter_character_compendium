import 'package:flutter/material.dart';
import 'package:harry_potter_character_compendium/features/spells/data/models/spell_model.dart';
import 'package:harry_potter_character_compendium/features/spells/presentation/widgets/spell_card.dart';

class SpellList extends StatelessWidget {
  final List<Spell> spells;
  final Function(Spell)? onSpellTap;
  final bool isLoading;
  final String? errorMessage;

  const SpellList({
    super.key,
    required this.spells,
    this.onSpellTap,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (spells.isEmpty) {
      return const Center(
        child: Text('Büyü bulunamadı'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spells.length,
      itemBuilder: (context, index) {
        final spell = spells[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SpellCard(
            spell: spell,
            onTap: onSpellTap != null ? () => onSpellTap!(spell) : null,
          ),
        );
      },
    );
  }
} 