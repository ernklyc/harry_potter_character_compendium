import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'character_model.freezed.dart';
part 'character_model.g.dart';

@freezed
class Character with _$Character {
  const factory Character({
    required String id,
    required String name,
    @Default([]) List<String> alternateNames,
    @Default('') String species,
    @Default('') String gender,
    @Default('') String house,
    String? dateOfBirth,
    int? yearOfBirth,
    @Default(false) bool wizard,
    @Default('') String ancestry,
    @Default('') String eyeColour,
    @Default('') String hairColour,
    Wand? wand,
    @Default('') String patronus,
    @Default(false) bool hogwartsStudent,
    @Default(false) bool hogwartsStaff,
    @Default('') String actor,
    @Default([]) List<String> alternateActors,
    @Default(true) bool alive,
    String? image,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
}

@freezed
class Wand with _$Wand {
  const factory Wand({
    @Default('') String wood,
    @Default('') String core,
    double? length,
  }) = _Wand;

  factory Wand.fromJson(Map<String, dynamic> json) => _$WandFromJson(json);
} 