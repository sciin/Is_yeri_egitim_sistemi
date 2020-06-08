class Ilan {

	int id;
	String title;
	String description;
	String createdDate;
	String modifiedDate;
	Company company;

	Ilan({this.id,this.title,this.description,this.createdDate,this.modifiedDate,this.company});

	Ilan.fromJsonMap(Map<String, dynamic> map):
				id = map["id"],
				title = map["title"],
				description = map["description"],
				createdDate = map["createdDate"],
				modifiedDate = map["modifiedDate"],
				company = Company.fromJsonMap(map["company"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['title'] = title;
		data['description'] = description;
		data['createdDate'] = createdDate;
		data['modifiedDate'] = modifiedDate;
		data['company'] = company == null ? null : company.toJson();
		return data;
	}
}

class Company {

	int id;
	String name;
	String email;
	Object aboutMe;
	Object phoneNumber;
	Object address;
	int workerCount;
	Object profileImageLink;
	City city;

	Company({this.id,this.name,this.email,this.aboutMe,this.address,this.phoneNumber,this.city,this.profileImageLink,this.workerCount});

	Company.fromJsonMap(Map<String, dynamic> map):
				id = map["id"],
				name = map["name"],
				email = map["email"],
				aboutMe = map["aboutMe"],
				phoneNumber = map["phoneNumber"],
				address = map["address"],
				workerCount = map["workerCount"],
				profileImageLink = map["profileImageLink"],
				city = City.fromJsonMap(map["city"]);

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		data['email'] = email;
		data['aboutMe'] = aboutMe;
		data['phoneNumber'] = phoneNumber;
		data['address'] = address;
		data['workerCount'] = workerCount;
		data['profileImageLink'] = profileImageLink;
		data['city'] = city == null ? null : city.toJson();
		return data;
	}
}
class City {

	String name;
	int id;
	String createdDate;
	String modifiedDate;

	City({this.name,this.id,this.createdDate,this.modifiedDate});

	City.fromJsonMap(Map<String, dynamic> map):
				name = map["name"],
				id = map["id"],
				createdDate = map["createdDate"],
				modifiedDate = map["modifiedDate"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['name'] = name;
		data['id'] = id;
		data['createdDate'] = createdDate;
		data['modifiedDate'] = modifiedDate;
		return data;
	}
}

