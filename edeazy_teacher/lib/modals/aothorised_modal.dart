// To parse this JSON data, do
//
//     final myEvents = myEventsFromJson(jsonString);

import 'dart:convert';

UserData myEventsFromJson(String str) => UserData.fromJson(json.decode(str));

String myEventsToJson(UserData data) => json.encode(data.toJson());


class UserData {
  UserData({
    required this.token,
    required this.url,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.role,
    required this.id,
    required this.organisationId,
    required this.lectures
  });

  final String token;
  final String url;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final String gender;
  final String role;
  final String id;
  final String organisationId;
  final List<String> lectures;

  UserData copyWith({
    String? token,
    String? organisationId,
    String? url,
    String? name,
    String? address,
    String? email,
    String? phoneNumber,
    String? gender,
    String? role,
    String? id,
    List<String>? lectures
  }) =>
      UserData(
        token: token ?? this.token,
        organisationId:organisationId??this.organisationId,
        url: url ?? this.url,
        name: name ?? this.name,
        address: address ?? this.address,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        gender: gender ?? this.gender,
        role: role ?? this.role,
        id: id ?? this.id,
        lectures: lectures ?? this.lectures,
      );

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        token: json["token"],
        organisationId:json['organisationId'],
        url: json["imageUrl"],
        name: json["name"],
        address: json["address"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
        role: json["role"],
        id: json["_id"],
        lectures : List<String>.from(json['lectureIds'].map((x)=>x)),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "organisationId":organisationId,
        "imageUrl": url,
        "name": name,
        "address": address,
        "email": email,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "role": role,
        "_id": id,
        "lectureIds":List<dynamic>.from(lectures.map((x)=>x)),
      };
}
