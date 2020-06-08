// To parse this JSON data, do
//
//     final Teachers = TeachersFromJson(jsonString);

import 'dart:convert';

class Teachers {
  String email;
  String password;
  String firstName;
  String lastName;
  dynamic aboutMe;
  String phoneNumber;
  dynamic profileImageLink;
  int authorizeType;
  dynamic students;
  dynamic notifications;
  int id;
  String createdDate;
  String modifiedDate;

  Teachers({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.aboutMe,
    this.phoneNumber,
    this.profileImageLink,
    this.authorizeType,
    this.students,
    this.notifications,
    this.id,
    this.createdDate,
    this.modifiedDate,
  });

  factory Teachers.fromRawJson(String str) => Teachers.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Teachers.fromJson(Map<String, dynamic> json) => Teachers(
    email: json["email"],
    password: json["password"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    aboutMe: json["aboutMe"],
    phoneNumber: json["phoneNumber"],
    profileImageLink: json["profileImageLink"],
    authorizeType: json["authorizeType"],
    students: json["students"],
    notifications: json["notifications"],
    id: json["id"],
    createdDate: (json["createdDate"]),
    modifiedDate: (json["modifiedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "firstName": firstName,
    "lastName": lastName,
    "aboutMe": aboutMe,
    "phoneNumber": phoneNumber,
    "profileImageLink": profileImageLink,
    "authorizeType": authorizeType,
    "students": students,
    "notifications": notifications,
    "id": id,
    "createdDate": createdDate,
    "modifiedDate": modifiedDate,
  };
}
