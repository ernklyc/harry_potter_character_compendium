import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:harry_potter_character_compendium/core/theme/app_dimensions.dart';

class SpellListShimmer extends StatelessWidget {
  const SpellListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.grey[300]!;
    final shimmerBaseColor = Theme.of(context).colorScheme.surfaceVariant;
    final shimmerHighlightColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.1);

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
             margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge, vertical: AppDimensions.paddingSmall - 2),
             shape: Theme.of(context).cardTheme.shape ?? RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)
             ),
             color: cardColor,
             child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Row(
                  children: [
                    Container(
                      width: AppDimensions.iconSizeExtraLarge - 2,
                      height: AppDimensions.iconSizeExtraLarge - 2,
                      color: shimmerBaseColor,
                      margin: const EdgeInsets.only(right: AppDimensions.paddingLarge),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: AppDimensions.iconSizeMedium,
                            width: 150,
                            color: shimmerBaseColor,
                            margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                          ),
                          Container(
                            height: AppDimensions.iconSizeSmall,
                            width: double.infinity,
                            color: shimmerBaseColor,
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