import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Anasayfa.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class IlanEkle extends StatefulWidget {
  Color baskinRenk;

  IlanEkle(this.baskinRenk);

  @override
  _IlanEkleState createState() => _IlanEkleState();
}

class _IlanEkleState extends State<IlanEkle> {
  String title, desc;
  //var firstClick = true;
  var formKey = GlobalKey<FormState>();
  //File _image;

/*
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("İlan Ekle"),
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

  List<Widget> children() {
    return [
      Form(
        key: formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(

                  onSaved: (kaydedilecekDeger) {
                    title = kaydedilecekDeger;
                  },
                  decoration: InputDecoration(

                    labelText: "İlan Başlığı Giriniz",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                    maxLines: 200,
                    decoration: InputDecoration(
                      labelText: "Genel Nitelikler ve İş Kriterleri",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),


                    onSaved: (kaydedilecekDeger) {
                      desc = kaydedilecekDeger;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  color: widget.baskinRenk,
                  onPressed: () {
                  //  if(firstClick){
                    //  firstClick = false;
                      ilanVer();
                   // }
                  },
                  child: Text(
                    "İlan ver",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Future<void> ilanVer() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      //debugPrint("titile $title des $desc companyID ${Giris.kullanici_id.toString()} token ${Giris.token}");
      var response = await http.post(
        "https://yusufyilmaz.org/api/adverts",
        body: jsonEncode(<String, Object>{
          "Title": title,
          "Description": desc,
          "CompanyId" : Giris.kullanici_id,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization":Giris.token,
        },
      );

      debugPrint("response " + response.toString());
      debugPrint("response body" + response.body.toString());
      debugPrint("response statuscode" + response.statusCode.toString());

      if (response.statusCode == 200) {
        var a = jsonDecode(response.body);
        if (!a["error"]["hasError"]) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content:
                Text("Ekleme işlemi başarılı bir şekilde gerçekleşti."),
                title: Text("İşlem Başarılı"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Tamam"),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
                    },
                  )
                ],
              );
            },
          );
          //firstClick = true;
        }
      }

    }
  }
}
