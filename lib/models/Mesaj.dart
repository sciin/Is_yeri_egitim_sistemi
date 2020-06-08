
class Mesaj {

  int senderId;
  int receiverId;
  String text;
  int senderType;
  int receiverType;
  int id;
  String createdDate;
  String modifiedDate;

	Mesaj.fromJsonMap(Map<String, dynamic> map): 
		senderId = map["senderId"],
		receiverId = map["receiverId"],
		text = map["text"],
		senderType = map["senderType"],
		receiverType = map["receiverType"],
		id = map["id"],
		createdDate = map["createdDate"],
		modifiedDate = map["modifiedDate"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['senderId'] = senderId;
		data['receiverId'] = receiverId;
		data['text'] = text;
		data['senderType'] = senderType;
		data['receiverType'] = receiverType;
		data['id'] = id;
		data['createdDate'] = createdDate;
		data['modifiedDate'] = modifiedDate;
		return data;
	}
}
