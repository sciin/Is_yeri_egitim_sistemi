import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Profil.dart';

class KisiselBilgiDuzenle extends StatefulWidget {
  Color baskinRenk;
  int yetki;

  @override
  _KisiselBilgiDuzenleState createState() => _KisiselBilgiDuzenleState();

  KisiselBilgiDuzenle([this.baskinRenk,this.yetki]);
}

class _KisiselBilgiDuzenleState extends State<KisiselBilgiDuzenle> {
  String adSoyad, mail, telNo, bolum, danisman;
  int calisanSayisi;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Kişisel Bilgileri Güncelle"),
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
    return [
      Form(
        key: formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          padding: EdgeInsets.all(10),
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: widget.baskinRenk,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: govde(),
            ),
          ),
        ),
      )
    ];
  }

  void _kaydetOnayla() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(
          "Kaydedilen Değerler\nAd Soyad: $adSoyad\nMail: $mail\nTelefon: $telNo\nBölüm: $bolum\nDanışman: $danisman");
    }
  }

  List<Widget> govde() {
    debugPrint(widget.yetki.toString());
    if(widget.yetki==0){
      // Öğrenci
      return [
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            labelText: "Ad",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            adSoyad = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),

        TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (girelenDeger) {
            if (girelenDeger.length > 0)
              return null;
            else
              return "Mail alanı boş bırakılamaz";
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            labelText: "Mail",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            mail = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          validator: (girelenDeger) {
            if (girelenDeger.length > 0)
              return null;
            else
              return "Bölüm alanı boş bırakılamaz";
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.school),
            labelText: "Bölüm",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            bolum = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          validator: (girelenDeger) {
            if (girelenDeger.length > 0)
              return null;
            else
              return "Danışman alanı boş bırakılamaz";
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: "Danışman",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            danisman = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton.icon(
          icon: Icon(Icons.save),
          label: Text("Kaydet"),
          elevation: 4,
          textColor: Colors.white,
          onPressed: () {
            _kaydetOnayla();
          },
          color: Color(0xff49909f),
        ),
      ];
    }else if(widget.yetki==1){
      // İş yeri
      return [
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.business),
            labelText: "Şirket Adı",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            adSoyad = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (girelenDeger) {
            if (girelenDeger.length > 0)
              return null;
            else
              return "Mail alanı boş bırakılamaz";
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            labelText: "Mail",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            mail = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: "Çalışan Sayısı",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            calisanSayisi = int.parse(kaydedilecekDeger);
          },
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton.icon(
          icon: Icon(Icons.save),
          label: Text("Kaydet"),
          elevation: 4,
          textColor: Colors.white,
          onPressed: () {
            _kaydetOnayla();
          },
          color: Color(0xff49909f),
        ),
      ];
    }else if(widget.yetki==2){
      //Danışman
      return [
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            labelText: "Ad",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            adSoyad = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            labelText: "Soyad",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            adSoyad = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (girelenDeger) {
            if (girelenDeger.length > 0)
              return null;
            else
              return "Mail alanı boş bırakılamaz";
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            labelText: "Mail",
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onSaved: (kaydedilecekDeger) {
            mail = kaydedilecekDeger;
          },
        ),
        SizedBox(
          height: 20,
        ),

        RaisedButton.icon(
          icon: Icon(Icons.save),
          label: Text("Kaydet"),
          elevation: 4,
          textColor: Colors.white,
          onPressed: () {
            _kaydetOnayla();
          },
          color: Color(0xff49909f),
        ),
      ];
    }else{
      return [
        Container(child: Text("Profil Bulunamadı"),),
      ];
    }
  }
}