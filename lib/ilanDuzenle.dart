import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'basvuranOgrenciler.dart';
import 'models/Ilan.dart';

class ilanDuzenle extends StatefulWidget {
  Color baskinRenk;
  Map<String, Object> ilan;

  ilanDuzenle(this.baskinRenk, this.ilan);

  @override
  _ilanDuzenleState createState() => _ilanDuzenleState();
}

class _ilanDuzenleState extends State<ilanDuzenle> {
  String title, desc;
  var formKey = GlobalKey<FormState>();
  var firstClick = true;

  //File _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.ilan["title"];
    desc = widget.ilan["description"];
  }

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
            title: Text("İlan Güncelle"),
            centerTitle: true,
            expandedHeight: 60,
            elevation: 4,
            actions: <Widget>[
              InkWell(
                onTap: () {
                  ilanSil();
                },
                child: Icon(Icons.delete_forever, size: 32),
              ),
            ],
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
                  initialValue: title,
                  validator: (girelenDeger) {
                    if (girelenDeger.length > 0)
                      return null;
                    else
                      return "İlan Başlığı alanı boş bırakılamaz";
                  },
                  onSaved: (kaydedilecekDeger) {
                    title = kaydedilecekDeger;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "İlan Başlığı Güncelle",
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
                    initialValue: desc,
                    maxLength: 10000,
                    minLines: 1,
                    maxLines: 200,
                    decoration: InputDecoration(
                      labelText: "Genel Nitelikler ve İş Kriterleri Güncelle",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0)
                        return null;
                      else
                        return "Duyuru içerik alanı boş bırakılamaz";
                    },
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
                    print(firstClick);
                    if (firstClick) {
                      firstClick = false;
                      ilanVer();
                    }
                  },
                  child: Text(
                    "Güncelle",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  color: widget.baskinRenk,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => basvuranOgrenciler(baskinRenk: widget.baskinRenk,ilanID: widget.ilan["id"],),
                      ),
                    );
                  },
                  child: Text(
                    "Başvuranları Görüntüle",
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
      debugPrint(Giris.token);
      var response = await http.put(
        "https://yusufyilmaz.org/api/adverts/${widget.ilan["id"]}",
        body: jsonEncode(<String, Object>{
          "Title": title,
          "Description": desc,
          "CompanyId": Giris.kullanici_id,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": Giris.token,
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        var a = jsonDecode(response.body);
        if (!a["error"]["hasError"]) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content:
                    Text("Güncelleme işlemi başarılı bir şekilde gerçekleşti."),
                title: Text("İşlem Başarılı"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Tamam"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        }
      }
      debugPrint("status code : " + response.statusCode.toString());
      firstClick = true;
      debugPrint(response.body.toString());
    }
  }

  void ilanSil() {
    var response = http.delete(
      "https://yusufyilmaz.org/api/adverts/" + widget.ilan["id"].toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token,
      },
    );
    response.then((onValue) {
      Navigator.pop(context);
    });
  }
}
