import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Anasayfa.dart';
import 'package:flutterprojeapp/Giris.dart';

import 'models/Duyurular.dart';
import 'models/Notifications.dart';
import 'models/Teachers.dart';
import 'package:http/http.dart' as http;

class DuyuruDetay extends StatefulWidget {
  var notification,comigType,comingToken,kullanici_adi;
  DuyuruDetay(this.notification,this.comigType,this.kullanici_adi,this.comingToken);

  @override
  _DuyuruDetayState createState() => _DuyuruDetayState();
}

class _DuyuruDetayState extends State<DuyuruDetay> {

  String teacherName,notificationTitle,notificationDescription;
  String url = "https://yusufyilmaz.org/api";
  Future<Notifications> notificationData;
  Future<Notifications> _updateNotification;
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  TextEditingController descriptionController;
  TextEditingController titleController;


  Future<Teachers> getTeachers() async{
    var response = await http.get('$url/teachers');

    var data = jsonDecode(response.body);

    List responseData = data['data'];
    List<Teachers> teacherList = [];
    List<String> teacherNameList = [];
    teacherList=(responseData as List).map((i) =>
        Teachers.fromJson(i)).toList();
    //print(teacherList.length)
    for(int i = 0; i<teacherList.length;i++) {
      teacherNameList.add(responseData[i]["firstName"]);
      if (widget.notification.teacherId == responseData[i]["id"])
        setState(() {
          teacherName = responseData[i]["firstName"] +" " +  responseData[i]["lastName"];
        });
    }
  }


  Future<Notifications> getNotifications() async {
      final response =
      await http.get('$url/notifications/${widget.notification.id}');

      if (response.statusCode == 200) {
        return Notifications.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load Notifications');
      }
  }

  Future<Notifications> updateNotification(String title,String description)  async {

    final response = await http.put('$url/notifications/${widget.notification.id}',
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': widget.comingToken
        },
      body: jsonEncode(<String, String>{
      'title': title,
      'description': description,
      }),
    );
    if (response.statusCode == 200) {
      hataGoster("Güncelleme Başarılı");
      return Notifications.fromJson(json.decode(response.body));
    } else {
         hataGoster("Güncelleme Başarısız");
    }
  }

  void hataGoster(var s) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (s == "Güncelleme Başarılı") ?  Text("Bilgilendirme") : new Text("Güncelleme Hatası"),
          content: new Text("$s"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Kapat"),
              onPressed: () {
                if(s == "Güncelleme Başarılı")
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Anasayfa()));
                else
                  Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeachers();
    getNotifications();
    _updateNotification = getNotifications();
    if(widget.comigType == 2){
      descriptionController = new TextEditingController(text: '${widget.notification.description}');
      titleController = new TextEditingController(text: '${widget.notification.title}');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.notification.title}"),

        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    Icon(Icons.person, size: 27),
                    Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * .01),
                      child:
                      Text('$teacherName'.toUpperCase(), style: TextStyle(fontSize: 17)),
                    ),
                  ],
                ),
                Wrap(
                  children: <Widget>[
                    Icon(Icons.update, size: 27),
                    Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * .01),
                      child:
                      TarihHesapla(widget.notification.createdDate),
                    ),
                  ],
                )
              ],
            ),
            (widget.comigType == 2 && widget.notification.teacherId == Giris.kullanici_id) ? Form(
              key: formKey,
              child: FutureBuilder<Notifications>(
                future: _updateNotification,
                builder: (context,snapshot){
                  return TextField(
                    maxLength: 1000,
                    controller: descriptionController,
                    minLines: 1,
                    maxLines: 100,
                    onChanged: (chanceDescription){
                      notificationDescription = chanceDescription;
                    },
                  );
                },
              ),
            ) : Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              child: Text(widget.notification.description, style: TextStyle(fontSize: 16)),
            ),

          ],
        ),
      ),
         floatingActionButton: (widget.comigType == 2 && Giris.kullanici_id == widget.notification.teacherId) ? new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.save),
               backgroundColor: new Color(0xFFE57373),
              onPressed: (){
              if(formKey.currentState.validate())
               {
                 formKey.currentState.save();
                setState(() {
                  _updateNotification = updateNotification(widget.notification.title,notificationDescription);

                });
               }
              else print("asdsa");
            }
        ) : null
    );
  }
  TarihHesapla(comingVariable) {
    var tarih = DateTime.parse(comingVariable);
    String temp = ""+tarih.day.toString()+"."+tarih.month.toString()+"."+tarih.year.toString() + " " + tarih.hour.toString() + ":" + tarih.minute.toString();
    return Text("$temp",style: TextStyle(fontSize: 16),);
  }

}
