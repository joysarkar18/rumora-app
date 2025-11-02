// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostModel {

 College get college; int get comments;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt; String get userId; String get postId; String get phoneNo; String get username; String get gender; String get postContent; int get poops; List<String> get poopBy; int get likes; List<String> get likedBy; List<String> get imageUrls;
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostModelCopyWith<PostModel> get copyWith => _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostModel&&(identical(other.college, college) || other.college == college)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.username, username) || other.username == username)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.postContent, postContent) || other.postContent == postContent)&&(identical(other.poops, poops) || other.poops == poops)&&const DeepCollectionEquality().equals(other.poopBy, poopBy)&&(identical(other.likes, likes) || other.likes == likes)&&const DeepCollectionEquality().equals(other.likedBy, likedBy)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,college,comments,createdAt,updatedAt,userId,postId,phoneNo,username,gender,postContent,poops,const DeepCollectionEquality().hash(poopBy),likes,const DeepCollectionEquality().hash(likedBy),const DeepCollectionEquality().hash(imageUrls));

@override
String toString() {
  return 'PostModel(college: $college, comments: $comments, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, postId: $postId, phoneNo: $phoneNo, username: $username, gender: $gender, postContent: $postContent, poops: $poops, poopBy: $poopBy, likes: $likes, likedBy: $likedBy, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res>  {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) = _$PostModelCopyWithImpl;
@useResult
$Res call({
 College college, int comments,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String userId, String postId, String phoneNo, String username, String gender, String postContent, int poops, List<String> poopBy, int likes, List<String> likedBy, List<String> imageUrls
});


$CollegeCopyWith<$Res> get college;

}
/// @nodoc
class _$PostModelCopyWithImpl<$Res>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? college = null,Object? comments = null,Object? createdAt = null,Object? updatedAt = null,Object? userId = null,Object? postId = null,Object? phoneNo = null,Object? username = null,Object? gender = null,Object? postContent = null,Object? poops = null,Object? poopBy = null,Object? likes = null,Object? likedBy = null,Object? imageUrls = null,}) {
  return _then(_self.copyWith(
college: null == college ? _self.college : college // ignore: cast_nullable_to_non_nullable
as College,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,phoneNo: null == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,postContent: null == postContent ? _self.postContent : postContent // ignore: cast_nullable_to_non_nullable
as String,poops: null == poops ? _self.poops : poops // ignore: cast_nullable_to_non_nullable
as int,poopBy: null == poopBy ? _self.poopBy : poopBy // ignore: cast_nullable_to_non_nullable
as List<String>,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self.likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollegeCopyWith<$Res> get college {
  
  return $CollegeCopyWith<$Res>(_self.college, (value) {
    return _then(_self.copyWith(college: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostModel].
extension PostModelPatterns on PostModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostModel value)  $default,){
final _that = this;
switch (_that) {
case _PostModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( College college,  int comments, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String userId,  String postId,  String phoneNo,  String username,  String gender,  String postContent,  int poops,  List<String> poopBy,  int likes,  List<String> likedBy,  List<String> imageUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.college,_that.comments,_that.createdAt,_that.updatedAt,_that.userId,_that.postId,_that.phoneNo,_that.username,_that.gender,_that.postContent,_that.poops,_that.poopBy,_that.likes,_that.likedBy,_that.imageUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( College college,  int comments, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String userId,  String postId,  String phoneNo,  String username,  String gender,  String postContent,  int poops,  List<String> poopBy,  int likes,  List<String> likedBy,  List<String> imageUrls)  $default,) {final _that = this;
switch (_that) {
case _PostModel():
return $default(_that.college,_that.comments,_that.createdAt,_that.updatedAt,_that.userId,_that.postId,_that.phoneNo,_that.username,_that.gender,_that.postContent,_that.poops,_that.poopBy,_that.likes,_that.likedBy,_that.imageUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( College college,  int comments, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  String userId,  String postId,  String phoneNo,  String username,  String gender,  String postContent,  int poops,  List<String> poopBy,  int likes,  List<String> likedBy,  List<String> imageUrls)?  $default,) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.college,_that.comments,_that.createdAt,_that.updatedAt,_that.userId,_that.postId,_that.phoneNo,_that.username,_that.gender,_that.postContent,_that.poops,_that.poopBy,_that.likes,_that.likedBy,_that.imageUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostModel implements PostModel {
  const _PostModel({required this.college, this.comments = 0, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, this.userId = '', this.postId = '', this.phoneNo = '', this.username = '', this.gender = '', this.postContent = '', this.poops = 0, final  List<String> poopBy = const [], this.likes = 0, final  List<String> likedBy = const [], final  List<String> imageUrls = const []}): _poopBy = poopBy,_likedBy = likedBy,_imageUrls = imageUrls;
  factory _PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

@override final  College college;
@override@JsonKey() final  int comments;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;
@override@JsonKey() final  String userId;
@override@JsonKey() final  String postId;
@override@JsonKey() final  String phoneNo;
@override@JsonKey() final  String username;
@override@JsonKey() final  String gender;
@override@JsonKey() final  String postContent;
@override@JsonKey() final  int poops;
 final  List<String> _poopBy;
@override@JsonKey() List<String> get poopBy {
  if (_poopBy is EqualUnmodifiableListView) return _poopBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_poopBy);
}

@override@JsonKey() final  int likes;
 final  List<String> _likedBy;
@override@JsonKey() List<String> get likedBy {
  if (_likedBy is EqualUnmodifiableListView) return _likedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_likedBy);
}

 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}


/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostModelCopyWith<_PostModel> get copyWith => __$PostModelCopyWithImpl<_PostModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostModel&&(identical(other.college, college) || other.college == college)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.phoneNo, phoneNo) || other.phoneNo == phoneNo)&&(identical(other.username, username) || other.username == username)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.postContent, postContent) || other.postContent == postContent)&&(identical(other.poops, poops) || other.poops == poops)&&const DeepCollectionEquality().equals(other._poopBy, _poopBy)&&(identical(other.likes, likes) || other.likes == likes)&&const DeepCollectionEquality().equals(other._likedBy, _likedBy)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,college,comments,createdAt,updatedAt,userId,postId,phoneNo,username,gender,postContent,poops,const DeepCollectionEquality().hash(_poopBy),likes,const DeepCollectionEquality().hash(_likedBy),const DeepCollectionEquality().hash(_imageUrls));

@override
String toString() {
  return 'PostModel(college: $college, comments: $comments, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, postId: $postId, phoneNo: $phoneNo, username: $username, gender: $gender, postContent: $postContent, poops: $poops, poopBy: $poopBy, likes: $likes, likedBy: $likedBy, imageUrls: $imageUrls)';
}


}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res> implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(_PostModel value, $Res Function(_PostModel) _then) = __$PostModelCopyWithImpl;
@override @useResult
$Res call({
 College college, int comments,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, String userId, String postId, String phoneNo, String username, String gender, String postContent, int poops, List<String> poopBy, int likes, List<String> likedBy, List<String> imageUrls
});


@override $CollegeCopyWith<$Res> get college;

}
/// @nodoc
class __$PostModelCopyWithImpl<$Res>
    implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? college = null,Object? comments = null,Object? createdAt = null,Object? updatedAt = null,Object? userId = null,Object? postId = null,Object? phoneNo = null,Object? username = null,Object? gender = null,Object? postContent = null,Object? poops = null,Object? poopBy = null,Object? likes = null,Object? likedBy = null,Object? imageUrls = null,}) {
  return _then(_PostModel(
college: null == college ? _self.college : college // ignore: cast_nullable_to_non_nullable
as College,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,phoneNo: null == phoneNo ? _self.phoneNo : phoneNo // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,postContent: null == postContent ? _self.postContent : postContent // ignore: cast_nullable_to_non_nullable
as String,poops: null == poops ? _self.poops : poops // ignore: cast_nullable_to_non_nullable
as int,poopBy: null == poopBy ? _self._poopBy : poopBy // ignore: cast_nullable_to_non_nullable
as List<String>,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,likedBy: null == likedBy ? _self._likedBy : likedBy // ignore: cast_nullable_to_non_nullable
as List<String>,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollegeCopyWith<$Res> get college {
  
  return $CollegeCopyWith<$Res>(_self.college, (value) {
    return _then(_self.copyWith(college: value));
  });
}
}

// dart format on
