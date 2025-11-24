// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  Priority get priority => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: _nullableTimestampFromJson,
    toJson: _nullableTimestampToJson,
  )
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: _nullableTimestampFromJson,
    toJson: _nullableTimestampToJson,
  )
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<String> get dependencies => throw _privateConstructorUsedError;
  double get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String ownerId,
    TaskStatus status,
    Priority priority,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    DateTime? startDate,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    DateTime? endDate,
    List<String> dependencies,
    double orderIndex,
  });
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? status = null,
    Object? priority = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? dependencies = null,
    Object? orderIndex = null,
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
            ownerId: null == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TaskStatus,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as Priority,
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dependencies: null == dependencies
                ? _value.dependencies
                : dependencies // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
    _$TaskModelImpl value,
    $Res Function(_$TaskModelImpl) then,
  ) = __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String ownerId,
    TaskStatus status,
    Priority priority,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    DateTime? startDate,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    DateTime? endDate,
    List<String> dependencies,
    double orderIndex,
  });
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
    _$TaskModelImpl _value,
    $Res Function(_$TaskModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ownerId = null,
    Object? status = null,
    Object? priority = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? dependencies = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _$TaskModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TaskStatus,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as Priority,
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dependencies: null == dependencies
            ? _value._dependencies
            : dependencies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl extends _TaskModel {
  const _$TaskModelImpl({
    required this.id,
    required this.name,
    required this.ownerId,
    this.status = TaskStatus.notStarted,
    this.priority = Priority.medium,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    this.startDate,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    this.endDate,
    final List<String> dependencies = const [],
    required this.orderIndex,
  }) : _dependencies = dependencies,
       super._();

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String ownerId;
  @override
  @JsonKey()
  final TaskStatus status;
  @override
  @JsonKey()
  final Priority priority;
  @override
  @JsonKey(
    fromJson: _nullableTimestampFromJson,
    toJson: _nullableTimestampToJson,
  )
  final DateTime? startDate;
  @override
  @JsonKey(
    fromJson: _nullableTimestampFromJson,
    toJson: _nullableTimestampToJson,
  )
  final DateTime? endDate;
  final List<String> _dependencies;
  @override
  @JsonKey()
  List<String> get dependencies {
    if (_dependencies is EqualUnmodifiableListView) return _dependencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dependencies);
  }

  @override
  final double orderIndex;

  @override
  String toString() {
    return 'TaskModel(id: $id, name: $name, ownerId: $ownerId, status: $status, priority: $priority, startDate: $startDate, endDate: $endDate, dependencies: $dependencies, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(
              other._dependencies,
              _dependencies,
            ) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    ownerId,
    status,
    priority,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_dependencies),
    orderIndex,
  );

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(this);
  }
}

abstract class _TaskModel extends TaskModel {
  const factory _TaskModel({
    required final String id,
    required final String name,
    required final String ownerId,
    final TaskStatus status,
    final Priority priority,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    final DateTime? startDate,
    @JsonKey(
      fromJson: _nullableTimestampFromJson,
      toJson: _nullableTimestampToJson,
    )
    final DateTime? endDate,
    final List<String> dependencies,
    required final double orderIndex,
  }) = _$TaskModelImpl;
  const _TaskModel._() : super._();

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get ownerId;
  @override
  TaskStatus get status;
  @override
  Priority get priority;
  @override
  @JsonKey(
    fromJson: _nullableTimestampFromJson,
    toJson: _nullableTimestampToJson,
  )
  DateTime? get startDate;
  @override
  @JsonKey(
    fromJson: _nullableTimestampFromJson,
    toJson: _nullableTimestampToJson,
  )
  DateTime? get endDate;
  @override
  List<String> get dependencies;
  @override
  double get orderIndex;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
