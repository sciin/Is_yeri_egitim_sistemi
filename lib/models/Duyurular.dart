
class Duyurular {

  String duyuru_basligi;
  String icerik;

	Duyurular.fromJsonMap(Map<String, dynamic> map): 
		duyuru_basligi = map["duyuru_basligi"],
		icerik = map["icerik"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['duyuru_basligi'] = duyuru_basligi;
		data['icerik'] = icerik;
		return data;
	}
}
