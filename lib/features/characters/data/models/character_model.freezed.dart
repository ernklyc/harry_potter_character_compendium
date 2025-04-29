// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'character_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Character _$CharacterFromJson(Map<String, dynamic> json) {
  return _Character.fromJson(json);
}

/// @nodoc
mixin _$Character {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get alternateNames => throw _privateConstructorUsedError;
  String get species => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String get house => throw _privateConstructorUsedError;
  String? get dateOfBirth => throw _privateConstructorUsedError;
  int? get yearOfBirth => throw _privateConstructorUsedError;
  bool get wizard => throw _privateConstructorUsedError;
  String get ancestry => throw _privateConstructorUsedError;
  String get eyeColour => throw _privateConstructorUsedError;
  String get hairColour => throw _privateConstructorUsedError;
  Wand? get wand => throw _privateConstructorUsedError;
  String get patronus => throw _privateConstructorUsedError;
  bool get hogwartsStudent => throw _privateConstructorUsedError;
  bool get hogwartsStaff => throw _privateConstructorUsedError;
  String get actor => throw _privateConstructorUsedError;
  List<String> get alternateActors => throw _privateConstructorUsedError;
  bool get alive => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  /// Serializes this Character to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterCopyWith<Character> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterCopyWith<$Res> {
  factory $CharacterCopyWith(Character value, $Res Function(Character) then) =
      _$CharacterCopyWithImpl<$Res, Character>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<String> alternateNames,
      String species,
      String gender,
      String house,
      String? dateOfBirth,
      int? yearOfBirth,
      bool wizard,
      String ancestry,
      String eyeColour,
      String hairColour,
      Wand? wand,
      String patronus,
      bool hogwartsStudent,
      bool hogwartsStaff,
      String actor,
      List<String> alternateActors,
      bool alive,
      String? image});

  $WandCopyWith<$Res>? get wand;
}

