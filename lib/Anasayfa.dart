import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:flutterprojeapp/duyuruDetay.dart';
import 'package:flutterprojeapp/duyuruEkle.dart';
import 'package:flutterprojeapp/ilanDetay.dart';
import 'package:flutterprojeapp/ilanDuzenle.dart';
import 'package:flutterprojeapp/ilanEkle.dart';
import 'package:flutterprojeapp/mesajlarArama.dart';
import 'package:flutterprojeapp/mesajlarDetay.dart';
import 'package:flutterprojeapp/models/Duyurular.dart';
import 'package:flutterprojeapp/models/Ilan.dart';
import 'package:flutterprojeapp/models/MesajMenu.dart';
import 'package:flutterprojeapp/profilAyarlar.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:http/http.dart' as http;

import 'Profil.dart';
import 'kisiselBilgiDuzenle.dart';
import 'models/Notifications.dart';
import 'models/TeacherProfil.dart';

class Anasayfa extends StatefulWidget {
  static bool teacherNotification = false;
  bool delete = false;

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  static List<Notifications> notificationList;
  Color baskinRenk;
  PaletteGenerator paletteGenerator;
  static int menu = 1; // 0 = Profil, 1 = Anasayfa
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool haveNotificationTeacher = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //kullaniciAl();
    baskinRengiBul();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        elevation: 10,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: baskinRenk,
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft + Alignment(0, -.8),
                    child: CircleAvatar(
                      backgroundImage: (Giris.profilImageLink != null)
                          ? NetworkImage(Giris.profilImageLink)
                          : null, //Giris.profilImageLink
                      radius: 45,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight + Alignment(-0.65, -0.4),
                    child: Text(
                      "İYES",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight + Alignment(-0.45, -.0),
                    child: Text(
                      "İş Yeri Eğitim Sistemi",
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft + Alignment(0.05, .7),
                    child: Text(
                      '${Giris.name}',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft + Alignment(0.07, 1),
                    child: Text(
                      Giris.email,
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: menuItem(),
            ),
          ],
        ),
      ),
      floatingActionButton: menu == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mesajlarArama()),
                );
              },
              child: Icon(
                Icons.message,
                size: 30,
              ),
              backgroundColor: baskinRenk,
            )
          : Container(),
      backgroundColor: Colors.grey,
      body: RefreshIndicator(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                "${Giris.name}",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              actions: <Widget>[
                (menu == 0)
                    ? IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilAyarlar(
                                        baskinRenk: baskinRenk,
                                      )));
                        },
                      )
                    : Container(
                        child: (Giris.kullanici_tipi == 1 && menu == 1)
                            ? Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: GestureDetector(
                                  child: Icon(Icons.add),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IlanEkle(baskinRenk)));
                                  },
                                ),
                              )
                            : Container(),
                      ),
              ],
              centerTitle: true,
              expandedHeight: 150,
              elevation: 4,
              pinned: true,
              backgroundColor: baskinRenk != null ? baskinRenk : Colors.white,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "assets/images/headerimage.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(children())),
          ],
        ),
        onRefresh: () => Future.value(true),
      ),
    );
  }

  List<Widget> children() {
    if (menu == 0) {
      return [
        Profil(Giris.kullanici_tipi, baskinRenk),
      ];
    } else if (menu == 1) {
      return [isYeri()];
    } else if (menu == 2) {
      return mesajlar();
    } else if (menu == 3) {
      return basvuruYap();
    } else if (menu == 4) {
      if (Giris.kullanici_tipi == 0) {
        return [duyurular()];
      } else if (Giris.kullanici_tipi == 1) {
        return [ilanlarim()];
      } else {
        return [duyurular()];
      }
    }
  }

  Widget ilanlarim() {
    List<Map<String, Object>> tumIsYerleri = new List<Map<String, Object>>();
    return FutureBuilder(
        future: ilanlarimiGetir(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            tumIsYerleri = sonuc.data;
            if (tumIsYerleri.length == 0) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                color: Colors.red,
                child: Text(
                  "Henüz yayınlanmış ilanınız bulunmamaktadır.Anasayfadaki artı (+) ikonuna basarak ekliyebilirsiniz.",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ilanDuzenle(baskinRenk, tumIsYerleri[index])));
                  },
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.5),
                          /*gradient: LinearGradient(
                            colors: [Colors.white, baskinRenk],
                          ),*/
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(0),
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
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      tumIsYerleri[index]["title"],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      tumIsYerleri[index]["companyName"]
                                          .toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                        "Yayınlanma Tarihi: ${TarihHesapla(tumIsYerleri[index]["createdDate"].toString())}"),
                                  ),
                                  (TarihHesapla(tumIsYerleri[index]
                                                  ["createdDate"]
                                              .toString()) !=
                                          TarihHesapla(tumIsYerleri[index]
                                                  ["modifiedDate"]
                                              .toString()))
                                      ? Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Text(
                                              "Güncellenme Tarihi : ${TarihHesapla(tumIsYerleri[index]["modifiedDate"].toString())}"),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 100,
                                height: 70,
                                child: Image.asset(
                                  "assets/images/sirket.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: tumIsYerleri.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            );
          } else
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: MediaQuery.of(context).size.height * 0.1),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
        });
  }

  Widget isYeri() {
    List<Ilan> tumIsYerleri;
    return FutureBuilder(
        future: ilanlariGetir(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            tumIsYerleri = sonuc.data;
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                String created = tumIsYerleri[index].createdDate;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IlanDetay(
                                baskinRenk, tumIsYerleri[index], created)));
                  },
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 0.5),
                          /*gradient: LinearGradient(
                            colors: [Colors.white, baskinRenk],
                          ),*/
                        ),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(0),
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
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      tumIsYerleri[index].title,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      tumIsYerleri[index]
                                          .company
                                          .name
                                          .toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                        "Yayınlanma: ${TarihHesapla(tumIsYerleri[index].createdDate.toString())}"),
                                  ),
                                  (TarihHesapla(tumIsYerleri[index]
                                              .createdDate
                                              .toString()) !=
                                          TarihHesapla(tumIsYerleri[index]
                                              .modifiedDate
                                              .toString()))
                                      ? Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 12.0),
                                          child: Text(
                                              "Güncellenme Tarihi : ${TarihHesapla(tumIsYerleri[index].modifiedDate.toString())}"),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 100,
                                height: 70,
                                child: (tumIsYerleri[index]
                                            .company
                                            .profileImageLink ==
                                        null)
                                    ? Image.asset(
                                        "assets/images/sirket.jpg",
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(tumIsYerleri[index]
                                        .company
                                        .profileImageLink),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: tumIsYerleri.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
            );
          } else
            return Container(
              margin: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: MediaQuery.of(context).size.height * 0.1),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
        });
  }

  Widget duyurular() {
    return duyurulariListele();
  }

  void baskinRengiBul() {
    Future<PaletteGenerator> future = PaletteGenerator.fromImageProvider(
        AssetImage("assets/images/headerimage.jpg"));
    future.then((value) {
      paletteGenerator = value;
      setState(() {
        baskinRenk = paletteGenerator.dominantColor.color;
      });
    });
  }

  String url = "https://yusufyilmaz.org/api";

  Future<List<Ilan>> ilanlariGetir() async {
    var response = await http.get('$url/adverts');
    var data = json.decode(response.body);
    List responseData = data['data'];
    List<Ilan> ilanlar = [];
    for (var u in responseData) {
      City c = City(
        name: u["company"]["city"]["name"],
        id: u["company"]["city"]["id"],
        createdDate: u["company"]["city"]["createdDate"],
        modifiedDate: u["company"]["city"]["modifiedDate"],
      );
      Company com = Company(
        id: u["company"]["id"],
        name: u["company"]["name"],
        aboutMe: u["company"]["aboutMe"],
        address: u["company"]["address"],
        email: u["company"]["email"],
        phoneNumber: u["company"]["phoneNumber"],
        profileImageLink: u["company"]["profileImageLink"],
        workerCount: u["company"]["workerCount"],
        city: c,
      );
      Ilan ilan = Ilan(
        id: u['id'],
        title: u['title'],
        createdDate: u['createdDate'],
        modifiedDate: u['modifiedDate'],
        description: u['description'],
        company: com,
      );
      ilanlar.add(ilan);
    }
    return ilanlar;
  }

  Future<List<Map<String, Object>>> ilanlarimiGetir() async {
    var response = await http.get('$url/companies/${Giris.kullanici_id}');
    var data = json.decode(response.body);
    var responseData = data['data'];
    String companyName = responseData["name"];
    var aa = responseData["adverts"];
    int uzunluk = 0;
    for (Object u in aa) {
      uzunluk++;
    }
    List<Map<String, Object>> ilanlarim = new List<Map<String, Object>>();
    for (int i = 0; i < uzunluk; i++) {
      Map<String, Object> temp = {
        "companyName": companyName,
        "title": responseData["adverts"][i]["title"],
        "createdDate": responseData["adverts"][i]["createdDate"],
        "description": responseData["adverts"][i]["description"],
        "modifiedDate": responseData["adverts"][i]["modifiedDate"],
        "id": responseData["adverts"][i]["id"]
      };
      ilanlarim.add(temp);
    }
    return ilanlarim;
  }

  Future<List<Notifications>> getNotification() async {
    List<Notifications> notificationList = [];
    var response = await http.get('$url/notifications');
    //  var response = await http.get('$url/teachers/${Giris.kullanici_id}/notifications');
    var data = json.decode(response.body);
    List responseData = data['data'];
    for (var u in responseData) {
      Notifications notification = Notifications(
        title: u['title'],
        description: u['description'],
        id: u['id'],
        teacher: u['teacher'],
        teacherId: u['teacherId'],
        createdDate: u['createdDate'],
        modifiedDate: u['modifiedDate'],
      );
      notificationList.add(notification);
    }
    return notificationList;
  }

  Future<http.Response> deleteNotification(int id) {
    var response = http.delete(
      '$url/notifications/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': Giris.token
      },
    );
    return response;
  }

  duyurulariListele() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Text(
                "Duyurular",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Giris.kullanici_tipi == 2
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DuyuruEkle(
                                    baskinRenk, Giris.kullanici_id)));
                      },
                      child: Icon(
                        Icons.add,
                        color: baskinRenk,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: getNotification(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  notificationList = snapshot.data;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DuyuruDetay(
                                  notificationList[index],
                                  Giris.kullanici_tipi,
                                  Giris.kullanici_id,
                                  Giris.token),
                            ),
                          );
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  notificationList[index].title,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              (Giris.kullanici_tipi == 2 &&
                                      Giris.kullanici_id ==
                                          notificationList[index].teacherId)
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text(
                                                      "Silmek istediğinize emin misiniz ?"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        deleteNotification(
                                                            notificationList[
                                                                    index]
                                                                .id);
                                                        setState(() {
                                                          notificationList
                                                              .removeAt(index);
                                                        });
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Anasayfa()));
                                                      },
                                                      child: Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ],
                                                )).then((onValue) {
                                          if (widget.delete) {
                                            setState(() {
                                              widget.delete = false;
                                            });
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: notificationList.length,
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                  );
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              })
        ],
      ),
    );
  }

  Future<List<Map<String, Object>>> basvurulanFirmalar() async {
    var url =
        "https://yusufyilmaz.org/api/students/${Giris.kullanici_id}/adverts/";
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token
      },
    );
    var cevap = jsonDecode(response.body);
    var responseData = cevap["data"];
    List<Map<String, Object>> temp = new List<Map<String, Object>>();
    for (var u in responseData) {
      Map<String, Object> tempp = {"title": u["title"], "id": u["id"]};
      temp.add(tempp);
    }
    return temp;
  }

  Future<Ilan> basvurulariGetir(i) async {
    var response = await http.get('$url/adverts/$i');
    var data = json.decode(response.body);
    var gelenVeri = data['data'];
    City c = City(
      name: gelenVeri["company"]["city"]["name"],
      id: gelenVeri["company"]["city"]["id"],
      createdDate: gelenVeri["company"]["city"]["createdDate"],
      modifiedDate: gelenVeri["company"]["city"]["modifiedDate"],
    );
    Company com = Company(
      id: gelenVeri["company"]["id"],
      name: gelenVeri["company"]["name"],
      aboutMe: gelenVeri["company"]["aboutMe"],
      address: gelenVeri["company"]["address"],
      email: gelenVeri["company"]["email"],
      phoneNumber: gelenVeri["company"]["phoneNumber"],
      profileImageLink: gelenVeri["company"]["profileImageLink"],
      workerCount: gelenVeri["company"]["workerCount"],
      city: c,
    );
    Ilan ilan = Ilan(
      id: gelenVeri['id'],
      title: gelenVeri['title'],
      createdDate: gelenVeri['createdDate'],
      modifiedDate: gelenVeri['modifiedDate'],
      description: gelenVeri['description'],
      company: com,
    );
    return ilan;
  }

  List<Widget> basvuruYap() {
    return [
      Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
            0, 0, 0, MediaQuery.of(context).size.height * 0.8),
        child: FutureBuilder(
          future: basvurulanFirmalar(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, Object>> veri = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                Ilan temp = new Ilan();
                                await basvurulariGetir(veri[index]["id"])
                                    .then((Ilan ilan) {
                                  print(ilan.createdDate);
                                  temp = ilan;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        IlanDetay(baskinRenk, temp),
                                  ),
                                );
                              },
                              child: Text(
                                "${veri[index]["title"]}",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              color: Colors.green,
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: veri.length,
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ];
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

  menuItem() {
    if (Giris.kullanici_tipi == 0) {
      // p a m b d r ç
      return ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 0;
              });
              //Navigator.pushNamed(context, "/profil");
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: baskinRenk,
              ),
              title: Text("Profilim"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 1;
              });
              //Navigator.pushNamed(context, "/anasayfa");
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.home, color: baskinRenk),
              title: Text("Anasayfa"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 2;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.message, color: baskinRenk),
              title: Text("Mesajlar"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 3;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.add, color: baskinRenk),
              title: Text("Başvurular"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 4;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.announcement, color: baskinRenk),
              title: Text("Duyurular"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
              setState(() {
                menu = 1;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.close, color: baskinRenk),
              title: Text("Çıkış"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
        ],
      );
    } else if (Giris.kullanici_tipi == 1) {
      // profilim, anasayfa, mesajlar, basvuran öğrenciler , ç
      return ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 0;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: baskinRenk,
              ),
              title: Text("Profilim"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 1;
              });
              //Navigator.pushNamed(context, "/anasayfa");
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.home, color: baskinRenk),
              title: Text("Anasayfa"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 2;
              });
              //Navigator.pushNamed(context, "/anasayfa");
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.message, color: baskinRenk),
              title: Text("Mesajlar"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 4;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.notifications_active, color: baskinRenk),
              title: Text("İlanlarım"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
              setState(() {
                menu = 1;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.close, color: baskinRenk),
              title: Text("Çıkış"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
        ],
      );
    } else if (Giris.kullanici_tipi == 2) {
      // profilim,mesajlar,öğrenciler,iş yeri alan öğrenciler ,ç
      return ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 0;
              });
              //Navigator.pushNamed(context, "/profil");
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(
                Icons.account_circle,
                color: baskinRenk,
              ),
              title: Text("Profilim"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 1;
              });
              //Navigator.pushNamed(context, "/anasayfa");
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.home, color: baskinRenk),
              title: Text("Anasayfa"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 2;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.message, color: baskinRenk),
              title: Text("Mesajlar"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                scaffoldKey.currentState.openEndDrawer();
                menu = 4;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.announcement, color: baskinRenk),
              title: Text("Duyurular"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
              setState(() {
                menu = 1;
              });
            },
            splashColor: baskinRenk,
            child: ListTile(
              leading: Icon(Icons.close, color: baskinRenk),
              title: Text("Çıkış"),
              trailing: Icon(Icons.arrow_forward, color: baskinRenk),
            ),
          ),
        ],
      );
    }
  }

  Future<List<MesajMenu>> gecmisMesajlar() async {
    var response = await http.get(
      "https://yusufyilmaz.org/api/users/${Giris.kullanici_tipi}/${Giris.kullanici_id}/chats/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': Giris.token
      },
    );
    var gelenCevap = jsonDecode(response.body);
    var responseData = gelenCevap["data"];
    List<MesajMenu> temp = new List<MesajMenu>();
    for (var u in responseData) {
      MesajMenu mm = new MesajMenu(
          name: u["name"],
          id: u["id"],
          profileImageLink: u["profileImageLink"],
          type: u["type"]);
      temp.add(mm);
    }
    return temp;
  }

  List<Widget> mesajlar() {
    return [
      FutureBuilder(
        future: gecmisMesajlar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MesajMenu> veri = snapshot.data;
            return ListView.builder(
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
                                    builder: (context) => mesajlarDetay(veri: veri[index],)));
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ];
  }
}

class Sirket {
  String student;
  String itemName;
  String itemPrice;

  Sirket({
    this.student,
    this.itemName,
    this.itemPrice,
  });
}

var sirketler = <Sirket>[
  Sirket(
    student: 'Ali',
    itemName: 'Google',
    itemPrice: 'Adana',
  ),
  Sirket(
    student: 'Veli',
    itemName: 'Elma',
    itemPrice: 'Ankara',
  ),
];
