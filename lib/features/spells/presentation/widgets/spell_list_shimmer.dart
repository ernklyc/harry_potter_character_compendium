import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SpellListShimmer extends StatelessWidget {
  const SpellListShimmer({super.key});

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
      child: ListView.builder(
        itemCount: 8, // Ekrana sığacak kadar placeholder göster
        itemBuilder: (context, index) {
          return Card(
             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
             color: cardColor,
             child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Placeholder for icon
                    Container(
                      width: 30,
                      height: 30,
                      color: Colors.white,
                      margin: const EdgeInsets.only(right: 16),
                    ),
                    // Placeholder for text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: 150, // Daha uzun isim
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 8),
                          ),
                          Container(
                            height: 12,
                            width: double.infinity, // Açıklama
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          );
        },
      ),
    );
  }
} 