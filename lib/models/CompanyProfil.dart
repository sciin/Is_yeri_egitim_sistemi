// To parse this JSON data, do
//
//     final companyProfil = companyProfilFromJson(jsonString);

import 'dart:convert';

class CompanyProfil {
  String name;
  String email;
  String password;
  int authorizeType;
  dynamic aboutMe;
  String phoneNumber;
  dynamic address;
  int cityId;
  dynamic profileImageLink;
  int workerCount;
  dynamic city;
  dynamic adverts;
  int id;
  DateTime createdDate;
  DateTime modifiedDate;

  CompanyProfil({
    this.name,
    this.email,
    this.password,
    this.authorizeType,
    this.aboutMe,
    this.phoneNumber,
    this.address,
    this.cityId,
    this.profileImageLink,
    this.workerCount,
    this.city,
    this.adverts,
    this.id,
    this.createdDate,
    this.modifiedDate,
  });

  factory CompanyProfil.fromRawJson(String str) => CompanyProfil.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CompanyProfil.fromJson(Map<String, dynamic> json) => CompanyProfil(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    authorizeType: json["authorizeType"],
    aboutMe: json["aboutMe"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    cityId: json["cityId"],
    profileImageLink: json["profileImageLink"],
    workerCount: json["workerCount"],
    city: json["city"],
    adverts: json["adverts"],
    id: json["id"],
    createdDate: DateTime.parse(json["createdDate"]),
    modifiedDate: DateTime.parse(json["modifiedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "authorizeType": authorizeType,
    "aboutMe": aboutMe,
    "phoneNumber": phoneNumber,
    "address": address,
    "cityId": cityId,
    "profileImageLink": profileImageLink,
    "workerCount": workerCount,
    "city": city,
    "adverts": adverts,
    "id": id,
    "createdDate": createdDate.toIso8601String(),
    "modifiedDate": modifiedDate.toIso8601String(),
  };
}
