import 'package:campus_crush_app/app/data/models/user_model.dart';
import 'package:campus_crush_app/app/utils/timestamp_to_date_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    required College college,
    @Default(0) int comments,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    @Default('') String userId,
    @Default('') String postId,
    @Default('') String phoneNo,
    @Default('') String username,
    @Default('') String gender,
    @Default('') String postContent,
    @Default(0) int poops,
    @Default([]) List<String> poopBy,
    @Default(0) int likes,
    @Default([]) List<String> likedBy,
    @Default([]) List<String> imageUrls,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    return PostModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  factory PostModel.fromFirestoreSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return PostModel.fromJson(snapshot.data() ?? {});
  }
}
