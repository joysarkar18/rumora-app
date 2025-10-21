import 'package:campus_crush_app/app/utils/timestamp_to_date_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @Default('') String userId,
    @Default('') String phoneNo,
    @Default('') String username,
    @Default('') String gender,
    @NullableTimestampConverter() DateTime? dob,
    required College college,
    @Default('') String version,
    @Default('') String buildNumber,
    @Default('') String platform,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  factory UserModel.fromFirestoreSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    return UserModel.fromJson(snapshot.data() ?? {});
  }
}

@freezed
abstract class College with _$College {
  const factory College({
    @Default('') String id,
    @Default('') String name,
    @Default('') String district,
    @Default('') String state,
    @Default('') String website,
  }) = _College;

  factory College.fromJson(Map<String, dynamic> json) =>
      _$CollegeFromJson(json);

  factory College.empty() =>
      const College(id: '', name: '', district: '', state: '', website: '');
}
