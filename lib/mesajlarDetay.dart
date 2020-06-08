import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterprojeapp/Giris.dart';
import 'package:flutterprojeapp/models/MesajMenu.dart';
import 'package:http/http.dart' as http;
import 'models/Mesaj.dart';

class mesajlarDetay extends StatefulWidget {
  MesajMenu veri;

  mesajlarDetay({this.veri});

  @override
  _mesajlarDetayState createState() => _mesajlarDetayState();
}

class _mesajlarDetayState extends State<mesajlarDetay> {
  List<Mesaj> veri = new List<Mesaj>();
  String mesaj;
  var formKey = GlobalKey<FormState>();
  var _controller = TextEditingController();
  Future<List<Mesaj>> _future;
  var _timer = new Timer(new Duration(days: 10), () => {});
  var _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = setUpTimedFetch();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 116, 116, 116), //change your color here
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: widget.veri.profileImageLink != null
                  ? NetworkImage(widget.veri.profileImageLink)
                  : AssetImage("assets/images/sirket.jpg"),
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.veri.name,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .apply(color: Colors.black),
                  overflow: TextOverflow.clip,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  body() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  veri = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: mesajlar,
                    itemCount: veri.length,
                  );
                } else
                  return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
        Form(
          key: formKey,
          child: Container(
            margin: EdgeInsets.fromLTRB(7, 0, 7, 7),
            height: 61,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Type Something...",
                              border: InputBorder.none,
                            ),
                            onSaved: (gelenCevap) {
                              mesaj = gelenCevap;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: InkWell(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onTap: () {
                      MesajGonder().then((value) {
                        if (value) {
                          setState(() {});
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget mesajlar(BuildContext context, int index) {
    if (Giris.kullanici_id != veri[index].senderId) {
      // karşı taraf mesaj atmışsa
      // sol
      return Container(
        margin: EdgeInsets.fromLTRB(5, 8, 0, 0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.veri.profileImageLink != null
                  ? NetworkImage(widget.veri.profileImageLink)
                  : AssetImage("assets/images/sirket.jpg"),
            ),
            SizedBox(width: 5),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Color(0xffececec),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Text(
                "${veri[index].text}",
                style: Theme.of(context).textTheme.body1.apply(
                      color: Colors.black87,
                    ),
              ),
            ),
            SizedBox(width: 15),
            /* Expanded(
              child: Text(
                zamanGoster(veri[index].createdDate),
                style:
                    Theme.of(context).textTheme.body2.apply(color: Colors.grey),
              ),
            ),*/
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 8, 5, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /*  Text(
              zamanGoster(veri[index].createdDate),
              style:
                  Theme.of(context).textTheme.body2.apply(color: Colors.grey),
            ),*/
            SizedBox(width: 15),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .7),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Color(0xff4BB17B),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Text(
                "${veri[index].text}",
                style: Theme.of(context).textTheme.body1.apply(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      );
    }
  }

  setUpTimedFetch() {
    return Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        _future = MesajGoster();
      });
    });
  }

  Future<List<Mesaj>> MesajGoster() async {
    var response = await http.get(
      "https://yusufyilmaz.org/api/users/${Giris.kullanici_tipi}/${Giris.kullanici_id}/chats/${widget.veri.type}/${widget.veri.id}",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': Giris.token
      },
    );
    var gelenCevap = jsonDecode(response.body);
    var responseData = gelenCevap["data"];

    List<Mesaj> temp =
        (responseData as List).map((e) => Mesaj.fromJsonMap(e)).toList();

    response = null;
    responseData = null;
    gelenCevap = null;

    return temp;
  }

  String zamanGoster(String createdDate) {
    var tarih = DateTime.parse(createdDate);
    var day =
        tarih.day < 10 ? ("0" + tarih.day.toString()) : tarih.day.toString();
    var month = tarih.month < 10
        ? ("0" + tarih.month.toString())
        : tarih.month.toString();
    return day +
        "/" +
        month +
        "\n" +
        tarih.hour.toString() +
        ":" +
        tarih.minute.toString();
  }

  Future<bool> MesajGonder() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (mesaj.length == 0) {
        return false;
      }
      _controller.clear();
      String url =
          "https://yusufyilmaz.org/api/users/${Giris.kullanici_tipi}/${Giris.kullanici_id}/messages";
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Giris.token
        },
        body: jsonEncode(<String, Object>{
          "senderId": Giris.kullanici_id,
          "receiverId": widget.veri.id,
          "text": mesaj,
          "senderType": Giris.kullanici_tipi,
          "receiverType": widget.veri.type
        }),
      );
      return true;
    }
  }
}
