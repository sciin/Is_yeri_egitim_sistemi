import 'dart:io';
import 'dart:math';
//import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:flutterprojeapp/main.dart';
import 'package:flutterprojeapp/models/Cities.dart';
import 'package:flutterprojeapp/models/Teachers.dart';
import 'package:http/http.dart' as http;

import 'functions.dart';


class KayitOl extends StatefulWidget {
  @override
  _KayitOlState createState() => _KayitOlState();
}

class _KayitOlState extends State<KayitOl> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
  var formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String firstName,lastName,email,password,phoneNumber,companyName;
  int teacherId,citiesId;
  List authorizeType = ['Öğrenci', 'Danışman', 'İşyeri'];
  List teacherNameList,citiesNameList;
  String authorize,teacherName,citiesName;
  bool saveBasarili = false, access = false;
  int phoneLength = 0;
  final firstNameHolder = TextEditingController();
  final lastNameHolder = TextEditingController();
  final phoneHolder = TextEditingController();
  final passwordHolder = TextEditingController();
  final emailHolder = TextEditingController();
  final companyNameHolder = TextEditingController();
  int error;

  Functions functions = new Functions();

  String url = "https://yusufyilmaz.org/api";


   Future<Teachers> getTeachers([String teachersName]) async  {
    teacherNameList = [];

      var response =  await http.get('$url/teachers');

      var data = json.decode(response.body);

      if(data['error']['hasError'] == true)
        access = false;
      else access = true;

      List responseData = data['data'];



      ////JSON NESNE SAYISINI VERİR.../////
      List<Teachers> teacherList;
      teacherList=(responseData as List).map((i) =>
          Teachers.fromJson(i)).toList();

      //print(teacherList.length)
      for(int i = 0; i<teacherList.length;i++){
        setState(() {
          teacherNameList.add(responseData[i]["firstName"]);
          if(teachersName == responseData[i]["firstName"])
            teacherId = responseData[i]["id"];


        });



    }

  }
   Future<Cities> getCities([String citiesName]) async {
    citiesNameList = [];
    var response =  await http.get('$url/cities');
    var data = json.decode(response.body);
    List responseData = data['data'];
    ////JSON NESNE SAYISINI VERİR.../////
    List<Cities> citiesList;
    citiesList=(responseData as List).map((i) =>
        Cities.fromJson(i)).toList();
    //print(teacherList.length)
    for(int i = 0; i<citiesList.length;i++){
      setState(() {
        citiesNameList.add(responseData[i]["name"]);
        if(citiesName == responseData[i]["name"])
          citiesId = responseData[i]["id"];
      });
    }
  }

   Future<http.Response> teacherPost() async {

      if(!validateMobile(phoneNumber))
       _girisHataGoster("Geçerli telefon numarası gir.(Örneğin; 0555 255 55 55");
     else if(!validateEmail(email))
       _girisHataGoster("Geçerli mail adresi gir.(Örneğin; example@gmail.com");
     else{
       var response = await http.post(
         '$url/auth/teacher/register',
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body: jsonEncode(<String,Object>{
           'email': email,
           'firstName': firstName,
           'lastName': lastName,
           'phoneNumber': phoneNumber,
           'password': password,
         }),
       );
       var responseBody = json.decode(response.body);
       if(responseBody['statusCode'] != 200)
         _girisHataGoster(error);
       else{
           _girisHataGoster("Kayıt Başarılı");
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Giris()));
           return response;

     }


    }
  }
   Future<http.Response> studentsPost()  async {
        if(teacherName == null)
       _girisHataGoster("Lütfen danışman seç");
       else if(!validateMobile(phoneNumber))
         _girisHataGoster("Geçerli telefon numarası gir.(Örneğin; 0555 255 55 55");
       else if(!validateEmail(email))
          _girisHataGoster("Geçerli mail adresi gir.(Örneğin; example@gmail.com");
       else{
         var response =  await http.post(
           '$url/auth/student/register',
           headers: <String, String>{
             'Content-Type': 'application/json; charset=UTF-8',
           },
           body: jsonEncode(<String,Object>{
             'email': email,
             'firstName': firstName,
             'lastName': lastName,
             'phoneNumber': phoneNumber,
             'password': password,
             'teacherId' : teacherId
           }),
         );
         var responseBody = json.decode(response.body);
         String error = responseBody['error']['errorMessage'];
         if(responseBody['statusCode'] != 200)
           _girisHataGoster(error);
         else{
             _girisHataGoster("Kayıt Başarılı");
             return response;
       }




     }
  }
   Future<http.Response> companyPost() async {
     if(citiesName == null)
       _girisHataGoster("Lütfen danışman seç");
     else if(!validateMobile(phoneNumber))
       _girisHataGoster("Geçerli telefon numarası gir.(Örneğin; 0555 255 55 55");
     else if(!validateEmail(email))
       _girisHataGoster("Geçerli mail adresi gir.(Örneğin; example@gmail.com");
     else{
       var response = await http.post(
         '$url/auth/company/register',
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body: jsonEncode(<String,Object>{
           'email': email,
           'name': companyName,
           'phoneNumber': phoneNumber,
           'password': password,
           'cityId' : citiesId,
           'authorizeType' : 2
         }),
       );
       String errorMessage;
       if(!validateMobile(phoneNumber))
         errorMessage = "Geçerli telefon numarası gir.(Örneğin; 0555 255 55 55";
       if(!validateEmail(email))
         errorMessage = "Geçerli mail adresi gir.(Örneğin; example@gmail.com";
       var responseBody = json.decode(response.body);
       String error = responseBody['error']['errorMessage'];
       if(responseBody['statusCode'] != 200)
         _girisHataGoster(error);
       else{
         if(errorMessage == null){
           _girisHataGoster("Kayıt Başarılı");
           return response;
         }
         else
           _girisHataGoster(errorMessage);

       }
     }


  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            children: <Widget>[
              Form(
                key: formKey,
                autovalidate: _autoValidate,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Text("Girş Yapmak İçin Kayıt Olun",
                          style: TextStyle(fontSize: 15)),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Kayıt türünü seç",style: TextStyle(fontSize: 14),),
                            DropdownButton(

                              hint: Text("Kayıt Türü Seçiniz"),
                              value: authorize,
                              onChanged: (responseItem){
                                firstNameHolder.clear();
                                lastNameHolder.clear();
                                passwordHolder.clear();
                                phoneHolder.clear();
                                emailHolder.clear();
                                companyNameHolder.clear();
                                setState(() {
                                  authorize = responseItem;
                                  error = null;

                                });
                                if(authorize == "Öğrenci")
                                 getTeachers();
                                else if(authorize == "İşyeri")
                                  getCities();

                              },
                              items: authorizeType.map((items){
                                return DropdownMenuItem(
                                  child: new Text(items),
                                  value: items,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      icerik(authorize),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              child: Text(
                                "Giriş Yap",
                                style: TextStyle(fontSize: 15, color: Colors.blue),
                              ),
                              onTap: () {
                               Navigator.pop(context, MaterialPageRoute(builder: (context) => Giris()));
                              },
                            ),
                            RaisedButton(
                              onPressed: () {

                                if(authorize == null)
                                  _girisHataGoster("Kayıt tipi seçin");
                                else{
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    saveBasarili = true;
                                  } else
                                    saveBasarili = false;
                                  if(saveBasarili == true){
                                    registerOperation(authorize);
                                  }
                                  else{
                                    if(authorize == "Öğrenci")
                                      studentsPost();
                                    else if(authorize == "Danışman")
                                      teacherPost();
                                    else
                                      companyPost();
                                  }
                                }
                              },
                              child: Text("Kayıt Ol",style: TextStyle(color: Colors.white),),
                              color: Colors.deepOrange,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget icerik(String authorizeType) {


    if(authorizeType == "Öğrenci")
        {
          return Column(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: firstNameHolder,
                  onChanged: (text){
                    setState(() {
                      firstName = text;
                    });
                  },
                  onSaved: (responseFirstName) {
                    setState(() {
                      firstName = responseFirstName;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Ad",
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: lastNameHolder,
                  onChanged: (responseItem){
                    setState(() {
                      lastName = responseItem;
                    });
                  },
                  onSaved: (responseLastName) {
                    lastName = responseLastName;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Soyad",
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  maxLength: 14,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,


                  controller: phoneHolder,
                  onChanged: (responseItem){
                    setState(() {
                      if(responseItem.length < phoneLength){
                        phoneLength = responseItem.length;
                      }
                      else
                        {
                          phoneLength = responseItem.length;
                          if(responseItem.length==4 || responseItem.length == 8 || responseItem.length == 11 )
                          {
                            phoneHolder.text+=' ';
                            phoneHolder.selection = TextSelection.fromPosition(TextPosition(offset: phoneHolder.text.length));
                          }
                        }

                      phoneNumber = responseItem;
                    });
                  },
                  onSaved: (responsePhoneNumber) {
                    phoneNumber = (responsePhoneNumber);
                  },
                  //keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.call),
                    labelText: "0555 555 55 55",
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: emailHolder,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (responseItem){
                    setState(() {
                      email = responseItem;
                    });
                  },
                  onSaved: (responseMail) {
                    email = responseMail;
                  },
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: passwordHolder,
                  obscureText: true,
                  onChanged: (responseItem){
                    setState(() {
                      password = responseItem;
                    });
                  },
                  onSaved: (responsePassword) {
                    password = responsePassword;
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
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Danışman Seç",style: TextStyle(fontSize: 15),),
                    DropdownButton(
                      hint: Text("Danışman Seçiniz"),
                      value: teacherName,
                      onChanged: (responseItem){
                        setState(() {
                          teacherName = responseItem;
                        });
                        getTeachers(teacherName);
                      },
                      items: teacherNameList?.map((items){
                        return DropdownMenuItem(
                          child: new Text(items),
                          value: items,
                        );
                      })?.toList() ?? [],
                    ),
                  ],
                ),
              ),
            ],
          );


        }
    else if(authorizeType == "Danışman")
        {
          return Column(
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: firstNameHolder,
                  onChanged: (text){
                    setState(() {
                      firstName = text;
                    });
                  },
                  onSaved: (responseFirstName) {
                    firstName = responseFirstName;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Ad",
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: lastNameHolder,
                  onChanged: (text){
                    setState(() {
                      lastName = text;
                    });
                  },
                  onSaved: (responseLastName) {
                    lastName = responseLastName;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: "Soyad",
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: phoneHolder,
                  maxLength: 14,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onChanged: (responseItem){
                    setState(() {
                      if(responseItem.length < phoneLength){
                        phoneLength = responseItem.length;
                      }
                      else
                      {
                        phoneLength = responseItem.length;
                        if(responseItem.length==4 || responseItem.length == 8 || responseItem.length == 11 )
                        {
                          phoneHolder.text+=' ';
                          phoneHolder.selection = TextSelection.fromPosition(TextPosition(offset: phoneHolder.text.length));
                        }
                      }

                      phoneNumber = responseItem;
                    });
                  },
                  onSaved: (responsePhoneNumber) {
                    phoneNumber = responsePhoneNumber;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.call),
                    labelText: "Telefon Numarası(05553332222)",
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: emailHolder,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text){
                    setState(() {
                      email = text;
                    });
                  },
                  onSaved: (responseMail) {
                    email = responseMail;
                  },
                ),
              ),
              SizedBox(height: 20,),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.redAccent,
                ),
                child: TextFormField(
                  controller: passwordHolder,
                  obscureText: true,
                  onChanged: (text){
                    setState(() {
                      password = text;
                    });
                  },
                  onSaved: (responsePassword) {
                    password = responsePassword;
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
            ],
          );
        }

    else if(authorizeType == "İşyeri")
      {
        return Column(
          children: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.redAccent,
              ),
              child: TextFormField(
                controller: companyNameHolder,
                onChanged: (text){
                  setState(() {
                    companyName = text;
                  });
                },
                onSaved: (responseCompaniesName) {
                  companyName = responseCompaniesName;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.business),
                  labelText: "Şirket Adı",
                  labelStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.redAccent,
              ),
              child: TextFormField(
                controller: phoneHolder,
                maxLength: 14,
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                onChanged: (responseItem){
                  setState(() {
                    if(responseItem.length < phoneLength){
                      phoneLength = responseItem.length;
                    }
                    else
                    {
                      phoneLength = responseItem.length;
                      if(responseItem.length==4 || responseItem.length == 8 || responseItem.length == 11 )
                      {
                        phoneHolder.text+=' ';
                        phoneHolder.selection = TextSelection.fromPosition(TextPosition(offset: phoneHolder.text.length));
                      }
                    }

                    phoneNumber = responseItem;
                  });
                },
                onSaved: (responsePhoneNumber) {
                  phoneNumber = responsePhoneNumber;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.call),
                  labelText: "Telefon Numarası(05553332222)",
                  labelStyle: TextStyle(fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.redAccent,
              ),
              child: TextFormField(
                controller: emailHolder,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text){
                  setState(() {
                    email = text;
                  });
                },
                onSaved: (responseMail) {
                  email = responseMail;
                },
              ),
            ),
            SizedBox(height: 20,),
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.redAccent,
              ),
              child: TextFormField(
                controller: passwordHolder,
                obscureText: true,
                onChanged: (text){
                  setState(() {
                    password = text;
                  });
                },
                onSaved: (responsePassword) {
                  password = responsePassword;
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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Şehir",style: TextStyle(fontSize: 15),),
                  DropdownButton(
                    hint: Text("Şehir Seçiniz"),
                    value: citiesName,
                    onChanged: (responseItem){
                      setState(() {
                        citiesName = responseItem;
                      });
                      getCities(citiesName);
                    },
                    items: citiesNameList?.map((items){
                      return DropdownMenuItem(
                        child: new Text(items),
                        value: items,
                      );
                    })?.toList() ?? [],
                  ),
                ],
              ),
            ),
          ],
        );

      }
    else
        return Container();
  }

  void registerOperation(String authorize) {
    switch(authorize){
      case "Öğrenci": studentsPost(); break;
      case "Danışman": teacherPost();  break;
      case "İşyeri": companyPost();   break;
    }
  }

  void _girisHataGoster(var s) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (s == "Kayıt Başarılı") ? Text("Bilgilendirme"): Text("Kayıt Hatası"),
          content: new Text("$s"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                if(s == "Kayıt Başarılı")
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Giris()));
                else
                  Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }
  bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    String pattern2 = r'^[0-9]{4}\s[0-9]{3}\s[0-9]{2}\s[0-9]{2}$';
    RegExp regExp = new RegExp(pattern2);
    return (!regExp.hasMatch(value)) ? false : true;
  }
}
