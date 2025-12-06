// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SearchHistoryModel _$SearchHistoryModelFromJson(Map<String, dynamic> json) {
  return _SearchHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$SearchHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get description =>
      throw _privateConstructorUsedError; // <input> // Added Default
  String get strategy =>
      throw _privateConstructorUsedError; // <input> // Added Default
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SearchHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchHistoryModelCopyWith<SearchHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHistoryModelCopyWith<$Res> {
  factory $SearchHistoryModelCopyWith(
    SearchHistoryModel value,
    $Res Function(SearchHistoryModel) then,
  ) = _$SearchHistoryModelCopyWithImpl<$Res, SearchHistoryModel>;
  @useResult
  $Res call({
    String id,
    String description,
    String strategy,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    DateTime createdAt,
  });
}

/// @nodoc
class _$SearchHistoryModelCopyWithImpl<$Res, $Val extends SearchHistoryModel>
    implements $SearchHistoryModelCopyWith<$Res> {
  _$SearchHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? strategy = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            strategy: null == strategy
                ? _value.strategy
                : strategy // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SearchHistoryModelImplCopyWith<$Res>
    implements $SearchHistoryModelCopyWith<$Res> {
  factory _$$SearchHistoryModelImplCopyWith(
    _$SearchHistoryModelImpl value,
    $Res Function(_$SearchHistoryModelImpl) then,
  ) = __$$SearchHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String description,
    String strategy,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SearchHistoryModelImplCopyWithImpl<$Res>
    extends _$SearchHistoryModelCopyWithImpl<$Res, _$SearchHistoryModelImpl>
    implements _$$SearchHistoryModelImplCopyWith<$Res> {
  __$$SearchHistoryModelImplCopyWithImpl(
    _$SearchHistoryModelImpl _value,
    $Res Function(_$SearchHistoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? strategy = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SearchHistoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        strategy: null == strategy
            ? _value.strategy
            : strategy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchHistoryModelImpl implements _SearchHistoryModel {
  const _$SearchHistoryModelImpl({
    required this.id,
    this.description = 'Unknown Prompt',
    this.strategy = '',
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    required this.createdAt,
  });

  factory _$SearchHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String description;
  // <input> // Added Default
  @override
  @JsonKey()
  final String strategy;
  // <input> // Added Default
  @override
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  final DateTime createdAt;

  @override
  String toString() {
    return 'SearchHistoryModel(id: $id, description: $description, strategy: $strategy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.strategy, strategy) ||
                other.strategy == strategy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, description, strategy, createdAt);

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchHistoryModelImplCopyWith<_$SearchHistoryModelImpl> get copyWith =>
      __$$SearchHistoryModelImplCopyWithImpl<_$SearchHistoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchHistoryModelImplToJson(this);
  }
}

abstract class _SearchHistoryModel implements SearchHistoryModel {
  const factory _SearchHistoryModel({
    required final String id,
    final String description,
    final String strategy,
    @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
    required final DateTime createdAt,
  }) = _$SearchHistoryModelImpl;

  factory _SearchHistoryModel.fromJson(Map<String, dynamic> json) =
      _$SearchHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get description; // <input> // Added Default
  @override
  String get strategy; // <input> // Added Default
  @override
  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  DateTime get createdAt;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchHistoryModelImplCopyWith<_$SearchHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
