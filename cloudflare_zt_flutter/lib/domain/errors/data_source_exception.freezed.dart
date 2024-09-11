// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_source_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DataSourceException {
  String? get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) serverError,
    required TResult Function(String? message) connection,
    required TResult Function(String? message) unauthorized,
    required TResult Function(String? message) forbidden,
    required TResult Function(String? message) unknown,
    required TResult Function(String? message) busy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? serverError,
    TResult? Function(String? message)? connection,
    TResult? Function(String? message)? unauthorized,
    TResult? Function(String? message)? forbidden,
    TResult? Function(String? message)? unknown,
    TResult? Function(String? message)? busy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? serverError,
    TResult Function(String? message)? connection,
    TResult Function(String? message)? unauthorized,
    TResult Function(String? message)? forbidden,
    TResult Function(String? message)? unknown,
    TResult Function(String? message)? busy,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServerException value) serverError,
    required TResult Function(_ConnectionException value) connection,
    required TResult Function(_UnauthorizedException value) unauthorized,
    required TResult Function(_ForbiddenException value) forbidden,
    required TResult Function(_UnknownException value) unknown,
    required TResult Function(_BusyException value) busy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServerException value)? serverError,
    TResult? Function(_ConnectionException value)? connection,
    TResult? Function(_UnauthorizedException value)? unauthorized,
    TResult? Function(_ForbiddenException value)? forbidden,
    TResult? Function(_UnknownException value)? unknown,
    TResult? Function(_BusyException value)? busy,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServerException value)? serverError,
    TResult Function(_ConnectionException value)? connection,
    TResult Function(_UnauthorizedException value)? unauthorized,
    TResult Function(_ForbiddenException value)? forbidden,
    TResult Function(_UnknownException value)? unknown,
    TResult Function(_BusyException value)? busy,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataSourceExceptionCopyWith<DataSourceException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataSourceExceptionCopyWith<$Res> {
  factory $DataSourceExceptionCopyWith(
          DataSourceException value, $Res Function(DataSourceException) then) =
      _$DataSourceExceptionCopyWithImpl<$Res, DataSourceException>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class _$DataSourceExceptionCopyWithImpl<$Res, $Val extends DataSourceException>
    implements $DataSourceExceptionCopyWith<$Res> {
  _$DataSourceExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServerExceptionImplCopyWith<$Res>
    implements $DataSourceExceptionCopyWith<$Res> {
  factory _$$ServerExceptionImplCopyWith(_$ServerExceptionImpl value,
          $Res Function(_$ServerExceptionImpl) then) =
      __$$ServerExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ServerExceptionImplCopyWithImpl<$Res>
    extends _$DataSourceExceptionCopyWithImpl<$Res, _$ServerExceptionImpl>
    implements _$$ServerExceptionImplCopyWith<$Res> {
  __$$ServerExceptionImplCopyWithImpl(
      _$ServerExceptionImpl _value, $Res Function(_$ServerExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$ServerExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ServerExceptionImpl implements _ServerException {
  const _$ServerExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'DataSourceException.serverError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerExceptionImplCopyWith<_$ServerExceptionImpl> get copyWith =>
      __$$ServerExceptionImplCopyWithImpl<_$ServerExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) serverError,
    required TResult Function(String? message) connection,
    required TResult Function(String? message) unauthorized,
    required TResult Function(String? message) forbidden,
    required TResult Function(String? message) unknown,
    required TResult Function(String? message) busy,
  }) {
    return serverError(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? serverError,
    TResult? Function(String? message)? connection,
    TResult? Function(String? message)? unauthorized,
    TResult? Function(String? message)? forbidden,
    TResult? Function(String? message)? unknown,
    TResult? Function(String? message)? busy,
  }) {
    return serverError?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? serverError,
    TResult Function(String? message)? connection,
    TResult Function(String? message)? unauthorized,
    TResult Function(String? message)? forbidden,
    TResult Function(String? message)? unknown,
    TResult Function(String? message)? busy,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServerException value) serverError,
    required TResult Function(_ConnectionException value) connection,
    required TResult Function(_UnauthorizedException value) unauthorized,
    required TResult Function(_ForbiddenException value) forbidden,
    required TResult Function(_UnknownException value) unknown,
    required TResult Function(_BusyException value) busy,
  }) {
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServerException value)? serverError,
    TResult? Function(_ConnectionException value)? connection,
    TResult? Function(_UnauthorizedException value)? unauthorized,
    TResult? Function(_ForbiddenException value)? forbidden,
    TResult? Function(_UnknownException value)? unknown,
    TResult? Function(_BusyException value)? busy,
  }) {
    return serverError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServerException value)? serverError,
    TResult Function(_ConnectionException value)? connection,
    TResult Function(_UnauthorizedException value)? unauthorized,
    TResult Function(_ForbiddenException value)? forbidden,
    TResult Function(_UnknownException value)? unknown,
    TResult Function(_BusyException value)? busy,
    required TResult orElse(),
  }) {
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class _ServerException implements DataSourceException {
  const factory _ServerException({final String? message}) =
      _$ServerExceptionImpl;

  @override
  String? get message;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerExceptionImplCopyWith<_$ServerExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectionExceptionImplCopyWith<$Res>
    implements $DataSourceExceptionCopyWith<$Res> {
  factory _$$ConnectionExceptionImplCopyWith(_$ConnectionExceptionImpl value,
          $Res Function(_$ConnectionExceptionImpl) then) =
      __$$ConnectionExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ConnectionExceptionImplCopyWithImpl<$Res>
    extends _$DataSourceExceptionCopyWithImpl<$Res, _$ConnectionExceptionImpl>
    implements _$$ConnectionExceptionImplCopyWith<$Res> {
  __$$ConnectionExceptionImplCopyWithImpl(_$ConnectionExceptionImpl _value,
      $Res Function(_$ConnectionExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$ConnectionExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ConnectionExceptionImpl implements _ConnectionException {
  const _$ConnectionExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'DataSourceException.connection(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionExceptionImplCopyWith<_$ConnectionExceptionImpl> get copyWith =>
      __$$ConnectionExceptionImplCopyWithImpl<_$ConnectionExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) serverError,
    required TResult Function(String? message) connection,
    required TResult Function(String? message) unauthorized,
    required TResult Function(String? message) forbidden,
    required TResult Function(String? message) unknown,
    required TResult Function(String? message) busy,
  }) {
    return connection(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? serverError,
    TResult? Function(String? message)? connection,
    TResult? Function(String? message)? unauthorized,
    TResult? Function(String? message)? forbidden,
    TResult? Function(String? message)? unknown,
    TResult? Function(String? message)? busy,
  }) {
    return connection?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? serverError,
    TResult Function(String? message)? connection,
    TResult Function(String? message)? unauthorized,
    TResult Function(String? message)? forbidden,
    TResult Function(String? message)? unknown,
    TResult Function(String? message)? busy,
    required TResult orElse(),
  }) {
    if (connection != null) {
      return connection(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServerException value) serverError,
    required TResult Function(_ConnectionException value) connection,
    required TResult Function(_UnauthorizedException value) unauthorized,
    required TResult Function(_ForbiddenException value) forbidden,
    required TResult Function(_UnknownException value) unknown,
    required TResult Function(_BusyException value) busy,
  }) {
    return connection(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServerException value)? serverError,
    TResult? Function(_ConnectionException value)? connection,
    TResult? Function(_UnauthorizedException value)? unauthorized,
    TResult? Function(_ForbiddenException value)? forbidden,
    TResult? Function(_UnknownException value)? unknown,
    TResult? Function(_BusyException value)? busy,
  }) {
    return connection?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServerException value)? serverError,
    TResult Function(_ConnectionException value)? connection,
    TResult Function(_UnauthorizedException value)? unauthorized,
    TResult Function(_ForbiddenException value)? forbidden,
    TResult Function(_UnknownException value)? unknown,
    TResult Function(_BusyException value)? busy,
    required TResult orElse(),
  }) {
    if (connection != null) {
      return connection(this);
    }
    return orElse();
  }
}

