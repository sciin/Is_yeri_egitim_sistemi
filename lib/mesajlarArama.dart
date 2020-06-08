import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojeapp/strings.dart';
import 'package:http/http.dart' as http;

import 'Giris.dart';
import 'mesajlarDetay.dart';
import 'models/MesajMenu.dart';

class mesajlarArama extends StatefulWidget {
  @override
  _mesajlarAramaState createState() => _mesajlarAramaState();
}

class _mesajlarAramaState extends State<mesajlarArama> {
  var formKey = GlobalKey<FormState>();
  String arananKelime;
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Kullanıcılar"),
        centerTitle: true,
      ),
      body: body(),
    );
  }

  body() {
    return Column(
      children: <Widget>[
        Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.067,
                    margin: EdgeInsets.all(5),
                    child: TextFormField(
                      validator: (s) {
                        if (s.length == 0) {
                          return "bu alan boş geçilemez";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Kullanıcı veya firma ara",
                        icon: Icon(Icons.person),
                      ),
                      onSaved: (gelenCevap) {
                        arananKelime = gelenCevap;
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: RaisedButton(
                    padding: EdgeInsets.all(8),
                    color: Colors.green,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        setState(() {
                          isShow = true;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        isShow ? Kisiler() : Container(),
      ],
    );
  }

  Future<List<MesajMenu>> aramaYap() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      /*
      var url = "link";
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Giris.token
        },
        body: jsonEncode(
          <String, Object>{"arananKelime": arananKelime},
        ),
      );*/
      String url = "https://yusufyilmaz.org/api/users?name=$arananKelime";
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Giris.token
        },
      );
      var gelenCevap = jsonDecode(response.body);
      var responseData = gelenCevap["data"];
      List<MesajMenu> temp = new List<MesajMenu>();
      for (var u in (responseData as List).take(5)) {
        MesajMenu mm = new MesajMenu(
            name: u["name"],
            id: u["id"],
            profileImageLink: u["profileImageLink"],
            type: u["type"]);
        temp.add(mm);
      }
      return temp;
    }
  }
  Kisiler() {
    print(isShow);
    print(arananKelime);
    return FutureBuilder(
      future: aramaYap(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MesajMenu> veri = snapshot.data;
          if (veri.length == 0) {
            return bulunmadi();
          } else {
            return Expanded(
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => mesajlarDetay(
                                        veri: veri[index],
                                      )));
                            },
                            trailing: ((veri[index].type == 1)
                                ? Icon(Icons.business)
                                : Icon(Icons.person)),
                            title: Text(
                              veri[index].name,
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.3),
                                      offset: Offset(0, 5),
                                      blurRadius: 25)
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CircleAvatar(
                                      backgroundImage:
                                      veri[index].profileImageLink != null
                                          ? NetworkImage(
                                          veri[index].profileImageLink)
                                          : AssetImage(
                                          "assets/images/sirket.jpg"),
                                    ),
                                  ),
                                  false //kullanıcı online ise
                                      ? Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: veri.length,
                scrollDirection: Axis.vertical,

                physics: NeverScrollableScrollPhysics(),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  bulunmadi() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          0, MediaQuery.of(context).size.height * 0.15, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/not_found.png",
            fit: BoxFit.contain,
            width: 100,
            color: Colors.grey,
            height: 100,
          ),
          Container(
            child: Text(
              "Sonuç Bulunamadı",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            margin: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height * 0.04, 0, 0),
          )
        ],
      ),
    );
  }
}
