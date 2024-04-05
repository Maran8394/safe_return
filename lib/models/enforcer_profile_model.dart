import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class EnforcerProfileModel {
  String id;
  String name;
  String station;
  EnforcerProfileModel({
    required this.id,
    required this.name,
    required this.station,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'station': station,
    };
  }

  factory EnforcerProfileModel.fromMap(Map<String, dynamic> map) {
    return EnforcerProfileModel(
      id: map['id'] as String,
      name: map['name'] as String,
      station: map['station'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EnforcerProfileModel.fromJson(String source) =>
      EnforcerProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
