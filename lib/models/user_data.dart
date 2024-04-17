import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserData {
  final String? city;
  final String? contactNumber;
  final String? email;
  final String? ic;
  final String? name;
  final String? occupation;
  final String? state;
  final String? userId;
  final String? uId;
  final String? userType;
  final String? deviceId;
  final bool? status;
  final List? docs;
  UserData({
    this.city,
    this.contactNumber,
    this.email,
    this.ic,
    this.name,
    this.occupation,
    this.state,
    this.userId,
    this.uId,
    this.userType,
    this.deviceId,
    this.status,
    this.docs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'contactNumber': contactNumber,
      'email': email,
      'ic': ic,
      'name': name,
      'occupation': occupation,
      'state': state,
      'userId': userId,
      'uId': uId,
      'userType': userType,
      'deviceId': deviceId,
      'status': status,
      'docs': docs,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      city: map['city'] != null ? map['city'] as String : null,
      contactNumber:
          map['contactNumber'] != null ? map['contactNumber'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      ic: map['ic'] != null ? map['ic'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      occupation:
          map['occupation'] != null ? map['occupation'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      uId: map['uId'] != null ? map['uId'] as String : null,
      userType: map['userType'] != null ? map['userType'] as String : null,
      deviceId: map['deviceId'] != null ? map['deviceId'] as String : null,
      status: map['status'] != null ? map['status'] as bool : null,
      docs: List.from((map['docs'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source) as Map<String, dynamic>);
}
