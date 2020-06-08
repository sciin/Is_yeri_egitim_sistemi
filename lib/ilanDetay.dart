import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Anasayfa.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:flutterprojeapp/models/Ilan.dart';
import 'package:http/http.dart' as http;

class IlanDetay extends StatefulWidget {
  Color baskinRenk;
  Ilan isyeri;
  String createdDate;
  String buttonText = "Başvur";

  @override
  _IlanDetayState createState() => _IlanDetayState();

  IlanDetay([this.baskinRenk, this.isyeri, this.createdDate]);
}

class _IlanDetayState extends State<IlanDetay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.createdDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("İlan Detayları"),
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

  TarihHesapla(s) {
    var tarih = DateTime.parse(s);
    String temp = tarih.day.toString() +
        "." +
        tarih.month.toString() +
        "." +
        tarih.year.toString();
    return temp;
  }

  List<Widget> children() {
    return [
      Wrap(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.baskinRenk, width: 0.5),
            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0),
            padding: EdgeInsets.all(20),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          widget.isyeri.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "${widget.isyeri.company.name}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "${widget.isyeri.company.city.name}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          "Yayınlanma: ${TarihHesapla(widget.isyeri.createdDate)}",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      (TarihHesapla(widget.isyeri.createdDate.toString()) !=
                              TarihHesapla(
                                  widget.isyeri.modifiedDate.toString()))
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                "Güncellenme Tarihi : ${TarihHesapla(widget.isyeri.modifiedDate.toString())}",
                                style: TextStyle(fontSize: 17),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 100,
                    height: 100,
                    child: widget.isyeri.company.profileImageLink != null
                        ? Image.network(
                            "${widget.isyeri.company.profileImageLink}",

                          )
                        : Image.asset("assets/images/sirket.jpg", fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: widget.baskinRenk, width: 0.5),
        ),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(),
            Text(
              "GENEL NİTELİKLER VE İŞ TANIMI",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 10,
              indent: 10,
              color: Colors.black,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("${widget.isyeri.description}"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.mail,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "${widget.isyeri.company.email}",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.call,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "${widget.isyeri.company.phoneNumber}",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_city,
                    size: 24,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${widget.isyeri.company.address}",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (Giris.kullanici_tipi == 0)
                ? Container(
                    margin: EdgeInsets.only(top: 12),
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder(
                      future: basvurulduMu(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, Object> s = snapshot.data;
                          return RaisedButton(
                            child: Text(
                              s["title"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16) ,
                            ),
                            onPressed: () {
                              if(s["islem"]){
                                basvuruYap();
                              }
                            },
                            color: (s['islem'] == true) ? widget.baskinRenk : Colors.grey,
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    ];
  }

  void goster(i, s) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text((i == 0) ? "Hata" : "Başarılı"),
          content: new Text("$s"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Evet"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Anasayfa()));
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> basvuruYap() async {
    var url =
        "https://yusufyilmaz.org/api/students/${Giris.kullanici_id}/adverts";
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token
      },
      body: jsonEncode(
        <String, Object>{
          'studentId': Giris.kullanici_id,
          'advertId': widget.isyeri.id,
        },
      ),
    );
    var cevap = jsonDecode(response.body);
    (cevap["error"]["hasError"])
        ? goster(0, cevap["error"]["errorMessage"])
        : goster(1, cevap["resultMessage"]);
  }

  Future<Map<String, Object>> basvurulduMu() async {
    var url =
        "https://yusufyilmaz.org/api/students/${Giris.kullanici_id}/adverts/${widget.isyeri.id}/any";
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token
      },
    );
    var cevap = jsonDecode(response.body);
    if (cevap["error"]["hasError"]) {
      goster(0, cevap["error"]["errorMessage"]);
      return {"title": "Başvur", "islem": true};
    } else {
      if (cevap["data"]) {
        return {"title": "Başvuruldu", "islem": false};
      } else {
        return {"title": "Başvur", "islem": true};
      }
    }
  }
}
