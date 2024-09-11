// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daemon_error_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VpnErrorState {
  String get message => throw _privateConstructorUsedError;
  ErrorSource? get source => throw _privateConstructorUsedError;

  /// Create a copy of VpnErrorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VpnErrorStateCopyWith<VpnErrorState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnErrorStateCopyWith<$Res> {
  factory $VpnErrorStateCopyWith(
          VpnErrorState value, $Res Function(VpnErrorState) then) =
      _$VpnErrorStateCopyWithImpl<$Res, VpnErrorState>;
  @useResult
  $Res call({String message, ErrorSource? source});
}

/// @nodoc
class _$VpnErrorStateCopyWithImpl<$Res, $Val extends VpnErrorState>
    implements $VpnErrorStateCopyWith<$Res> {
  _$VpnErrorStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VpnErrorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? source = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ErrorSource?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VpnErrorStateImplCopyWith<$Res>
    implements $VpnErrorStateCopyWith<$Res> {
  factory _$$VpnErrorStateImplCopyWith(
          _$VpnErrorStateImpl value, $Res Function(_$VpnErrorStateImpl) then) =
      __$$VpnErrorStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, ErrorSource? source});
}

/// @nodoc
class __$$VpnErrorStateImplCopyWithImpl<$Res>
    extends _$VpnErrorStateCopyWithImpl<$Res, _$VpnErrorStateImpl>
    implements _$$VpnErrorStateImplCopyWith<$Res> {
  __$$VpnErrorStateImplCopyWithImpl(
      _$VpnErrorStateImpl _value, $Res Function(_$VpnErrorStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of VpnErrorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? source = freezed,
  }) {
    return _then(_$VpnErrorStateImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ErrorSource?,
    ));
  }
}

/// @nodoc

class _$VpnErrorStateImpl implements _VpnErrorState {
  const _$VpnErrorStateImpl({required this.message, this.source});

  @override
  final String message;
  @override
  final ErrorSource? source;

  @override
  String toString() {
    return 'VpnErrorState(message: $message, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VpnErrorStateImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, source);

  /// Create a copy of VpnErrorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VpnErrorStateImplCopyWith<_$VpnErrorStateImpl> get copyWith =>
      __$$VpnErrorStateImplCopyWithImpl<_$VpnErrorStateImpl>(this, _$identity);
}

abstract class _VpnErrorState implements VpnErrorState {
  const factory _VpnErrorState(
      {required final String message,
      final ErrorSource? source}) = _$VpnErrorStateImpl;

  @override
  String get message;
  @override
  ErrorSource? get source;

  /// Create a copy of VpnErrorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VpnErrorStateImplCopyWith<_$VpnErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
