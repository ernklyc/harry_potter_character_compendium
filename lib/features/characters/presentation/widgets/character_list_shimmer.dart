import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CharacterListShimmer extends StatelessWidget {
  const CharacterListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.grey[300]!;
    final shimmerBaseColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[300]!
        : Colors.grey[700]!;
    final shimmerHighlightColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey[100]!
        : Colors.grey[500]!;

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7, // Kartların en boy oranına göre ayarla
        ),
        itemCount: 6, // Ekrana sığacak kadar placeholder göster
        itemBuilder: (context, index) {
          return Card(
            color: cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Placeholder for image
                Container(
                  height: 150,
                  color: Colors.white, // Shimmer'ın etkili olması için düz renk
                ),
                // Placeholder for text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 12,
                        width: 100,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 10,
                        width: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 