import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:harry_potter_character_compendium/features/characters/data/models/character_model.dart';
import 'package:harry_potter_character_compendium/features/characters/presentation/widgets/character_card.dart';
import 'package:harry_potter_character_compendium/core/localization/app_strings.dart';

class CharacterList extends StatelessWidget {
  final List<Character> characters;
  final Function(Character) onCharacterTap;

  const CharacterList({
    super.key,
    required this.characters,
    required this.onCharacterTap,
  });

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const Center(
        child: Text(AppStrings.characterNotFound),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return CharacterCard(
          character: character,
          onTap: () => onCharacterTap(character),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (100 * (index % 10)).ms)
        .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut);
      },
    );
  }
} 