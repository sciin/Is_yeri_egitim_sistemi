import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterprojeapp/Anasayfa.dart';
import 'package:flutterprojeapp/Profil.dart';
import 'Giris.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: "/",
      routes: {
        "/" : (context) => Giris(),
        "/profil" : (context) => Profil(),
        "/anasayfa" : (context) => Anasayfa(),
      },

      title: "Giriş",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepOrange,

      ),

    );
  }
}
