import 'dart:convert';
import 'dart:math';

//import 'dart:ui';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterprojeapp/functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:checkbox_list_tile_more_customizable/checkbox_list_tile_more_customizable.dart';
import 'package:flutterprojeapp/Anasayfa.dart';
import 'package:flutterprojeapp/KayitOl.dart';
import 'functions.dart';

import 'Profil.dart';

class Giris extends StatefulWidget {
  static String token, name, email, profilImageLink;
  static int kullanici_id, kullanici_tipi;

  /*static String verifyEmail(String girilenDeger)
  {
    return girilenDeger.isEmpty? "Kullanıcı adı boş bırakılamaz" : null;
  }
  static String verifyPassword(String girilenDeger)
  {
    return girilenDeger.isEmpty? "Şifre alanı boş bırakılamaz" : null;
  }*/

  @override
  _GirisState createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Giriş Ekranı"),
      ),
      body: Govde(),
    );
  }
}

class Govde extends StatefulWidget {
  @override
  _GovdeState createState() => _GovdeState();
}

class _GovdeState extends State<Govde> {
  bool beniHatirla = false;
  String kadi,sifre;
  var formKey = GlobalKey<FormState>();
  String dropdownValue;

  Functions functions = new Functions();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: <Widget>[
          Form(
            key: formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Text("Oturum Başlatmak İçin Giriş Yapın",
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Giriş türünü seç",
                          style: TextStyle(fontSize: 14),
                        ),
                        DropdownButton(
                          hint: Text("Giriş Türü Seçiniz"),
                          value: dropdownValue,
                          onChanged: (secilenItem) {
                            setState(() {
                              dropdownValue = secilenItem;
                            });
                          },
                          items: <String>["Öğrenci", "İşyeri", "Danışman"]
                              .map((items) {
                            return DropdownMenuItem(
                              child: Text(items),
                              value: items,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.redAccent,
                    ),
                    child: TextFormField(
                      initialValue: kadi,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        labelText: "Mail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: functions.verifyEmail,
                      onSaved: (kaydedilecekDeger) {
                        kadi = kaydedilecekDeger;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.redAccent,
                    ),
                    child: TextFormField(
                      initialValue: sifre,
                      obscureText: true,
                      validator: functions.verifyPassword,
                      onSaved: (kaydedilecekDeger) {
                        sifre = kaydedilecekDeger;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Şifre",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:5),
                        child: GestureDetector(
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(fontSize: 15, color: Colors.blue),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KayitOl()));
                          },
                        ),
                      ),
                      ArgonButton(
                        height: 40,
                        roundLoadingShape: true,
                        width: MediaQuery.of(context).size.width * 0.30,
                        onTap: (startLoading, stopLoading, btnState) {
                          if (btnState == ButtonState.Idle) {
                            startLoading();
                            _GirisKontrol();
                          } else {
                            stopLoading();
                          }
                        },
                        child: Text(
                          "Giriş",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                        loader: Container(
                          padding: EdgeInsets.all(10),
                          child: SpinKitRotatingCircle(
                            color: Colors.white,
                            // size: loaderWidth ,
                          ),
                        ),
                        borderRadius: 5.0,
                        color: Colors.deepOrange,
                      ),
                      /*RaisedButton(
                        onPressed: () {
                          _GirisKontrol();
                        },
                        child: Text(
                          "Giriş",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepOrange,
                      )*/
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _GirisKontrol() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _GirisKontrol2(kadi, sifre, dropdownValue).then((gelenCevap) {
        if (gelenCevap["hasError"]) {
          _girisHataGoster(gelenCevap["mesaj"]);
        } else {
          Giris.token = gelenCevap["token"];
          Giris.kullanici_id = gelenCevap["kullanici_id"];
          Giris.kullanici_tipi = gelenCevap["kullanici_tipi"];
          Giris.name = gelenCevap["name"];
          Giris.email = gelenCevap["email"];
          Giris.profilImageLink = gelenCevap["profilImage"];
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Anasayfa()));
        }
      });
    }
  }

  void _girisHataGoster(var s) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Giriş Hatası"),
          content: new Text("$s"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, Object>> _GirisKontrol2(
      String mail, String pass, String girisTipi) async {
    String url;
    if (girisTipi == "Öğrenci") {
      url = "https://yusufyilmaz.org/api/auth/student/login";
    } else if (girisTipi == "İşyeri") {
      url = "https://yusufyilmaz.org/api/auth/company/login";
    } else if (girisTipi == "Danışman") {
      url = "https://yusufyilmaz.org/api/auth/teacher/login";
    } else if (girisTipi == null) {
      return {"hasError": true, "mesaj": "Lütfen giriş türünü seçiniz."};
    } else {
      return {
        "hasError": true,
        "mesaj": "Şuan giriş yapılamıyor daha sonra tekrar deneyiniz"
      };
    }
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'email': mail,
          'password': pass,
        },
      ),
    );

    var a = jsonDecode(response.body);
    String hataMesaji, token2, name, email, profilImage;
    int authorizeType, id;
    bool hasEror = a["error"]["hasError"];
    if (hasEror) {
      hataMesaji = a["error"]["errorMessage"];
      Map<String, Object> sonuc = {"hasError": hasEror, "mesaj": hataMesaji};
      return sonuc;
    } else {
      token2 = a["data"]["token"];
      name = (a["data"]["authorizeType"] == 1)
          ? a["data"]["name"].toString()
          : (a["data"]["firstName"].toString() +
              " " +
              a["data"]["lastName"].toString());
      email = a["data"]["email"];
      authorizeType = a["data"]["authorizeType"];
      profilImage = a["data"]["profileImageLink"];
      id = a["data"]["id"];
      Map<String, Object> sonuc = {
        "hasError": hasEror,
        "token": token2,
        "name": name,
        "email": email,
        "kullanici_tipi": authorizeType,
        "profilImage": profilImage,
        "kullanici_id": id
      };
      return sonuc;
    }
  }
}
