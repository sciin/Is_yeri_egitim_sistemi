import 'dart:convert';
import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterprojeapp/models/CompanyProfil.dart';
import 'package:flutterprojeapp/models/StudentsProfil.dart';
import 'package:flutterprojeapp/models/TeacherProfil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'Anasayfa.dart';
import 'Giris.dart';
import 'models/Cities.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
class ProfilAyarlar extends StatefulWidget {
  Color baskinRenk;
  BuildContext ctx;

  @override
  _ProfilAyarlarState createState() => _ProfilAyarlarState();

  ProfilAyarlar({this.baskinRenk});
}
class _ProfilAyarlarState extends State<ProfilAyarlar> {
  List<Cities> sehirler;
  File _image;
  Future<File> file;
  double workerCount;
  int secilenSehirId;
  String url = "https://yusufyilmaz.org/api";
  String email, firstName, lastName, aboutMe, phoneNumber, name, address;
  bool isUpdate = true;
  Cities secilenSehir;
  var ogrenciFormKey = GlobalKey<FormState>();
  var isyerFormKey = GlobalKey<FormState>();
  var danismanFormKey = GlobalKey<FormState>();



  File _file;
  String fileName;
  void openFile() async{
     _file = await FilePicker.getFile();
    setState(() {
      fileName = _file.path.split("/").last;
      print(fileName);
    });

  }

