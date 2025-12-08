// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  int get colorValue => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;
  int get auditScore => throw _privateConstructorUsedError;
  String get auditFeedback =>
      throw _privateConstructorUsedError; //<input> // List of UIDs who have access (Owner + Invitees)
  List<String> get memberIds => throw _privateConstructorUsedError;

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
    ProjectModel value,
    $Res Function(ProjectModel) then,
  ) = _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String ownerId,
    int colorValue,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    DateTime createdAt,
    int auditScore,
    String auditFeedback,
    List<String> memberIds,
  });
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? ownerId = null,
    Object? colorValue = null,
    Object? createdAt = null,
    Object? auditScore = null,
    Object? auditFeedback = null,
    Object? memberIds = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            colorValue: null == colorValue
                ? _value.colorValue
                : colorValue // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            auditScore: null == auditScore
                ? _value.auditScore
                : auditScore // ignore: cast_nullable_to_non_nullable
                      as int,
            auditFeedback: null == auditFeedback
                ? _value.auditFeedback
                : auditFeedback // ignore: cast_nullable_to_non_nullable
                      as String,
            memberIds: null == memberIds
                ? _value.memberIds
                : memberIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
    _$ProjectModelImpl value,
    $Res Function(_$ProjectModelImpl) then,
  ) = __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String ownerId,
    int colorValue,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    DateTime createdAt,
    int auditScore,
    String auditFeedback,
    List<String> memberIds,
  });
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
    _$ProjectModelImpl _value,
    $Res Function(_$ProjectModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? ownerId = null,
    Object? colorValue = null,
    Object? createdAt = null,
    Object? auditScore = null,
    Object? auditFeedback = null,
    Object? memberIds = null,
  }) {
    return _then(
      _$ProjectModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        colorValue: null == colorValue
            ? _value.colorValue
            : colorValue // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        auditScore: null == auditScore
            ? _value.auditScore
            : auditScore // ignore: cast_nullable_to_non_nullable
                  as int,
        auditFeedback: null == auditFeedback
            ? _value.auditFeedback
            : auditFeedback // ignore: cast_nullable_to_non_nullable
                  as String,
        memberIds: null == memberIds
            ? _value._memberIds
            : memberIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectModelImpl implements _ProjectModel {
  const _$ProjectModelImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    this.colorValue = 0xFF42A5F5,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    required this.createdAt,
    this.auditScore = 0,
    this.auditFeedback = '',
    final List<String> memberIds = const [],
  }) : _memberIds = memberIds;

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String ownerId;
  @override
  @JsonKey()
  final int colorValue;
  @override
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey()
  final int auditScore;
  @override
  @JsonKey()
  final String auditFeedback;
  //<input> // List of UIDs who have access (Owner + Invitees)
  final List<String> _memberIds;
  //<input> // List of UIDs who have access (Owner + Invitees)
  @override
  @JsonKey()
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, description: $description, ownerId: $ownerId, colorValue: $colorValue, createdAt: $createdAt, auditScore: $auditScore, auditFeedback: $auditFeedback, memberIds: $memberIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.auditScore, auditScore) ||
                other.auditScore == auditScore) &&
            (identical(other.auditFeedback, auditFeedback) ||
                other.auditFeedback == auditFeedback) &&
            const DeepCollectionEquality().equals(
              other._memberIds,
              _memberIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    ownerId,
    colorValue,
    createdAt,
    auditScore,
    auditFeedback,
    const DeepCollectionEquality().hash(_memberIds),
  );

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectModelImplToJson(this);
  }
}

abstract class _ProjectModel implements ProjectModel {
  const factory _ProjectModel({
    required final String id,
    required final String name,
    required final String description,
    required final String ownerId,
    final int colorValue,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    required final DateTime createdAt,
    final int auditScore,
    final String auditFeedback,
    final List<String> memberIds,
  }) = _$ProjectModelImpl;

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get ownerId;
  @override
  int get colorValue;
  @override
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  DateTime get createdAt;
  @override
  int get auditScore;
  @override
  String get auditFeedback; //<input> // List of UIDs who have access (Owner + Invitees)
  @override
  List<String> get memberIds;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
