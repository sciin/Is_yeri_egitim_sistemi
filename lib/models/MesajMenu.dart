
class MesajMenu {

  int id;
  String name;
  String profileImageLink;
  int type;

	MesajMenu({this.id, this.name, this.profileImageLink, this.type});

  MesajMenu.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		name = map["name"],
		profileImageLink = map["profileImageLink"],
		type = map["type"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		data['profileImageLink'] = profileImageLink;
		data['type'] = type;
		return data;
	}
}
