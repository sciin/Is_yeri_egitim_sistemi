import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:flutterprojeapp/models/Students.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class basvuranOgrenciler extends StatefulWidget {
  int ilanID;
  Color baskinRenk;

  basvuranOgrenciler({this.ilanID,this.baskinRenk});

  @override
  _basvuranOgrencilerState createState() => _basvuranOgrencilerState();
}

class _basvuranOgrencilerState extends State<basvuranOgrenciler> {
  List<bool> acikMi = List<bool>();
  bool kontrol = true;
  int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ogrencileriGoster().then((gelenDeger) {
      for (int i = 0; i < gelenDeger.length; i++) {
        acikMi.add(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Basvuran Öğrenciler",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: widget.baskinRenk,
      ),
      body: govde(),
    );
  }

  govde() {
    return FutureBuilder(
      future: ogrencileriGoster(),
      builder: (context, snapShot) {

        List<Widget> items = [];
        sayac = 0;
        if (snapShot.hasData) {
          List<Students> veri = snapShot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              Widget temp = Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(5),
                child: ListTile(
                  title: Text(
                    "${veri[index].firstName}",
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: (veri[index].profileImageLink == null)
                      ? Icon(
                          Icons.person,
                          size: 45,
                        )
                      : Image.network("${veri[index].profileImageLink}",fit: BoxFit.fill,width: 50,height: 50,),
                  subtitle: Text(
                    "${veri[index].email}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
              items.add(temp);
              return ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    kontrol = false;
                    acikMi[index] = !isExpanded;
                  });
                },
                children: (index == (veri.length - 1))
                    ? items.map((item) {
                        return ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return item;
                          },
                          isExpanded: (kontrol) ? false : acikMi[sayac],

                          body: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  (veri[sayac].aboutMe == null)
                                      ? Container(height: 0,)
                                      : Text("${veri[sayac].aboutMe}",style: TextStyle(fontSize: 15,color: Colors.black,),),
                                  SizedBox(height: 10,),
                                  (veri[sayac].phoneNumber == null)
                                      ? Container()
                                      : Text("Email: ${veri[sayac].email}",style: TextStyle(fontSize: 15,color: Colors.black),),
                                  SizedBox(height: 5,),
                                  (veri[sayac].aboutMe == null)
                                      ? Container()
                                      :Text("Telefon: ${veri[sayac].phoneNumber}",style: TextStyle(fontSize: 15,color: Colors.black),),

                                  SizedBox(height: 10,),
                                  (veri[sayac].cvLink == null) ? sayacArttir() : getWidget(veri),
                                  SizedBox(height: 20,),

                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : [],
              );
            },
            itemCount: veri.length,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Students>> ogrencileriGoster() async {
    String url =
        "https://yusufyilmaz.org/api/adverts/${widget.ilanID}/students";
    List<Students> ogrenciler = new List<Students>();
    var response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": Giris.token,
      "Accept": "application/json",
    });
    var gelenCevap = jsonDecode(response.body);
    var responseData = gelenCevap["data"];
    if (!gelenCevap["error"]["hasError"]) {
      ogrenciler =
          (responseData as List).map((i) => Students.fromJson(i)).toList();
      return ogrenciler;
    } else {
      return null;
    }
  }

  void bilgileriGoster(Students ogr) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(ogr.firstName + " " + ogr.lastName),
          content: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Email :"),
                  Expanded(child: Text(ogr.email)),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Telefon :"),
                  Text((ogr.phoneNumber == null)
                      ? "bulunamadı"
                      : ogr.phoneNumber),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("CV :"),
                  Text((ogr.cvLink == null) ? "bulunamadı" : ogr.cvLink),
                ],
              ),
              Row(
                children: <Widget>[
                  Text("Hakkımda :"),
                  Expanded(
                      child: Text(
                          (ogr.aboutMe == null) ? "bulunamadı" : ogr.aboutMe)),
                ],
              ),
            ],
          ),
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

  getCv(veri) {
    String s = veri[sayac].cvLink;
    sayac++;
    return s;
  }
  sayacArttir() {
    sayac++;
    return Container();
  }

  getWidget(List<Students> veri) {
    String link = getCv(veri);
    return InkWell(
      child: Text("Cv görüntüle" ,style: TextStyle(color: Colors.blue,fontSize: 16,decoration: TextDecoration.underline),),
      onTap: () {
        launch(link);
      },
    );
  }
}

/*
*
* Card(
                color: Colors.redAccent[100],
                margin: EdgeInsets.fromLTRB(10, 8, 10, 0),
                child: ListTile(
                  onTap: () {
                    bilgileriGoster(veri[index]);
                  },
                  title: Text(
                    "${veri[index].firstName}",
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: (veri[index].profileImageLink == null)
                      ? Icon(
                          Icons.person,
                          size: 45,
                        )
                      : Image.network("${veri[index].profileImageLink}"),
                  trailing: Icon(Icons.arrow_forward),
                  subtitle: Text(
                    "${veri[index].email}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
* */
