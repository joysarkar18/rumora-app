import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json == null) {
      return DateTime.now();
    }
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is DateTime) {
      return json;
    }
    throw ArgumentError('Invalid timestamp: $json');
  }

  @override
  dynamic toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}

class NullableTimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is DateTime) {
      return json;
    }
    throw ArgumentError('Invalid timestamp: $json');
  }

  @override
  dynamic toJson(DateTime? object) {
    return object != null ? Timestamp.fromDate(object) : null;
  }
}
