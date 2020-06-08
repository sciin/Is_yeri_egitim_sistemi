// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

class Company {
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
  String createdDate;
  String modifiedDate;

  Company({
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

  factory Company.fromRawJson(String str) => Company.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Company.fromJson(Map<String, dynamic> json) => Company(
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
    createdDate: (json["createdDate"]),
    modifiedDate: (json["modifiedDate"]),
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
    "createdDate": createdDate,
    "modifiedDate": modifiedDate,
  };
}