abstract class _ConnectionException implements DataSourceException {
  const factory _ConnectionException({final String? message}) =
      _$ConnectionExceptionImpl;

  @override
  String? get message;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionExceptionImplCopyWith<_$ConnectionExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedExceptionImplCopyWith<$Res>
    implements $DataSourceExceptionCopyWith<$Res> {
  factory _$$UnauthorizedExceptionImplCopyWith(
          _$UnauthorizedExceptionImpl value,
          $Res Function(_$UnauthorizedExceptionImpl) then) =
      __$$UnauthorizedExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$UnauthorizedExceptionImplCopyWithImpl<$Res>
    extends _$DataSourceExceptionCopyWithImpl<$Res, _$UnauthorizedExceptionImpl>
    implements _$$UnauthorizedExceptionImplCopyWith<$Res> {
  __$$UnauthorizedExceptionImplCopyWithImpl(_$UnauthorizedExceptionImpl _value,
      $Res Function(_$UnauthorizedExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$UnauthorizedExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnauthorizedExceptionImpl implements _UnauthorizedException {
  const _$UnauthorizedExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'DataSourceException.unauthorized(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnauthorizedExceptionImplCopyWith<_$UnauthorizedExceptionImpl>
      get copyWith => __$$UnauthorizedExceptionImplCopyWithImpl<
          _$UnauthorizedExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) serverError,
    required TResult Function(String? message) connection,
    required TResult Function(String? message) unauthorized,
    required TResult Function(String? message) forbidden,
    required TResult Function(String? message) unknown,
    required TResult Function(String? message) busy,
  }) {
    return unauthorized(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? serverError,
    TResult? Function(String? message)? connection,
    TResult? Function(String? message)? unauthorized,
    TResult? Function(String? message)? forbidden,
    TResult? Function(String? message)? unknown,
    TResult? Function(String? message)? busy,
  }) {
    return unauthorized?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? serverError,
    TResult Function(String? message)? connection,
    TResult Function(String? message)? unauthorized,
    TResult Function(String? message)? forbidden,
    TResult Function(String? message)? unknown,
    TResult Function(String? message)? busy,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServerException value) serverError,
    required TResult Function(_ConnectionException value) connection,
    required TResult Function(_UnauthorizedException value) unauthorized,
    required TResult Function(_ForbiddenException value) forbidden,
    required TResult Function(_UnknownException value) unknown,
    required TResult Function(_BusyException value) busy,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServerException value)? serverError,
    TResult? Function(_ConnectionException value)? connection,
    TResult? Function(_UnauthorizedException value)? unauthorized,
    TResult? Function(_ForbiddenException value)? forbidden,
    TResult? Function(_UnknownException value)? unknown,
    TResult? Function(_BusyException value)? busy,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServerException value)? serverError,
    TResult Function(_ConnectionException value)? connection,
    TResult Function(_UnauthorizedException value)? unauthorized,
    TResult Function(_ForbiddenException value)? forbidden,
    TResult Function(_UnknownException value)? unknown,
    TResult Function(_BusyException value)? busy,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class _UnauthorizedException implements DataSourceException {
  const factory _UnauthorizedException({final String? message}) =
      _$UnauthorizedExceptionImpl;

  @override
  String? get message;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnauthorizedExceptionImplCopyWith<_$UnauthorizedExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ForbiddenExceptionImplCopyWith<$Res>
    implements $DataSourceExceptionCopyWith<$Res> {
  factory _$$ForbiddenExceptionImplCopyWith(_$ForbiddenExceptionImpl value,
          $Res Function(_$ForbiddenExceptionImpl) then) =
      __$$ForbiddenExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ForbiddenExceptionImplCopyWithImpl<$Res>
    extends _$DataSourceExceptionCopyWithImpl<$Res, _$ForbiddenExceptionImpl>
    implements _$$ForbiddenExceptionImplCopyWith<$Res> {
  __$$ForbiddenExceptionImplCopyWithImpl(_$ForbiddenExceptionImpl _value,
      $Res Function(_$ForbiddenExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$ForbiddenExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ForbiddenExceptionImpl implements _ForbiddenException {
  const _$ForbiddenExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'DataSourceException.forbidden(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForbiddenExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForbiddenExceptionImplCopyWith<_$ForbiddenExceptionImpl> get copyWith =>
      __$$ForbiddenExceptionImplCopyWithImpl<_$ForbiddenExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) serverError,
    required TResult Function(String? message) connection,
    required TResult Function(String? message) unauthorized,
    required TResult Function(String? message) forbidden,
    required TResult Function(String? message) unknown,
    required TResult Function(String? message) busy,
  }) {
    return forbidden(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? serverError,
    TResult? Function(String? message)? connection,
    TResult? Function(String? message)? unauthorized,
    TResult? Function(String? message)? forbidden,
    TResult? Function(String? message)? unknown,
    TResult? Function(String? message)? busy,
  }) {
    return forbidden?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? serverError,
    TResult Function(String? message)? connection,
    TResult Function(String? message)? unauthorized,
    TResult Function(String? message)? forbidden,
    TResult Function(String? message)? unknown,
    TResult Function(String? message)? busy,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServerException value) serverError,
    required TResult Function(_ConnectionException value) connection,
    required TResult Function(_UnauthorizedException value) unauthorized,
    required TResult Function(_ForbiddenException value) forbidden,
    required TResult Function(_UnknownException value) unknown,
    required TResult Function(_BusyException value) busy,
  }) {
    return forbidden(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServerException value)? serverError,
    TResult? Function(_ConnectionException value)? connection,
    TResult? Function(_UnauthorizedException value)? unauthorized,
    TResult? Function(_ForbiddenException value)? forbidden,
    TResult? Function(_UnknownException value)? unknown,
    TResult? Function(_BusyException value)? busy,
  }) {
    return forbidden?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServerException value)? serverError,
    TResult Function(_ConnectionException value)? connection,
    TResult Function(_UnauthorizedException value)? unauthorized,
    TResult Function(_ForbiddenException value)? forbidden,
    TResult Function(_UnknownException value)? unknown,
    TResult Function(_BusyException value)? busy,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(this);
    }
    return orElse();
  }
}

