import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart'; // Boyutlar import edildi

class CharacterListShimmer extends StatelessWidget {
  const CharacterListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Renkler tema'dan alınır
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.grey[300]!;
    final shimmerBaseColor = Theme.of(context).colorScheme.surfaceVariant;
    final shimmerHighlightColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.1);

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: GridView.builder(
        // Padding ve spacing için sabitler kullanıldı
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.paddingMedium,
          mainAxisSpacing: AppDimensions.paddingMedium,
          // Gerçek kartın oranına yakın olmalı
          childAspectRatio: 0.7, 
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            color: cardColor,
             // Shape tema'dan alınabilir veya sabit
            shape: Theme.of(context).cardTheme.shape ?? RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)
             ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                   // Yükseklik kart tasarımına göre ayarlanmalı
                  height: 150, 
                  // Placeholder'ın rengi baseColor ile uyumlu olmalı
                  color: shimmerBaseColor, 
                ),
                Padding(
                   // Padding için sabit kullanıldı
                  padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: AppDimensions.iconSizeMedium, // Metin yüksekliğine yakın
                        width: double.infinity,
                        color: shimmerBaseColor,
                         // Margin için sabit kullanıldı
                        margin: const EdgeInsets.only(bottom: AppDimensions.paddingExtraSmall),
                      ),
                      Container(
                        height: AppDimensions.iconSizeSmall, // Metin yüksekliğine yakın
                        width: 100,
                        color: shimmerBaseColor,
                        margin: const EdgeInsets.only(bottom: AppDimensions.paddingExtraSmall),
                      ),
                      Container(
                        height: AppDimensions.iconSizeExtraSmall + 2, // Metin yüksekliğine yakın
                        width: 80,
                        color: shimmerBaseColor,
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