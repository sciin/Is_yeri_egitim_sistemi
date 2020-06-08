
class Kayit {

  String email;
  String password;
  String firstName;
  String lastName;
  Object aboutMe;
  String phoneNumber;
  Object profileImageLink;
  int authorizeType;
  Object students;
  Object notifications;
  int id;
  String createdDate;
  String modifiedDate;

	Kayit.fromJsonMap(Map<String, dynamic> map): 
		email = map["email"],
		password = map["password"],
		firstName = map["firstName"],
		lastName = map["lastName"],
		aboutMe = map["aboutMe"],
		phoneNumber = map["phoneNumber"],
		profileImageLink = map["profileImageLink"],
		authorizeType = map["authorizeType"],
		students = map["students"],
		notifications = map["notifications"],
		id = map["id"],
		createdDate = map["createdDate"],
		modifiedDate = map["modifiedDate"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['email'] = email;
		data['password'] = password;
		data['firstName'] = firstName;
		data['lastName'] = lastName;
		data['aboutMe'] = aboutMe;
		data['phoneNumber'] = phoneNumber;
		data['profileImageLink'] = profileImageLink;
		data['authorizeType'] = authorizeType;
		data['students'] = students;
		data['notifications'] = notifications;
		data['id'] = id;
		data['createdDate'] = createdDate;
		data['modifiedDate'] = modifiedDate;
		return data;
	}
}
