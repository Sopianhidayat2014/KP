import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/model/tujuanmodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/view/tujuan/data_tujuan.dart';

const List<String> list = <String>['Masuk', 'keluar'];

class edittujuan extends StatefulWidget {
  final VoidCallback reload;
  final tujuanmodel model;
  edittujuan(this.model, this.reload);

  @override
  State<edittujuan> createState() => _edittujuanState();
}

class _edittujuanState extends State<edittujuan> {
  FocusNode myFocusNode = new FocusNode();
  String? id_tujuan, Tujuan, Tipe, Tujuan2;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txttujuan;

  setup() async {
    Tujuan2 = widget.model.tipe;
    if (Tujuan2 == "M") {
      Tujuan2 = "Masuk";
    } else if (Tujuan2 == "K") {
      Tujuan2 = "Keluar";
    }
    txttujuan = TextEditingController(text: widget.model.tujuan);
    id_tujuan = widget.model.id_tujuan;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      updatetujuan();
    }
  }

  updatetujuan() async {
    try {
      final respon =
          await http.post(Uri.parse(URL.urledittujuan.toString()), body: {
        "id_tujuan": id_tujuan,
        "tujuan": Tujuan,
        "tipe": Tipe == null ? widget.model.tipe! : Tipe
      });
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['sukses'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          //widget.reload();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new datatujuan()));
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Edit Tujuan Transaksi",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txttujuan,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Tujuan";
                } else {
                  return null;
                }
              },
              onSaved: (e) => Tujuan = e,
              decoration: InputDecoration(
                  labelText: 'Tujuan Transaksi',
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 32, 54, 70)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 32, 54, 70)),
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      style: BorderStyle.solid,
                      color: Color.fromARGB(255, 32, 54, 70),
                      width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      value: Tipe,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          Tipe = value!;
                        });
                      },
                      isExpanded: true,
                      hint: Text(
                          Tipe == null ? Tujuan2.toString() : Tipe.toString())),
                )),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              child: Text(
                "Edit",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            )
          ],
        ),
      ),
    );
  }
}
