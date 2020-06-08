// To parse this JSON data, do
//
//     final notifications = notificationsFromJson(jsonString);

import 'dart:convert';

class Notifications {
  String title;
  String description;
  int teacherId;
  dynamic teacher;
  int id;
  String createdDate;
  String modifiedDate;

  Notifications({
    this.title,
    this.description,
    this.teacherId,
    this.teacher,
    this.id,
    this.createdDate,
    this.modifiedDate,
  });

  factory Notifications.fromRawJson(String str) => Notifications.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    title: json["title"],
    description: json["description"],
    teacherId: json["teacherId"],
    teacher: json["teacher"],
    id: json["id"],
    createdDate: json["createdDate"],
    modifiedDate: json["modifiedDate"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "teacherId": teacherId,
    "teacher": teacher,
    "id": id,
    "createdDate": createdDate,
    "modifiedDate": modifiedDate,
  };
}