abstract class _ForbiddenException implements DataSourceException {
  const factory _ForbiddenException({final String? message}) =
      _$ForbiddenExceptionImpl;

  @override
  String? get message;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForbiddenExceptionImplCopyWith<_$ForbiddenExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownExceptionImplCopyWith<$Res>
    implements $DataSourceExceptionCopyWith<$Res> {
  factory _$$UnknownExceptionImplCopyWith(_$UnknownExceptionImpl value,
          $Res Function(_$UnknownExceptionImpl) then) =
      __$$UnknownExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$UnknownExceptionImplCopyWithImpl<$Res>
    extends _$DataSourceExceptionCopyWithImpl<$Res, _$UnknownExceptionImpl>
    implements _$$UnknownExceptionImplCopyWith<$Res> {
  __$$UnknownExceptionImplCopyWithImpl(_$UnknownExceptionImpl _value,
      $Res Function(_$UnknownExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$UnknownExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnknownExceptionImpl implements _UnknownException {
  const _$UnknownExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'DataSourceException.unknown(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      __$$UnknownExceptionImplCopyWithImpl<_$UnknownExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) serverError,
    required TResult Function(String? message) connection,
    required TResult Function(String? message) unauthorized,
    required TResult Function(String? message) forbidden,
    required TResult Function(String? message) unknown,
    required TResult Function(String? message) busy,
  }) {
    return unknown(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? serverError,
    TResult? Function(String? message)? connection,
    TResult? Function(String? message)? unauthorized,
    TResult? Function(String? message)? forbidden,
    TResult? Function(String? message)? unknown,
    TResult? Function(String? message)? busy,
  }) {
    return unknown?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? serverError,
    TResult Function(String? message)? connection,
    TResult Function(String? message)? unauthorized,
    TResult Function(String? message)? forbidden,
    TResult Function(String? message)? unknown,
    TResult Function(String? message)? busy,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServerException value) serverError,
    required TResult Function(_ConnectionException value) connection,
    required TResult Function(_UnauthorizedException value) unauthorized,
    required TResult Function(_ForbiddenException value) forbidden,
    required TResult Function(_UnknownException value) unknown,
    required TResult Function(_BusyException value) busy,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServerException value)? serverError,
    TResult? Function(_ConnectionException value)? connection,
    TResult? Function(_UnauthorizedException value)? unauthorized,
    TResult? Function(_ForbiddenException value)? forbidden,
    TResult? Function(_UnknownException value)? unknown,
    TResult? Function(_BusyException value)? busy,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServerException value)? serverError,
    TResult Function(_ConnectionException value)? connection,
    TResult Function(_UnauthorizedException value)? unauthorized,
    TResult Function(_ForbiddenException value)? forbidden,
    TResult Function(_UnknownException value)? unknown,
    TResult Function(_BusyException value)? busy,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _UnknownException implements DataSourceException {
  const factory _UnknownException({final String? message}) =
      _$UnknownExceptionImpl;

  @override
  String? get message;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BusyExceptionImplCopyWith<$Res>
    implements $DataSourceExceptionCopyWith<$Res> {
  factory _$$BusyExceptionImplCopyWith(
          _$BusyExceptionImpl value, $Res Function(_$BusyExceptionImpl) then) =
      __$$BusyExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$BusyExceptionImplCopyWithImpl<$Res>
    extends _$DataSourceExceptionCopyWithImpl<$Res, _$BusyExceptionImpl>
    implements _$$BusyExceptionImplCopyWith<$Res> {
  __$$BusyExceptionImplCopyWithImpl(
      _$BusyExceptionImpl _value, $Res Function(_$BusyExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$BusyExceptionImpl(
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BusyExceptionImpl implements _BusyException {
  const _$BusyExceptionImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'DataSourceException.busy(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusyExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusyExceptionImplCopyWith<_$BusyExceptionImpl> get copyWith =>
      __$$BusyExceptionImplCopyWithImpl<_$BusyExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? message) serverError,
    required TResult Function(String? message) connection,
    required TResult Function(String? message) unauthorized,
    required TResult Function(String? message) forbidden,
    required TResult Function(String? message) unknown,
    required TResult Function(String? message) busy,
  }) {
    return busy(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message)? serverError,
    TResult? Function(String? message)? connection,
    TResult? Function(String? message)? unauthorized,
    TResult? Function(String? message)? forbidden,
    TResult? Function(String? message)? unknown,
    TResult? Function(String? message)? busy,
  }) {
    return busy?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message)? serverError,
    TResult Function(String? message)? connection,
    TResult Function(String? message)? unauthorized,
    TResult Function(String? message)? forbidden,
    TResult Function(String? message)? unknown,
    TResult Function(String? message)? busy,
    required TResult orElse(),
  }) {
    if (busy != null) {
      return busy(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ServerException value) serverError,
    required TResult Function(_ConnectionException value) connection,
    required TResult Function(_UnauthorizedException value) unauthorized,
    required TResult Function(_ForbiddenException value) forbidden,
    required TResult Function(_UnknownException value) unknown,
    required TResult Function(_BusyException value) busy,
  }) {
    return busy(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ServerException value)? serverError,
    TResult? Function(_ConnectionException value)? connection,
    TResult? Function(_UnauthorizedException value)? unauthorized,
    TResult? Function(_ForbiddenException value)? forbidden,
    TResult? Function(_UnknownException value)? unknown,
    TResult? Function(_BusyException value)? busy,
  }) {
    return busy?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ServerException value)? serverError,
    TResult Function(_ConnectionException value)? connection,
    TResult Function(_UnauthorizedException value)? unauthorized,
    TResult Function(_ForbiddenException value)? forbidden,
    TResult Function(_UnknownException value)? unknown,
    TResult Function(_BusyException value)? busy,
    required TResult orElse(),
  }) {
    if (busy != null) {
      return busy(this);
    }
    return orElse();
  }
}

abstract class _BusyException implements DataSourceException {
  const factory _BusyException({final String? message}) = _$BusyExceptionImpl;

  @override
  String? get message;

  /// Create a copy of DataSourceException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusyExceptionImplCopyWith<_$BusyExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
