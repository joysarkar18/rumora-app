import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:campus_crush_app/app/utils/timestamp_to_date_converter.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  const factory CommentModel({
    @Default('') String id,
    @Default('') String postId,
    @Default('') String userId,
    @Default('') String username,
    @Default('') String gender,
    @Default('') String phoneNo,
    @Default('') String content,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    @Default(0) int likes,
    @Default([]) List<String> likedBy,
    @Default('') String parentCommentId, // For replies
    @Default(0) int repliesCount, // Number of replies
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  factory CommentModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};
    return CommentModel.fromJson({...data, 'id': snapshot.id});
  }
}
