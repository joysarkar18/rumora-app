// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      id: json['id'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      phoneNo: json['phoneNo'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy:
          (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parentCommentId: json['parentCommentId'] as String? ?? '',
      repliesCount: (json['repliesCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'username': instance.username,
      'gender': instance.gender,
      'phoneNo': instance.phoneNo,
      'content': instance.content,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'likes': instance.likes,
      'likedBy': instance.likedBy,
      'parentCommentId': instance.parentCommentId,
      'repliesCount': instance.repliesCount,
    };
