// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_check_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DaemonStatusState {
  String get statusMessage =>
      throw _privateConstructorUsedError; // The current status (e.g., connected, disconnected)
  String? get errorMessage =>
      throw _privateConstructorUsedError; // Optional error message to display
  bool get isConnected => throw _privateConstructorUsedError;

  /// Create a copy of DaemonStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DaemonStatusStateCopyWith<DaemonStatusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DaemonStatusStateCopyWith<$Res> {
  factory $DaemonStatusStateCopyWith(
          DaemonStatusState value, $Res Function(DaemonStatusState) then) =
      _$DaemonStatusStateCopyWithImpl<$Res, DaemonStatusState>;
  @useResult
  $Res call({String statusMessage, String? errorMessage, bool isConnected});
}

/// @nodoc
class _$DaemonStatusStateCopyWithImpl<$Res, $Val extends DaemonStatusState>
    implements $DaemonStatusStateCopyWith<$Res> {
  _$DaemonStatusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DaemonStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusMessage = null,
    Object? errorMessage = freezed,
    Object? isConnected = null,
  }) {
    return _then(_value.copyWith(
      statusMessage: null == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DaemonStatusStateImplCopyWith<$Res>
    implements $DaemonStatusStateCopyWith<$Res> {
  factory _$$DaemonStatusStateImplCopyWith(_$DaemonStatusStateImpl value,
          $Res Function(_$DaemonStatusStateImpl) then) =
      __$$DaemonStatusStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String statusMessage, String? errorMessage, bool isConnected});
}

/// @nodoc
class __$$DaemonStatusStateImplCopyWithImpl<$Res>
    extends _$DaemonStatusStateCopyWithImpl<$Res, _$DaemonStatusStateImpl>
    implements _$$DaemonStatusStateImplCopyWith<$Res> {
  __$$DaemonStatusStateImplCopyWithImpl(_$DaemonStatusStateImpl _value,
      $Res Function(_$DaemonStatusStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DaemonStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusMessage = null,
    Object? errorMessage = freezed,
    Object? isConnected = null,
  }) {
    return _then(_$DaemonStatusStateImpl(
      statusMessage: null == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DaemonStatusStateImpl implements _DaemonStatusState {
  const _$DaemonStatusStateImpl(
      {required this.statusMessage,
      this.errorMessage,
      required this.isConnected});

  @override
  final String statusMessage;
// The current status (e.g., connected, disconnected)
  @override
  final String? errorMessage;
// Optional error message to display
  @override
  final bool isConnected;

  @override
  String toString() {
    return 'DaemonStatusState(statusMessage: $statusMessage, errorMessage: $errorMessage, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DaemonStatusStateImpl &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, statusMessage, errorMessage, isConnected);

  /// Create a copy of DaemonStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DaemonStatusStateImplCopyWith<_$DaemonStatusStateImpl> get copyWith =>
      __$$DaemonStatusStateImplCopyWithImpl<_$DaemonStatusStateImpl>(
          this, _$identity);
}

abstract class _DaemonStatusState implements DaemonStatusState {
  const factory _DaemonStatusState(
      {required final String statusMessage,
      final String? errorMessage,
      required final bool isConnected}) = _$DaemonStatusStateImpl;

  @override
  String
      get statusMessage; // The current status (e.g., connected, disconnected)
  @override
  String? get errorMessage; // Optional error message to display
  @override
  bool get isConnected;

  /// Create a copy of DaemonStatusState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DaemonStatusStateImplCopyWith<_$DaemonStatusStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
