import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'spell_model.freezed.dart';
part 'spell_model.g.dart';

@freezed
class Spell with _$Spell {
  const factory Spell({
    required String id,
    required String name,
    @Default('') String description,
  }) = _Spell;

  factory Spell.fromJson(Map<String, dynamic> json) => _$SpellFromJson(json);
} 