/// @nodoc
class _$CharacterCopyWithImpl<$Res, $Val extends Character>
    implements $CharacterCopyWith<$Res> {
  _$CharacterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? alternateNames = null,
    Object? species = null,
    Object? gender = null,
    Object? house = null,
    Object? dateOfBirth = freezed,
    Object? yearOfBirth = freezed,
    Object? wizard = null,
    Object? ancestry = null,
    Object? eyeColour = null,
    Object? hairColour = null,
    Object? wand = freezed,
    Object? patronus = null,
    Object? hogwartsStudent = null,
    Object? hogwartsStaff = null,
    Object? actor = null,
    Object? alternateActors = null,
    Object? alive = null,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      alternateNames: null == alternateNames
          ? _value.alternateNames
          : alternateNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      species: null == species
          ? _value.species
          : species // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      house: null == house
          ? _value.house
          : house // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      yearOfBirth: freezed == yearOfBirth
          ? _value.yearOfBirth
          : yearOfBirth // ignore: cast_nullable_to_non_nullable
              as int?,
      wizard: null == wizard
          ? _value.wizard
          : wizard // ignore: cast_nullable_to_non_nullable
              as bool,
      ancestry: null == ancestry
          ? _value.ancestry
          : ancestry // ignore: cast_nullable_to_non_nullable
              as String,
      eyeColour: null == eyeColour
          ? _value.eyeColour
          : eyeColour // ignore: cast_nullable_to_non_nullable
              as String,
      hairColour: null == hairColour
          ? _value.hairColour
          : hairColour // ignore: cast_nullable_to_non_nullable
              as String,
      wand: freezed == wand
          ? _value.wand
          : wand // ignore: cast_nullable_to_non_nullable
              as Wand?,
      patronus: null == patronus
          ? _value.patronus
          : patronus // ignore: cast_nullable_to_non_nullable
              as String,
      hogwartsStudent: null == hogwartsStudent
          ? _value.hogwartsStudent
          : hogwartsStudent // ignore: cast_nullable_to_non_nullable
              as bool,
      hogwartsStaff: null == hogwartsStaff
          ? _value.hogwartsStaff
          : hogwartsStaff // ignore: cast_nullable_to_non_nullable
              as bool,
      actor: null == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as String,
      alternateActors: null == alternateActors
          ? _value.alternateActors
          : alternateActors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      alive: null == alive
          ? _value.alive
          : alive // ignore: cast_nullable_to_non_nullable
              as bool,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WandCopyWith<$Res>? get wand {
    if (_value.wand == null) {
      return null;
    }

    return $WandCopyWith<$Res>(_value.wand!, (value) {
      return _then(_value.copyWith(wand: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CharacterImplCopyWith<$Res>
    implements $CharacterCopyWith<$Res> {
  factory _$$CharacterImplCopyWith(
          _$CharacterImpl value, $Res Function(_$CharacterImpl) then) =
      __$$CharacterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<String> alternateNames,
      String species,
      String gender,
      String house,
      String? dateOfBirth,
      int? yearOfBirth,
      bool wizard,
      String ancestry,
      String eyeColour,
      String hairColour,
      Wand? wand,
      String patronus,
      bool hogwartsStudent,
      bool hogwartsStaff,
      String actor,
      List<String> alternateActors,
      bool alive,
      String? image});

  @override
  $WandCopyWith<$Res>? get wand;
}

/// @nodoc
class __$$CharacterImplCopyWithImpl<$Res>
    extends _$CharacterCopyWithImpl<$Res, _$CharacterImpl>
    implements _$$CharacterImplCopyWith<$Res> {
  __$$CharacterImplCopyWithImpl(
      _$CharacterImpl _value, $Res Function(_$CharacterImpl) _then)
      : super(_value, _then);

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? alternateNames = null,
    Object? species = null,
    Object? gender = null,
    Object? house = null,
    Object? dateOfBirth = freezed,
    Object? yearOfBirth = freezed,
    Object? wizard = null,
    Object? ancestry = null,
    Object? eyeColour = null,
    Object? hairColour = null,
    Object? wand = freezed,
    Object? patronus = null,
    Object? hogwartsStudent = null,
    Object? hogwartsStaff = null,
    Object? actor = null,
    Object? alternateActors = null,
    Object? alive = null,
    Object? image = freezed,
  }) {
    return _then(_$CharacterImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      alternateNames: null == alternateNames
          ? _value._alternateNames
          : alternateNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      species: null == species
          ? _value.species
          : species // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      house: null == house
          ? _value.house
          : house // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      yearOfBirth: freezed == yearOfBirth
          ? _value.yearOfBirth
          : yearOfBirth // ignore: cast_nullable_to_non_nullable
              as int?,
      wizard: null == wizard
          ? _value.wizard
          : wizard // ignore: cast_nullable_to_non_nullable
              as bool,
      ancestry: null == ancestry
          ? _value.ancestry
          : ancestry // ignore: cast_nullable_to_non_nullable
              as String,
      eyeColour: null == eyeColour
          ? _value.eyeColour
          : eyeColour // ignore: cast_nullable_to_non_nullable
              as String,
      hairColour: null == hairColour
          ? _value.hairColour
          : hairColour // ignore: cast_nullable_to_non_nullable
              as String,
      wand: freezed == wand
          ? _value.wand
          : wand // ignore: cast_nullable_to_non_nullable
              as Wand?,
      patronus: null == patronus
          ? _value.patronus
          : patronus // ignore: cast_nullable_to_non_nullable
              as String,
      hogwartsStudent: null == hogwartsStudent
          ? _value.hogwartsStudent
          : hogwartsStudent // ignore: cast_nullable_to_non_nullable
              as bool,
      hogwartsStaff: null == hogwartsStaff
          ? _value.hogwartsStaff
          : hogwartsStaff // ignore: cast_nullable_to_non_nullable
              as bool,
      actor: null == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as String,
      alternateActors: null == alternateActors
          ? _value._alternateActors
          : alternateActors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      alive: null == alive
          ? _value.alive
          : alive // ignore: cast_nullable_to_non_nullable
              as bool,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterImpl with DiagnosticableTreeMixin implements _Character {
  const _$CharacterImpl(
      {required this.id,
      required this.name,
      final List<String> alternateNames = const [],
      this.species = '',
      this.gender = '',
      this.house = '',
      this.dateOfBirth,
      this.yearOfBirth,
      this.wizard = false,
      this.ancestry = '',
      this.eyeColour = '',
      this.hairColour = '',
      this.wand,
      this.patronus = '',
      this.hogwartsStudent = false,
      this.hogwartsStaff = false,
      this.actor = '',
      final List<String> alternateActors = const [],
      this.alive = true,
      this.image})
      : _alternateNames = alternateNames,
        _alternateActors = alternateActors;

  factory _$CharacterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<String> _alternateNames;
  @override
  @JsonKey()
  List<String> get alternateNames {
    if (_alternateNames is EqualUnmodifiableListView) return _alternateNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternateNames);
  }

  @override
  @JsonKey()
  final String species;
  @override
  @JsonKey()
  final String gender;
  @override
  @JsonKey()
  final String house;
  @override
  final String? dateOfBirth;
  @override
  final int? yearOfBirth;
  @override
  @JsonKey()
  final bool wizard;
  @override
  @JsonKey()
  final String ancestry;
  @override
  @JsonKey()
  final String eyeColour;
  @override
  @JsonKey()
  final String hairColour;
  @override
  final Wand? wand;
  @override
  @JsonKey()
  final String patronus;
  @override
  @JsonKey()
  final bool hogwartsStudent;
  @override
  @JsonKey()
  final bool hogwartsStaff;
  @override
  @JsonKey()
  final String actor;
  final List<String> _alternateActors;
  @override
  @JsonKey()
  List<String> get alternateActors {
    if (_alternateActors is EqualUnmodifiableListView) return _alternateActors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternateActors);
  }

  @override
  @JsonKey()
  final bool alive;
  @override
  final String? image;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Character(id: $id, name: $name, alternateNames: $alternateNames, species: $species, gender: $gender, house: $house, dateOfBirth: $dateOfBirth, yearOfBirth: $yearOfBirth, wizard: $wizard, ancestry: $ancestry, eyeColour: $eyeColour, hairColour: $hairColour, wand: $wand, patronus: $patronus, hogwartsStudent: $hogwartsStudent, hogwartsStaff: $hogwartsStaff, actor: $actor, alternateActors: $alternateActors, alive: $alive, image: $image)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Character'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('alternateNames', alternateNames))
      ..add(DiagnosticsProperty('species', species))
      ..add(DiagnosticsProperty('gender', gender))
      ..add(DiagnosticsProperty('house', house))
      ..add(DiagnosticsProperty('dateOfBirth', dateOfBirth))
      ..add(DiagnosticsProperty('yearOfBirth', yearOfBirth))
      ..add(DiagnosticsProperty('wizard', wizard))
      ..add(DiagnosticsProperty('ancestry', ancestry))
      ..add(DiagnosticsProperty('eyeColour', eyeColour))
      ..add(DiagnosticsProperty('hairColour', hairColour))
      ..add(DiagnosticsProperty('wand', wand))
      ..add(DiagnosticsProperty('patronus', patronus))
      ..add(DiagnosticsProperty('hogwartsStudent', hogwartsStudent))
      ..add(DiagnosticsProperty('hogwartsStaff', hogwartsStaff))
      ..add(DiagnosticsProperty('actor', actor))
      ..add(DiagnosticsProperty('alternateActors', alternateActors))
      ..add(DiagnosticsProperty('alive', alive))
      ..add(DiagnosticsProperty('image', image));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._alternateNames, _alternateNames) &&
            (identical(other.species, species) || other.species == species) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.house, house) || other.house == house) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.yearOfBirth, yearOfBirth) ||
                other.yearOfBirth == yearOfBirth) &&
            (identical(other.wizard, wizard) || other.wizard == wizard) &&
            (identical(other.ancestry, ancestry) ||
                other.ancestry == ancestry) &&
            (identical(other.eyeColour, eyeColour) ||
                other.eyeColour == eyeColour) &&
            (identical(other.hairColour, hairColour) ||
                other.hairColour == hairColour) &&
            (identical(other.wand, wand) || other.wand == wand) &&
            (identical(other.patronus, patronus) ||
                other.patronus == patronus) &&
            (identical(other.hogwartsStudent, hogwartsStudent) ||
                other.hogwartsStudent == hogwartsStudent) &&
            (identical(other.hogwartsStaff, hogwartsStaff) ||
                other.hogwartsStaff == hogwartsStaff) &&
            (identical(other.actor, actor) || other.actor == actor) &&
            const DeepCollectionEquality()
                .equals(other._alternateActors, _alternateActors) &&
            (identical(other.alive, alive) || other.alive == alive) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        const DeepCollectionEquality().hash(_alternateNames),
        species,
        gender,
        house,
        dateOfBirth,
        yearOfBirth,
        wizard,
        ancestry,
        eyeColour,
        hairColour,
        wand,
        patronus,
        hogwartsStudent,
        hogwartsStaff,
        actor,
        const DeepCollectionEquality().hash(_alternateActors),
        alive,
        image
      ]);

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      __$$CharacterImplCopyWithImpl<_$CharacterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterImplToJson(
      this,
    );
  }
}

