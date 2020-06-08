// To parse this JSON data, do
//
//     final Students = StudentsFromJson(jsonString);

import 'dart:convert';

class Students {
	String email;
	String password;
	String firstName;
	String lastName;
	dynamic aboutMe;
	String phoneNumber;
	int authorizeType;
	dynamic profileImageLink;
	dynamic cvLink;
	int teacherId;
	dynamic teacher;
	dynamic studentAdverts;
	int id;
	String createdDate;
	String modifiedDate;

	Students({
		this.email,
		this.password,
		this.firstName,
		this.lastName,
		this.aboutMe,
		this.phoneNumber,
		this.authorizeType,
		this.profileImageLink,
		this.cvLink,
		this.teacherId,
		this.teacher,
		this.studentAdverts,
		this.id,
		this.createdDate,
		this.modifiedDate,
	});

	factory Students.fromRawJson(String str) => Students.fromJson(json.decode(str));

	String toRawJson(Students data) => json.encode(data.toJson());

	factory Students.fromJson(Map<String, dynamic> json) => Students(
		email: json["email"],
		password: json["password"],
		firstName: json["firstName"],
		lastName: json["lastName"],
		aboutMe: json["aboutMe"],
		phoneNumber: json["phoneNumber"],
		authorizeType: json["authorizeType"],
		profileImageLink: json["profileImageLink"],
		cvLink: json["cvLink"],
		teacherId: json["teacherId"],
		teacher: json["teacher"],
		studentAdverts: json["studentAdverts"],
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
		"authorizeType": authorizeType,
		"profileImageLink": profileImageLink,
		"cvLink": cvLink,
		"teacherId": teacherId,
		"teacher": teacher,
		"studentAdverts": studentAdverts,
		"id": id,
		"createdDate": createdDate,
		"modifiedDate": modifiedDate,
	};
}