  Future<List<Cities>> getCities() async {
    var response = await http.get('$url/cities');
    var data = jsonDecode(response.body);
    List responseData = data['data'];
    List<Cities> temp = new List<Cities>();
    for (var u in responseData) {
      Cities c = Cities(
          name: u["name"],
          id: u["id"],
          createdDate: u["createdDate"],
          modifiedDate: u["modifiedDate"]);
      temp.add(c);
    }

    return temp;
  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCities().then((value) {
      setState(() {
        sehirler = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    widget.ctx = context;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Profil Ayarları"),
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
    if (Giris.kullanici_tipi == 0) {
      return [
        FutureBuilder(
          future: getStudentData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              StudentsProfil veri = snapshot.data;
              return Form(
                key: ogrenciFormKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      CircularProfileAvatar(
                        '',
                        child: _image == null
                            ? FittedBox(
                          child: veri.profileImageLink == null
                              ? Icon(Icons.person)
                              : Image.network(veri.profileImageLink),
                          fit: BoxFit.cover,
                        )
                            : FittedBox(
                          child: Image.file(_image),
                          fit: BoxFit.cover,
                        ),
                        radius: 60,
                        // sets radius, default 50.0
                        backgroundColor:
                        _image == null ? Colors.white : Colors.transparent,
                        cacheImage: true,
                        showInitialTextAbovePicture: true,
                        borderColor: Colors.brown,
                        onTap: () {
                          getImage();
                        },
                        borderWidth: 6,
                        elevation: 5,
                      ),
                      RaisedButton(
                        child: Text(
                          "Galeriden resim seç",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        color: widget.baskinRenk,
                        onPressed: () {
                          getImage();
                        },
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.redAccent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: veri.firstName,
                              decoration: InputDecoration(
                                labelText: "İsim",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              maxLength: 200,
                              onSaved: (kaydedilecekDeger) {
                                firstName = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.lastName,
                              decoration: InputDecoration(
                                labelText: "Soyisim",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                lastName = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.email,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                email = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 10000,
                              minLines: 1,
                              maxLines: 1000,
                              initialValue: veri.aboutMe,
                              decoration: InputDecoration(
                                labelText: "Hakkımda",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                aboutMe = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.phoneNumber,
                              decoration: InputDecoration(
                                labelText: "Telefon Numarası",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),

                              onSaved: (kaydedilecekDeger) {
                                phoneNumber = kaydedilecekDeger;
                              },
                            ) ,
                            Row(
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: (){
                                      openFile();
                                  },
                                  color: widget.baskinRenk,
                                  child: Text("Cv ekle",style: TextStyle(color: Colors.white),),
                                ),
                                SizedBox(width: 10,),
                                Text((fileName != null) ? "$fileName" : "Dosya seçiniz"),
                              ],

                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              onPressed: () {
                                if(isUpdate){
                                  ogrenciBilgileriGuncelle();
                                }
                              },
                              child: Text(
                                "KAYDET",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: widget.baskinRenk,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ];
    }
    else if (Giris.kullanici_tipi == 1) {
      return [
        FutureBuilder(
          future: companygetData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CompanyProfil veri = snapshot.data;
              return Form(
                key: isyerFormKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      CircularProfileAvatar(
                        '',
                        child: _image == null
                            ? FittedBox(
                          child: veri.profileImageLink == null
                              ? Icon(Icons.person)
                              : Image.network(veri.profileImageLink),
                          fit: BoxFit.cover,
                        )
                            : FittedBox(
                          child: Image.file(_image),
                          fit: BoxFit.cover,
                        ),
                        radius: 60,
                        // sets radius, default 50.0
                        backgroundColor:
                        _image == null ? Colors.white : Colors.transparent,
                        cacheImage: true,
                        showInitialTextAbovePicture: true,
                        borderColor: Colors.brown,
                        onTap: () {
                          getImage();
                        },
                        borderWidth: 6,
                        elevation: 5,
                      ),
                      RaisedButton(
                        child: Text(
                          "Galeriden resim seç",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        color: widget.baskinRenk,
                        onPressed: () {
                          getImage();
                        },
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.redAccent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              initialValue: veri.name,
                              decoration: InputDecoration(
                                labelText: "Firma İsmi",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              maxLength: 200,
                              onSaved: (kaydedilecekDeger) {
                                name = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.email,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                email = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 10000,
                              minLines: 1,
                              maxLines: 500,
                              initialValue: veri.aboutMe,
                              decoration: InputDecoration(
                                labelText: "Hakkımızda",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                aboutMe = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.phoneNumber.toString(),
                              decoration: InputDecoration(
                                labelText: "Telefon Numarası",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                phoneNumber = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 500,
                              minLines: 1,
                              maxLines: 10,
                              initialValue: veri.address,
                              decoration: InputDecoration(
                                labelText: "Adres",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                address = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              maxLength: 200,
                              initialValue: veri.workerCount.toString(),
                              validator: (gelenDeger) {
                                if (double.parse(gelenDeger) ==
                                    double.parse(gelenDeger).roundToDouble()) {
                                  return null;
                                } else {
                                  return "Lütfen Geçerli Bir Çalışan Sayısı Giriniz.";
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Çalışan Sayısı",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                workerCount = double.parse(kaydedilecekDeger);
                              },
                            ),
                            sehirler != null
                                ? DropdownButton<Cities>(
                                hint: Text("Şehir Seçiniz"),
                                value: secilenSehir != null ? secilenSehir : secilenSehirrrr(veri.cityId),
                                onChanged: (Cities gelenDeger) {
                                  setState(() {
                                    secilenSehirId = gelenDeger.id;
                                    secilenSehir = gelenDeger;
                                  });
                                }, //City
                                items: sehirler.map((Cities items) {
                                  return DropdownMenuItem<Cities>(
                                    child: Text(items.name),
                                    value: items,
                                  );
                                }).toList()
                            ):CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              onPressed: () {
                                if(isUpdate){
                                  isYeriBilgileriGuncelle();
                                }
                              },
                              child: Text(
                                "KAYDET",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: widget.baskinRenk,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ];
    }
    else if (Giris.kullanici_tipi == 2) {
      return [
        FutureBuilder(
          future: teachersVerileriGetir(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TeacherProfil veri = snapshot.data;
              return Form(
                key: danismanFormKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      CircularProfileAvatar(
                        '',
                        child: _image == null
                            ? FittedBox(
                          child: veri.profileImageLink == null
                              ? Icon(Icons.person)
                              : Image.network(veri.profileImageLink),
                          fit: BoxFit.cover,
                        )
                            : FittedBox(
                          child: Image.file(_image),
                          fit: BoxFit.cover,
                        ),
                        radius: 60,
                        // sets radius, default 50.0
                        backgroundColor:
                        _image == null ? Colors.white : Colors.transparent,
                        cacheImage: true,
                        showInitialTextAbovePicture: true,
                        borderColor: Colors.brown,
                        onTap: () {
                          getImage();
                        },
                        borderWidth: 6,
                        elevation: 5,
                      ),
                      RaisedButton(
                        child: Text(
                          "Galeriden resim seç",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        color: widget.baskinRenk,
                        onPressed: () {
                          getImage();
                        },
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.redAccent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: veri.firstName,
                              decoration: InputDecoration(
                                labelText: "İsim",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              maxLength: 200,
                              onSaved: (kaydedilecekDeger) {
                                firstName = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.lastName,
                              decoration: InputDecoration(
                                labelText: "Soyisim",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                lastName = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.email,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                email = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 10000,
                              minLines: 1,
                              maxLines: 1000,
                              initialValue: veri.aboutMe,
                              decoration: InputDecoration(
                                labelText: "Hakkımda",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                aboutMe = kaydedilecekDeger;
                              },
                            ),
                            TextFormField(
                              maxLength: 200,
                              initialValue: veri.phoneNumber,
                              decoration: InputDecoration(
                                labelText: "Telefon Numarası",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onSaved: (kaydedilecekDeger) {
                                phoneNumber = kaydedilecekDeger;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              onPressed: () {
                                if(isUpdate){
                                  danismanBilgileriniGuncelle();
                                 // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Anasayfa()));
                                }
                              },
                              child: Text(
                                "KAYDET",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: widget.baskinRenk,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ];
    } else {
      return [
        Container(
          child: Text("Hata"),
        )
      ];
    }
  }
  Cities secilenSehirrrr(id){
    for (Cities u in sehirler){
      if(u.id == id){
        secilenSehirId = u.id;
         return u;
      }
    }
    return null;
  }
  Future<TeacherProfil> teachersVerileriGetir() async {
    var response = await http.post(
      '$url/teachers/me',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token,
        "Accept": "application/json",
      },
    );
    var data = json.decode(response.body);
    var temp = TeacherProfil.fromJsonMap(data["data"]);
    return temp;
  }
  Future<StudentsProfil> getStudentData() async {
    var response = await http.post(
      '$url/students/me',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token,
        "Accept": "application/json",
      },
    );
    var data = json.decode(response.body);
    var temp = StudentsProfil.fromJson(data["data"]);
    return temp;
  }
  Future<CompanyProfil> companygetData() async {
    var response = await http.post(
      '$url/companies/me',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": Giris.token,
        "Accept": "application/json",
      },
    );
    var data = json.decode(response.body);
    var temp = CompanyProfil.fromJson(data["data"]);
    return temp;
  }
  Future<void> ogrenciBilgileriGuncelle() async {
    if (ogrenciFormKey.currentState.validate()) {
      isUpdate=false;
      ogrenciFormKey.currentState.save();
      //URL
      String url = "https://yusufyilmaz.org/api/students/${Giris.kullanici_id}";
      var uri = Uri.parse(url);
      //CREATE REQUEST
      var request = new http.MultipartRequest("PUT", uri);


      //IMAGE
      if(_file != null){
        var stream = new http.ByteStream(DelegatingStream.typed(_file.openRead()));
        //var stream2 = new http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await _file.length(); //imageFile is your image file
        // ignore this headers if there is no authentication
        var multipartFileSign = new http.MultipartFile(
          'cv',
          stream,
          length,
          filename: basename(_file.path),
        );
        request.files.add(multipartFileSign);
      }
      if(_image != null){
        var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
        //var stream2 = new http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await _image.length(); //imageFile is your image file
        // ignore this headers if there is no authentication
        var multipartFileSign = new http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(_image.path),
        );
        request.files.add(multipartFileSign);
      }
      (_image==null)?print("resim secilmemis"):print(_image.path);
      // HEADER
      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": Giris.token
      };
      request.headers.addAll(headers);
      //PARAMS
      request.fields['firstName'] = firstName;
      request.fields['lastName'] = lastName;
      request.fields['email'] = email;
      request.fields['aboutMe'] = aboutMe;
      request.fields['phoneNumber'] = phoneNumber;

      //SEND
      var response = await request.send();
      //LISTEN FOR RESPONSE
      var imageRequest = await http.post("https://yusufyilmaz.org/api/students/me",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Giris.token
        },
      );
        var data = json.decode(imageRequest.body);
        response.stream.transform(utf8.decoder).listen((value) {
        isUpdate=true;

        var gelenCevap = jsonDecode(value);

        if(gelenCevap["statusCode"]==200){
          Giris.name = firstName + " " + lastName;
          Giris.email = email;
          Giris.profilImageLink = data['data']['profileImageLink'];

          cevapGoster(1,gelenCevap["resultMessage"].toString());
        }
        else{
          cevapGoster(0,gelenCevap["error"]["errorMessage"].toString());
        }
      });
    }
  }
  Future<void> isYeriBilgileriGuncelle() async {
    if (isyerFormKey.currentState.validate()) {
      isyerFormKey.currentState.save();
      isUpdate=false;
      //URL
      String url = "https://yusufyilmaz.org/api/companies/${Giris.kullanici_id}";
      var uri = Uri.parse(url);
      //CREATE REQUEST
      var request = new http.MultipartRequest("PUT", uri);
      //IMAGE
      if(_image != null){
        var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
        var length = await _image.length(); //imageFile is your image file
        // ignore this headers if there is no authentication
        var multipartFileSign = new http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(_image.path),
        );
        request.files.add(multipartFileSign);
      }
      // HEADER
      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": Giris.token
      };
      //(_image!=null)?print(_image.path):print("resim yüklenmemiş");
      //debugPrint("name  $name email $email hakkımızda $aboutMe telefon $phoneNumber calısan ${workerCount.round().toString()} adres $address sehir ${secilenSehirId.toString()}");
      request.headers.addAll(headers);
      //PARAMS
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['aboutMe'] = aboutMe;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['workerCount'] = workerCount.round().toString();
      request.fields['address'] = address;
        request.fields['cityId'] = secilenSehirId.toString();

      //SEND
      var response = await request.send();
      //LISTEN FOR RESPONSE
      var imageRequest = await http.post("https://yusufyilmaz.org/api/companies/me",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Giris.token
        },
      );
      var data = json.decode(imageRequest.body);
      response.stream.transform(utf8.decoder).listen((value) {
        isUpdate=true;
        var gelenCevap = jsonDecode(value);
        if(gelenCevap["statusCode"]==200){
          Giris.name = name;
          Giris.email = email;
          Giris.profilImageLink = data['data']['profileImageLink'];
          cevapGoster(1,gelenCevap["resultMessage"].toString());
        }
        else{
          cevapGoster(0,gelenCevap["error"]["errorMessage"].toString());
        }
      });
    }
  }
  Future<void> danismanBilgileriniGuncelle() async {

    if (danismanFormKey.currentState.validate()) {
      danismanFormKey.currentState.save();
      isUpdate=false;
      //URL
      String url = "https://yusufyilmaz.org/api/teachers/${Giris.kullanici_id}";
      var uri = Uri.parse(url);
      //CREATE REQUEST
      var request = new http.MultipartRequest("PUT", uri);
      //IMAGE
      if(_image != null){
        var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
        var length = await _image.length(); //imageFile is your image file
        // ignore this headers if there is no authentication
        var multipartFileSign = new http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(_image.path),
        );
        request.files.add(multipartFileSign);
      }
      // HEADER
      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": Giris.token
      };
      (_image!=null)?print(_image.path):print("resim yüklenmemiş");
      request.headers.addAll(headers);
      //PARAMS
      request.fields['firstName'] = firstName;
      request.fields['lastName'] = lastName;
      request.fields['email'] = email;
      request.fields['phoneNumber'] = phoneNumber;
      request.fields['aboutMe'] = aboutMe;

      //SEND
      var response = await request.send();
      //LISTEN FOR RESPONSE
      var imageRequest = await http.post("https://yusufyilmaz.org/api/teachers/me",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Giris.token
        },
      );
      var data = json.decode(imageRequest.body);
      response.stream.transform(utf8.decoder).listen((value) {
        isUpdate=true;
        var gelenCevap = jsonDecode(value);
        if(gelenCevap["statusCode"]==200){
          Giris.name = firstName + " " + lastName;
          Giris.email = email;
          Giris.profilImageLink = data['data']['profileImageLink'];
          cevapGoster(1,gelenCevap["resultMessage"].toString());
        }
        else{
          cevapGoster(0,gelenCevap["error"]["errorMessage"].toString());
        }
      });
    }
  }
  void cevapGoster(int i,String s) {
    if(i==1){
      showDialog(
        context: widget.ctx,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Başarılı"),
            content: new Text("$s"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Kapat"),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Anasayfa()));
                  //Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    else{
      showDialog(
        context: widget.ctx,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Hata"),
            content: new Text("$s"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Kapat"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

