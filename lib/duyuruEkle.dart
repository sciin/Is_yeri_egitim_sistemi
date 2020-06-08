import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Anasayfa.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:flutterprojeapp/models/Duyurular.dart';
import 'package:http/http.dart' as http;

class DuyuruEkle extends StatefulWidget {
  bool delete = false;
  Color baskinRenk;
  var comingMail;
  @override
  _DuyuruEkleState createState() => _DuyuruEkleState();
  DuyuruEkle([this.baskinRenk,comingMail]);
}

class _DuyuruEkleState extends State<DuyuruEkle> {
  String url = "https://yusufyilmaz.org/api";
  String notificationTitle,notificationDescription;
  var formKey = GlobalKey<FormState>();

  Future<http.Response> postNotification() async{
    var response = await http.post('$url/notifications',
    headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': Giris.token
    },
      body: jsonEncode(<String,Object>{
        'title' : notificationTitle,
        'description' : notificationDescription,
      }),
    );

    if(notificationTitle == "" || notificationDescription == ""){
        hataGoster("Duyuru Ekleme Başarısız");
      }
    else{
        hataGoster("Duyuru Ekleme Başarılı");
      }


  }

  void hataGoster(var s) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (s == "Duyuru Ekleme Başarısız") ? new Text("Ekleme Hatası") : Text("Bildirim"),
          content: new Text("$s"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                if(s == "Duyuru Ekleme Başarılı")
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
    print(Giris.token);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Duyuru Ekle"),
            centerTitle: true,
            expandedHeight: 60,
            elevation: 4,
            pinned: true,
            backgroundColor:
            widget.baskinRenk != null ? widget.baskinRenk : Colors.pink,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/headerimage.jpg",
                fit: BoxFit.cover,
              ),
            ),
            
          ),
          SliverList(
            delegate: SliverChildListDelegate(children()),
          ),
        ],
      ),

    );
  }

  List<Widget> children(){
    return [
      Form(
        key: formKey,
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            children: <Widget>[

              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Duyuru Başlığı",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
                    ),

                    onSaved: (responseVariable) {
                     setState(() {
                       notificationTitle = responseVariable;
                     });
                    },
                  ),
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    maxLength: 10000,
                    minLines: 1,
                    maxLines: 100,
                    decoration: InputDecoration(
                      labelText: "Duyuru İçeriği",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
                    ),

                    onSaved: (responseVariable) {
                       setState(() {
                         notificationDescription = responseVariable;
                       });
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight + Alignment(-0, 0),
                child: RaisedButton(
                  onPressed: () {
                      if(formKey.currentState.validate()){
                        formKey.currentState.save();
                        postNotification();

                      }
                      else
                        print("Kayıt Başarısız");
                  },
                  child: Text(
                    "Duyuru Yap",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),

    ];
  }
}
