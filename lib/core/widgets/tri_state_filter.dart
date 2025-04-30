import 'package:flutter/material.dart';
import 'package:harry_potter_character_compendium/core/theme/app_theme.dart';

// Üç durumlu filtre değerleri için enum
enum TriState {
  none, // null - Fark etmez
  yes,  // true - Evet
  no    // false - Hayır
}

class TriStateFilter extends StatelessWidget {
  final String label;
  final TriState value;
  final Function(TriState) onChanged;
  final Color trueColor;
  final Color falseColor;
  
  const TriStateFilter({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.trueColor = Colors.green,
    this.falseColor = Colors.red,
  });
  
  // TriState değerine göre metin döndürür
  String _getTriStateText(TriState state) {
    switch (state) {
      case TriState.none:
        return "Fark Etmez";
      case TriState.yes:
        return "Evet";
      case TriState.no:
        return "Hayır";
    }
  }
  
  // TriState değerine göre renk döndürür
  Color _getTriStateColor(TriState state) {
    switch (state) {
      case TriState.none:
        return Colors.grey;
      case TriState.yes:
        return trueColor;
      case TriState.no:
        return falseColor;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.black.withOpacity(0.3) 
            : AppTheme.goldAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getTriStateColor(value).withOpacity(0.7),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : AppTheme.gryffindorRed,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _getTriStateColor(value).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getTriStateColor(value).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  _getTriStateText(value),
                  style: TextStyle(
                    color: _getTriStateColor(value),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(TriState.none),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: value == TriState.none
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: value == TriState.none
                            ? Colors.grey
                            : Colors.grey.withOpacity(0.3),
                        width: value == TriState.none ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      'Fark Etmez',
                      style: TextStyle(
                        fontSize: 12, 
                        color: isDark ? Colors.white : Colors.grey[800],
                        fontWeight: value == TriState.none ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(TriState.yes),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: value == TriState.yes
                          ? AppTheme.goldAccent.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: value == TriState.yes
                            ? AppTheme.goldAccent
                            : Colors.grey.withOpacity(0.3),
                        width: value == TriState.yes ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      'Evet',
                      style: TextStyle(
                        fontSize: 12,
                        color: value == TriState.yes 
                            ? AppTheme.goldAccent 
                            : (isDark ? Colors.white : Colors.grey[800]),
                        fontWeight: value == TriState.yes ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(TriState.no),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: value == TriState.no
                          ? AppTheme.gryffindorRed.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: value == TriState.no
                            ? AppTheme.gryffindorRed
                            : Colors.grey.withOpacity(0.3),
                        width: value == TriState.no ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      'Hayır',
                      style: TextStyle(
                        fontSize: 12,
                        color: value == TriState.no 
                            ? AppTheme.gryffindorRed 
                            : (isDark ? Colors.white : Colors.grey[800]),
                        fontWeight: value == TriState.no ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 