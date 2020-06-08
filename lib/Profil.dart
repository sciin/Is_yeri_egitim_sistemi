import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Anasayfa.dart';
import 'package:flutterprojeapp/models/CompanyProfil.dart';
import 'package:flutterprojeapp/models/Students.dart';
import 'package:flutterprojeapp/models/StudentsProfil.dart';
import 'package:flutterprojeapp/models/TeacherProfil.dart';
import 'package:flutterprojeapp/profilAyarlar.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'Giris.dart';
import 'ilanDetay.dart';
import 'kisiselBilgiDuzenle.dart';
import 'models/Ilan.dart';
import 'models/Teachers.dart';

class Profil extends StatefulWidget {
  int comingType;
  int listedekiElemanSayisi = 5;
  Color baskinRenk;

  // alert dialogdan evete basılırsa true olur.
  bool delete = false;

  //

  Profil([int comingType, Color baskinRenk]) {
    this.comingType = comingType;
    this.baskinRenk = baskinRenk;
  }

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  Color baskinRenk;
  String url = "https://yusufyilmaz.org/api";
  String teacherName;
  var teacherId;

  Future<TeacherProfil> getTeachers() async {
    var response = await http.post(
      '$url/teachers/me',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token,
        "Accept": "application/json",
      },
    );
    var data = json.decode(response.body);
    TeacherProfil temp = TeacherProfil.fromJsonMap(data["data"]);
    //print(temp.firstName);
    return temp;
  }

  Future<CompanyProfil> getCompany() async {
    var response = await http.post(
      '$url/companies/me',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token,
        "Accept": "application/json",
      },
    );
    var data = json.decode(response.body);
    CompanyProfil temp = CompanyProfil.fromJson(data["data"]);
    return temp;
  }

  Future<StudentsProfil> getStudents() async {
    var response = await http.post(
      '$url/students/me',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token,
        "Accept": "application/json",
      },
    );
    var data = json.decode(response.body);
    StudentsProfil temp = StudentsProfil.fromJson(data["data"]);
   // print(temp.cvLink);
    teacherId = temp.teacherId;

    var getTeacherResponse = await http.get('$url/teachers');
    var getTeacherData = json.decode(getTeacherResponse.body);

    List responseData = getTeacherData['data'];
    List<Teachers> teacherList = [];

    teacherList =
        (responseData as List).map((i) => Teachers.fromJson(i)).toList();
    //print(teacherList.length)
    for (int i = 0; i < teacherList.length; i++) {
      if (teacherId == responseData[i]["id"])
        setState(() {
          teacherName =
              responseData[i]["firstName"] + " " + responseData[i]["lastName"];
        });
    }
    return temp;
  }

  Future<Teachers> getTeachersName() async {
    var response = await http.get('$url/teachers');
    /*ysusuadasd/students/Giris.kullanici_id
    ysusuadasd/teachers/teacherID*/

    var data = jsonDecode(response.body);

    List responseData = data['data'];
    List<Teachers> teacherList = [];
    List<String> teacherNameList = [];

    teacherList =
        (responseData as List).map((i) => Teachers.fromJson(i)).toList();
    //print(teacherList.length)
    for (int i = 0; i < teacherList.length; i++) {
      teacherNameList.add(responseData[i]["firstName"]);
      if (teacherId == responseData[i]["id"])
        setState(() {
          teacherName =
              responseData[i]["firstName"] + " " + responseData[i]["lastName"];
        });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getTeachers();
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


  @override
  Widget build(BuildContext context) {
    if (widget.comingType == 0) {
      // Öğrenci Profili
      return Wrap(
        children: <Widget>[
          Container(
            width: 400,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: FutureBuilder(
                future: getStudents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    StudentsProfil veri = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(),
                            Text(
                              "Kişisel Bilgiler",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
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
                          child: (veri.aboutMe != null) ? Text('${veri.aboutMe}') : Text(""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.firstName + " " + veri.lastName}",
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
                                Icons.mail,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.email}",
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.phoneNumber}",
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
                                Icons.person,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "$teacherName",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Row(
                            children: <Widget>[

                              Icon(
                                Icons.description,
                                size: 24,
                              ),

                            
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                                  child: InkWell(
                                    child: Text("Cv görüntüle" ,style: TextStyle(color: Colors.blue,fontSize: 17,decoration: TextDecoration.underline),),
                                    onTap: () {
                                      launch("${veri.cvLink}");
                                    },
                                  ),
                                ),

                            ],
                          ),
                        ),

                      ],
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }),
          ),
          Container(
            width: 400,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: FutureBuilder(
              future: basvurulanFirmalar(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Map<String, Object>> veri = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Başvurular",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
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
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 0),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20.0),
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
                                            IlanDetay(widget.baskinRenk, temp),
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
        ],
      );
    } else if (widget.comingType == 1) {
      //İş Yeri Profili
      return Wrap(
        children: <Widget>[
          Container(
            width: 400,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: FutureBuilder(
                future: getCompany(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    CompanyProfil veri = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Kişisel Bilgiler",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
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
                          child: (veri.aboutMe != null) ? Text("${veri.aboutMe}") : Text(""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.name}",
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
                                Icons.mail,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.email}",
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.phoneNumber}",
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
                                Icons.person,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.workerCount}",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else
                    return Center(child: CircularProgressIndicator());
                }),
          ),
          Container(
            width: 400,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "İlanlarım",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                FutureBuilder(
                  future: ilanlarimiCek(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Map<String,Object>> veri = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
                                    Ilan temp = new Ilan();
                                    await basvurulariGetir(veri[index]["id"])
                                        .then((Ilan ilan) {
                                      //print(ilan.company.city.id);
                                      temp = ilan;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            IlanDetay(widget.baskinRenk, temp),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "${veri[index]["title"]}",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: veri.length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                      );

                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      );
    } else if (widget.comingType == 2) {
      //Danışman Profili
      return Wrap(
        children: <Widget>[
          Container(
            width: 400,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: FutureBuilder(
                future: getTeachers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    TeacherProfil veri = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Kişisel Bilgiler",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
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
                          child: (veri.aboutMe != null) ? Text("${veri.aboutMe}") : Text(""),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.account_circle,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.firstName}",
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
                                Icons.mail,
                                size: 24,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.email}",
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${veri.phoneNumber}",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sorumlu Öğrencileri",
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
                sorumluOgrenciler(),
              ],
            ),
          ),
        ],
      );
    }
  }

  Future<List<Students>> getAllStudents() async {
    // var response = await http.get('$url/students');
    var response = await http.post(
      '$url/teachers/${Giris.kullanici_id}/students',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token
      },
    );
    var data = json.decode(response.body);
    List responseData = data['data'];
    List<Students> studentsList = [];
    for (var u in responseData) {
      Students students = Students(
        firstName: u['firstName'],
        lastName: u['lastName'],
        createdDate: u['createdDate'],
        modifiedDate: u['modifiedDate'],
        id: u['id'],
      );
      studentsList.add(students);
    }
    return studentsList;
  }

  Future<List<Map<String, Object>>> getAllAdverts() async {
    // var response = await http.get('$url/students');
    var response = await http.get(
      '$url/students/${Giris.kullanici_id}/adverts',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token
      },
    );
    var data = json.decode(response.body);
    var responseData = data['data'];

    int uzunluk = 0;
    for (Object u in responseData) {
      uzunluk++;
    }
    //print(responseData);
    List<Map<String, Object>> ilanlarim = new List<Map<String, Object>>();
    for (int i = 0; i < uzunluk; i++) {
      Map<String, Object> temp = {
        'title': responseData[i]['title'],
        'description': responseData[i]['description'],
        'createdDate': responseData[i]['createdDate'],
        'modifiedDate': responseData[i]['modifiedDate'],
      };
      ilanlarim.add(temp);
    }
    return ilanlarim;

    /* List<Ilan> ilanList= [];
    for (var u in responseData) {
      Company company = Company(

        name: u['company']['name'],

      );
      Ilan ilan = Ilan(
        title : u['title'],
        description: u['description'],
        createdDate: u['createdDate'],
        modifiedDate: u['modifiedDate'],
        id: u['id'],
      );
      ilanList.add(ilan);
      print(company.name);
    }*/

    if (data['error']['errorMessage']) {
      print(data['error']['errorMessage']);
    }

    return null;
  }

  Widget sorumluOgrenciler() {
    return FutureBuilder(
        future: getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Students> veri = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${veri[index].firstName + " " + veri[index].lastName}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        width: 130, //DEĞİİECEK
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                          color: Colors.deepOrange,
                          child: Center(
                            child: (veri[index].createdDate != null)
                                ? TarihHesapla(veri[index].createdDate)
                                : null,
                          ),
                        ),
                      ),
                     /* GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Silmek istediğinize emin misiniz ?"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    widget.delete = true;
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ).then((onValue) {
                            if (widget.delete) {
                              setState(() {
                                widget.listedekiElemanSayisi--;
                                widget.delete = false;
                              });
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 2),
                          width: 20,
                          height: 22,
                          color: Colors.red.shade800,
                          child: Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                );
              },
              itemCount: veri.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }

  TarihHesapla(comingDate) {
    var tarih = DateTime.parse(comingDate);
    String temp = "" +
        tarih.day.toString() +
        "." +
        tarih.month.toString() +
        "." +
        tarih.year.toString() +
        " " +
        tarih.hour.toString() +
        ":" +
        tarih.minute.toString();

    return Text(
      "$temp",
      style: TextStyle(color: Colors.white),
    );
  }

  ilanlarimiCek() async {
    var url =
        "https://yusufyilmaz.org/api/companies/${Giris.kullanici_id}";
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token
      },
    );
    var cevap = jsonDecode(response.body);
    var responseData = cevap["data"];
    var adverst = cevap["data"]["adverts"];
    List<Map<String, Object>> temp = new List<Map<String, Object>>();
    for (var u in adverst) {
      Map<String, Object> tempp = {"title": u["title"], "id": u["id"]};
      temp.add(tempp);
    }
    return temp;
  }
}
