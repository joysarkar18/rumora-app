// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  college: College.fromJson(json['college'] as Map<String, dynamic>),
  comments: (json['comments'] as num?)?.toInt() ?? 0,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  userId: json['userId'] as String? ?? '',
  postId: json['postId'] as String? ?? '',
  phoneNo: json['phoneNo'] as String? ?? '',
  username: json['username'] as String? ?? '',
  gender: json['gender'] as String? ?? '',
  postContent: json['postContent'] as String? ?? '',
  poops: (json['poops'] as num?)?.toInt() ?? 0,
  poopBy:
      (json['poopBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  likes: (json['likes'] as num?)?.toInt() ?? 0,
  likedBy:
      (json['likedBy'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'college': instance.college,
      'comments': instance.comments,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'userId': instance.userId,
      'postId': instance.postId,
      'phoneNo': instance.phoneNo,
      'username': instance.username,
      'gender': instance.gender,
      'postContent': instance.postContent,
      'poops': instance.poops,
      'poopBy': instance.poopBy,
      'likes': instance.likes,
      'likedBy': instance.likedBy,
      'imageUrls': instance.imageUrls,
    };
