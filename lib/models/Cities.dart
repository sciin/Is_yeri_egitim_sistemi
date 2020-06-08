// To parse this JSON data, do
//
//     final Cities = CitiesFromJson(jsonString);

import 'dart:convert';

class Cities {
  String name;
  int id;
  String createdDate;
  String modifiedDate;

  Cities({
    this.name,
    this.id,
    this.createdDate,
    this.modifiedDate,
  });

  factory Cities.fromRawJson(String str) => Cities.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cities.fromJson(Map<String, dynamic> json) => Cities(
    name: json["name"],
    id: json["id"],
    createdDate: json["createdDate"],
    modifiedDate: json["modifiedDate"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "createdDate": createdDate,
    "modifiedDate": modifiedDate,
  };
}
