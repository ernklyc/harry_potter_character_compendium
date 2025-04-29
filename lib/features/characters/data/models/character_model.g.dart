// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CharacterImpl _$$CharacterImplFromJson(Map<String, dynamic> json) =>
    _$CharacterImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      alternateNames: (json['alternateNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      species: json['species'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      house: json['house'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String?,
      yearOfBirth: (json['yearOfBirth'] as num?)?.toInt(),
      wizard: json['wizard'] as bool? ?? false,
      ancestry: json['ancestry'] as String? ?? '',
      eyeColour: json['eyeColour'] as String? ?? '',
      hairColour: json['hairColour'] as String? ?? '',
      wand: json['wand'] == null
          ? null
          : Wand.fromJson(json['wand'] as Map<String, dynamic>),
      patronus: json['patronus'] as String? ?? '',
      hogwartsStudent: json['hogwartsStudent'] as bool? ?? false,
      hogwartsStaff: json['hogwartsStaff'] as bool? ?? false,
      actor: json['actor'] as String? ?? '',
      alternateActors: (json['alternateActors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      alive: json['alive'] as bool? ?? true,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$CharacterImplToJson(_$CharacterImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'alternateNames': instance.alternateNames,
      'species': instance.species,
      'gender': instance.gender,
      'house': instance.house,
      'dateOfBirth': instance.dateOfBirth,
      'yearOfBirth': instance.yearOfBirth,
      'wizard': instance.wizard,
      'ancestry': instance.ancestry,
      'eyeColour': instance.eyeColour,
      'hairColour': instance.hairColour,
      'wand': instance.wand,
      'patronus': instance.patronus,
      'hogwartsStudent': instance.hogwartsStudent,
      'hogwartsStaff': instance.hogwartsStaff,
      'actor': instance.actor,
      'alternateActors': instance.alternateActors,
      'alive': instance.alive,
      'image': instance.image,
    };

_$WandImpl _$$WandImplFromJson(Map<String, dynamic> json) => _$WandImpl(
      wood: json['wood'] as String? ?? '',
      core: json['core'] as String? ?? '',
      length: (json['length'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$WandImplToJson(_$WandImpl instance) =>
    <String, dynamic>{
      'wood': instance.wood,
      'core': instance.core,
      'length': instance.length,
    };
