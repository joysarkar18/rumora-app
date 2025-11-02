// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentModel {

 String get id; String get postId; String get userId; String get username; String get gender; String get phoneNo; String get content;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; int get likes; List<String> get likedBy; String get parentCommentId;// For replies
 int get repliesCount;
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentModelCopyWith<CommentModel> get copyWith => _$CommentModelCopyWithImpl<CommentModel>(this as CommentModel, _$identity);

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.likes, likes) || other.likes == likes)&&const DeepCollectionEquality().equals(other.likedBy, likedBy)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,userId,username,gender,phoneNo,content,createdAt,updatedAt,likes,const DeepCollectionEquality().hash(likedBy),parentCommentId,repliesCount);

@override
String toString() {
  return 'CommentModel(id: $id, postId: $postId, userId: $userId, username: $username, gender: $gender, phoneNo: $phoneNo, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, likes: $likes, likedBy: $likedBy, parentCommentId: $parentCommentId, repliesCount: $repliesCount)';
}


}

/// @nodoc
abstract mixin class $CommentModelCopyWith<$Res>  {
  factory $CommentModelCopyWith(CommentModel value, $Res Function(CommentModel) _then) = _$CommentModelCopyWithImpl;
@useResult
$Res call({
 String id, String postId, String userId, String username, String gender, String phoneNo, String content,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, int likes, List<String> likedBy, String parentCommentId, int repliesCount
});




}
/// @nodoc
class _$CommentModelCopyWithImpl<$Res>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._self, this._then);

  final CommentModel _self;
  final $Res Function(CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? userId = null,Object? username = null,Object? gender = null,Object? phoneNo = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,Object? likes = null,Object? likedBy = null,Object? parentCommentId = null,Object? repliesCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,phoneNo: null == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self.likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,parentCommentId: null == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String,repliesCount: null == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentModel].
extension CommentModelPatterns on CommentModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentModel value)  $default,){
final _that = this;
switch (_that) {
case _CommentModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String postId,  String userId,  String username,  String gender,  String phoneNo,  String content, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  int likes,  List<String> likedBy,  String parentCommentId,  int repliesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.postId,_that.userId,_that.username,_that.gender,_that.phoneNo,_that.content,_that.createdAt,_that.updatedAt,_that.likes,_that.likedBy,_that.parentCommentId,_that.repliesCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String postId,  String userId,  String username,  String gender,  String phoneNo,  String content, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  int likes,  List<String> likedBy,  String parentCommentId,  int repliesCount)  $default,) {final _that = this;
switch (_that) {
case _CommentModel():
return $default(_that.id,_that.postId,_that.userId,_that.username,_that.gender,_that.phoneNo,_that.content,_that.createdAt,_that.updatedAt,_that.likes,_that.likedBy,_that.parentCommentId,_that.repliesCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String postId,  String userId,  String username,  String gender,  String phoneNo,  String content, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  int likes,  List<String> likedBy,  String parentCommentId,  int repliesCount)?  $default,) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.postId,_that.userId,_that.username,_that.gender,_that.phoneNo,_that.content,_that.createdAt,_that.updatedAt,_that.likes,_that.likedBy,_that.parentCommentId,_that.repliesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentModel implements CommentModel {
  const _CommentModel({this.id = '', this.postId = '', this.userId = '', this.username = '', this.gender = '', this.phoneNo = '', this.content = '', @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, this.likes = 0, final  List<String> likedBy = const [], this.parentCommentId = '', this.repliesCount = 0}): _likedBy = likedBy;
  factory _CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String postId;
@override@JsonKey() final  String userId;
@override@JsonKey() final  String username;
@override@JsonKey() final  String gender;
@override@JsonKey() final  String phoneNo;
@override@JsonKey() final  String content;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override@JsonKey() final  int likes;
 final  List<String> _likedBy;
@override@JsonKey() List<String> get likedBy {
  if (_likedBy is EqualUnmodifiableListView) return _likedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likedBy);
}

@override@JsonKey() final  String parentCommentId;
// For replies
@override@JsonKey() final  int repliesCount;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentModelCopyWith<_CommentModel> get copyWith => __$CommentModelCopyWithImpl<_CommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.likes, likes) || other.likes == likes)&&const DeepCollectionEquality().equals(other._likedBy, _likedBy)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.repliesCount, repliesCount) || other.repliesCount == repliesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,userId,username,gender,phoneNo,content,createdAt,updatedAt,likes,const DeepCollectionEquality().hash(_likedBy),parentCommentId,repliesCount);

@override
String toString() {
  return 'CommentModel(id: $id, postId: $postId, userId: $userId, username: $username, gender: $gender, phoneNo: $phoneNo, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, likes: $likes, likedBy: $likedBy, parentCommentId: $parentCommentId, repliesCount: $repliesCount)';
}


}

/// @nodoc
abstract mixin class _$CommentModelCopyWith<$Res> implements $CommentModelCopyWith<$Res> {
  factory _$CommentModelCopyWith(_CommentModel value, $Res Function(_CommentModel) _then) = __$CommentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String postId, String userId, String username, String gender, String phoneNo, String content,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, int likes, List<String> likedBy, String parentCommentId, int repliesCount
});




}
/// @nodoc
class __$CommentModelCopyWithImpl<$Res>
    implements _$CommentModelCopyWith<$Res> {
  __$CommentModelCopyWithImpl(this._self, this._then);

  final _CommentModel _self;
  final $Res Function(_CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? userId = null,Object? username = null,Object? gender = null,Object? phoneNo = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,Object? likes = null,Object? likedBy = null,Object? parentCommentId = null,Object? repliesCount = null,}) {
  return _then(_CommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,phoneNo: null == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self._likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,parentCommentId: null == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String,repliesCount: null == repliesCount ? _self.repliesCount : repliesCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
