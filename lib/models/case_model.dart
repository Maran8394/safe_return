// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CaseModel {
  final bool isItSolved;
  final String? dateOfLastContact;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? circumstancesOfDisappearance;
  final String? name;
  final String? age;
  final String? race;
  final String? height;
  final String? weight;
  final String? hairColor;
  final String? eyeColor;
  final String? description;
  final List<String>? images;
  final List<String>? documents;
  final List<String>? enforcers;
  final String? userId;
  final String? caseId;
  CaseModel({
    required this.isItSolved,
    this.dateOfLastContact,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.circumstancesOfDisappearance,
    this.name,
    this.age,
    this.race,
    this.height,
    this.weight,
    this.hairColor,
    this.eyeColor,
    this.description,
    this.images,
    this.documents,
    this.enforcers,
    this.userId,
    this.caseId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isItSolved': isItSolved,
      'dateOfLastContact': dateOfLastContact,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'circumstancesOfDisappearance': circumstancesOfDisappearance,
      'name': name,
      'age': age,
      'race': race,
      'height': height,
      'weight': weight,
      'hairColor': hairColor,
      'eyeColor': eyeColor,
      'description': description,
      'images': images,
      'documents': documents,
      'enforcers': enforcers,
      'userId': userId,
      'caseId': caseId,
    };
  }

  factory CaseModel.fromMap(Map<String, dynamic> map) {
    return CaseModel(
      isItSolved: map['isItSolved'] as bool,
      dateOfLastContact: map['dateOfLastContact'] != null
          ? map['dateOfLastContact'] as String
          : null,
      city: map['city'] != null ? map['city'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      zipCode: map['zipCode'] != null ? map['zipCode'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      circumstancesOfDisappearance: map['circumstancesOfDisappearance'] != null
          ? map['circumstancesOfDisappearance'] as String
          : null,
      name: map['name'] != null ? map['name'] as String : null,
      age: map['age'] != null ? map['age'] as String : null,
      race: map['race'] != null ? map['race'] as String : null,
      height: map['height'] != null ? map['height'] as String : null,
      weight: map['weight'] != null ? map['weight'] as String : null,
      hairColor: map['hairColor'] != null ? map['hairColor'] as String : null,
      eyeColor: map['eyeColor'] != null ? map['eyeColor'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      images: map['images'] != null
          ? List<String>.from((map['images'] as List<dynamic>))
          : null,
      documents: map['documents'] != null
          ? List<String>.from((map['documents'] as List<dynamic>))
          : null,
      enforcers: map['enforcers'] != null
          ? List<String>.from((map['enforcers'] as List<dynamic>))
          : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      caseId: map['caseId'] != null ? map['caseId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CaseModel.fromJson(String source) =>
      CaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