abstract class _Character implements Character {
  const factory _Character(
      {required final String id,
      required final String name,
      final List<String> alternateNames,
      final String species,
      final String gender,
      final String house,
      final String? dateOfBirth,
      final int? yearOfBirth,
      final bool wizard,
      final String ancestry,
      final String eyeColour,
      final String hairColour,
      final Wand? wand,
      final String patronus,
      final bool hogwartsStudent,
      final bool hogwartsStaff,
      final String actor,
      final List<String> alternateActors,
      final bool alive,
      final String? image}) = _$CharacterImpl;

  factory _Character.fromJson(Map<String, dynamic> json) =
      _$CharacterImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get alternateNames;
  @override
  String get species;
  @override
  String get gender;
  @override
  String get house;
  @override
  String? get dateOfBirth;
  @override
  int? get yearOfBirth;
  @override
  bool get wizard;
  @override
  String get ancestry;
  @override
  String get eyeColour;
  @override
  String get hairColour;
  @override
  Wand? get wand;
  @override
  String get patronus;
  @override
  bool get hogwartsStudent;
  @override
  bool get hogwartsStaff;
  @override
  String get actor;
  @override
  List<String> get alternateActors;
  @override
  bool get alive;
  @override
  String? get image;

  /// Create a copy of Character
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterImplCopyWith<_$CharacterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Wand _$WandFromJson(Map<String, dynamic> json) {
  return _Wand.fromJson(json);
}

/// @nodoc
mixin _$Wand {
  String get wood => throw _privateConstructorUsedError;
  String get core => throw _privateConstructorUsedError;
  double? get length => throw _privateConstructorUsedError;

  /// Serializes this Wand to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Wand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WandCopyWith<Wand> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WandCopyWith<$Res> {
  factory $WandCopyWith(Wand value, $Res Function(Wand) then) =
      _$WandCopyWithImpl<$Res, Wand>;
  @useResult
  $Res call({String wood, String core, double? length});
}

/// @nodoc
class _$WandCopyWithImpl<$Res, $Val extends Wand>
    implements $WandCopyWith<$Res> {
  _$WandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Wand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wood = null,
    Object? core = null,
    Object? length = freezed,
  }) {
    return _then(_value.copyWith(
      wood: null == wood
          ? _value.wood
          : wood // ignore: cast_nullable_to_non_nullable
              as String,
      core: null == core
          ? _value.core
          : core // ignore: cast_nullable_to_non_nullable
              as String,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WandImplCopyWith<$Res> implements $WandCopyWith<$Res> {
  factory _$$WandImplCopyWith(
          _$WandImpl value, $Res Function(_$WandImpl) then) =
      __$$WandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String wood, String core, double? length});
}

/// @nodoc
class __$$WandImplCopyWithImpl<$Res>
    extends _$WandCopyWithImpl<$Res, _$WandImpl>
    implements _$$WandImplCopyWith<$Res> {
  __$$WandImplCopyWithImpl(_$WandImpl _value, $Res Function(_$WandImpl) _then)
      : super(_value, _then);

  /// Create a copy of Wand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wood = null,
    Object? core = null,
    Object? length = freezed,
  }) {
    return _then(_$WandImpl(
      wood: null == wood
          ? _value.wood
          : wood // ignore: cast_nullable_to_non_nullable
              as String,
      core: null == core
          ? _value.core
          : core // ignore: cast_nullable_to_non_nullable
              as String,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WandImpl with DiagnosticableTreeMixin implements _Wand {
  const _$WandImpl({this.wood = '', this.core = '', this.length});

  factory _$WandImpl.fromJson(Map<String, dynamic> json) =>
      _$$WandImplFromJson(json);

  @override
  @JsonKey()
  final String wood;
  @override
  @JsonKey()
  final String core;
  @override
  final double? length;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Wand(wood: $wood, core: $core, length: $length)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Wand'))
      ..add(DiagnosticsProperty('wood', wood))
      ..add(DiagnosticsProperty('core', core))
      ..add(DiagnosticsProperty('length', length));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WandImpl &&
            (identical(other.wood, wood) || other.wood == wood) &&
            (identical(other.core, core) || other.core == core) &&
            (identical(other.length, length) || other.length == length));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, wood, core, length);

  /// Create a copy of Wand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WandImplCopyWith<_$WandImpl> get copyWith =>
      __$$WandImplCopyWithImpl<_$WandImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WandImplToJson(
      this,
    );
  }
}

abstract class _Wand implements Wand {
  const factory _Wand(
      {final String wood,
      final String core,
      final double? length}) = _$WandImpl;

  factory _Wand.fromJson(Map<String, dynamic> json) = _$WandImpl.fromJson;

  @override
  String get wood;
  @override
  String get core;
  @override
  double? get length;

  /// Create a copy of Wand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WandImplCopyWith<_$WandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
