// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  userId: json['userId'] as String? ?? '',
  phoneNo: json['phoneNo'] as String? ?? '',
  username: json['username'] as String? ?? '',
  gender: json['gender'] as String? ?? '',
  dob: const NullableTimestampConverter().fromJson(json['dob']),
  college: College.fromJson(json['college'] as Map<String, dynamic>),
  version: json['version'] as String? ?? '',
  buildNumber: json['buildNumber'] as String? ?? '',
  platform: json['platform'] as String? ?? '',
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phoneNo': instance.phoneNo,
      'username': instance.username,
      'gender': instance.gender,
      'dob': const NullableTimestampConverter().toJson(instance.dob),
      'college': instance.college,
      'version': instance.version,
      'buildNumber': instance.buildNumber,
      'platform': instance.platform,
      'interests': instance.interests,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

_College _$CollegeFromJson(Map<String, dynamic> json) => _College(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  district: json['district'] as String? ?? '',
  state: json['state'] as String? ?? '',
  website: json['website'] as String? ?? '',
);

Map<String, dynamic> _$CollegeToJson(_College instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'district': instance.district,
  'state': instance.state,
  'website': instance.website,
};
