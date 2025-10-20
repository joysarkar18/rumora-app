// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  userId: json['userId'] as String? ?? '',
  phoneNo: json['phoneNo'] as String? ?? '',
  userName: json['userName'] as String? ?? '',
  gender: json['gender'] as String? ?? '',
  dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
  college: College.fromJson(json['college'] as Map<String, dynamic>),
  version: json['version'] as String? ?? '',
  buildNumber: json['buildNumber'] as String? ?? '',
  platform: json['platform'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phoneNo': instance.phoneNo,
      'userName': instance.userName,
      'gender': instance.gender,
      'dob': instance.dob?.toIso8601String(),
      'college': instance.college,
      'version': instance.version,
      'buildNumber': instance.buildNumber,
      'platform': instance.platform,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
