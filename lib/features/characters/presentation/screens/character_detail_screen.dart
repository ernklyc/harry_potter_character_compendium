import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:harry_potter_character_compendium/features/characters/domain/providers/characters_providers.dart';

class CharacterDetailScreen extends ConsumerWidget {
  final String characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  Color _getHouseColor(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor':
        return const Color(0xFF740001);
      case 'slytherin':
        return const Color(0xFF1A472A);
      case 'ravenclaw':
        return const Color(0xFF0E1A40);
      case 'hufflepuff':
        return const Color(0xFFFFD800);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterDetail = ref.watch(characterDetailProvider(characterId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karakter Detayı'),
      ),
      body: characterDetail.when(
        data: (character) {
          if (character == null) {
            return const Center(
              child: Text('Karakter bulunamadı'),
            );
          }

          final houseColor = _getHouseColor(character.house);
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Karakter resmi
                Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: character.image != null && character.image!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: character.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.person, size: 120, color: Colors.grey),
                        )
                      : const Icon(Icons.person, size: 120, color: Colors.grey),
                ),
                
                // Karakter bilgileri
                Container(
                  color: houseColor.withAlpha((0.1 * 255).round()),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (character.alternateNames.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Diğer İsimler: ${character.alternateNames.join(", ")}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Temel bilgiler
                _buildInfoSection(
                  context,
                  'Temel Bilgiler',
                  [
                    if (character.house.isNotEmpty) _buildInfoRow('Ev', character.house),
                    if (character.species.isNotEmpty) _buildInfoRow('Tür', character.species),
                    if (character.gender.isNotEmpty) _buildInfoRow('Cinsiyet', character.gender),
                    if (character.dateOfBirth != null) _buildInfoRow('Doğum Tarihi', character.dateOfBirth!),
                    if (character.yearOfBirth != null) _buildInfoRow('Doğum Yılı', character.yearOfBirth.toString()),
                    _buildInfoRow('Büyücü', character.wizard ? 'Evet' : 'Hayır'),
                    if (character.ancestry.isNotEmpty) _buildInfoRow('Soy', character.ancestry),
                  ],
                ),
                
                // Fiziksel özellikler
                _buildInfoSection(
                  context,
                  'Fiziksel Özellikler',
                  [
                    if (character.eyeColour.isNotEmpty) _buildInfoRow('Göz Rengi', character.eyeColour),
                    if (character.hairColour.isNotEmpty) _buildInfoRow('Saç Rengi', character.hairColour),
                  ],
                ),
                
                // Asa bilgileri
                if (character.wand != null)
                  _buildInfoSection(
                    context,
                    'Asa Bilgileri',
                    [
                      if (character.wand!.wood.isNotEmpty) _buildInfoRow('Odun', character.wand!.wood),
                      if (character.wand!.core.isNotEmpty) _buildInfoRow('Öz', character.wand!.core),
                      if (character.wand!.length != null) _buildInfoRow('Uzunluk', '${character.wand!.length} inç'),
                    ],
                  ),
                
                // Patronus
                if (character.patronus.isNotEmpty)
                  _buildInfoSection(
                    context,
                    'Patronus',
                    [
                      _buildInfoRow('Patronus', character.patronus),
                    ],
                  ),
                
                // Hogwarts bilgileri
                _buildInfoSection(
                  context,
                  'Hogwarts Bilgileri',
                  [
                    _buildInfoRow('Hogwarts Öğrencisi', character.hogwartsStudent ? 'Evet' : 'Hayır'),
                    _buildInfoRow('Hogwarts Personeli', character.hogwartsStaff ? 'Evet' : 'Hayır'),
                  ],
                ),
                
                // Film bilgileri
                _buildInfoSection(
                  context,
                  'Film Bilgileri',
                  [
                    if (character.actor.isNotEmpty) _buildInfoRow('Aktör', character.actor),
                    if (character.alternateActors.isNotEmpty) _buildInfoRow('Diğer Aktörler', character.alternateActors.join(", ")),
                    _buildInfoRow('Hayatta Mı', character.alive ? 'Evet' : 'Hayır'),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text('Karakter yüklenirken bir hata oluştu: $err'),
        ),
      ),
    );
  }
  
  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 