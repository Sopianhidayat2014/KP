import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/model/brandmodel.dart';

class editbrand extends StatefulWidget {
  final VoidCallback reload;
  final brandmodel model;
  editbrand(this.model, this.reload);

  @override
  State<editbrand> createState() => _editbrandState();
}

class _editbrandState extends State<editbrand> {
  FocusNode myFocusNode = new FocusNode();
  String? id_brand, brand;
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidbrand, txtbrand;
  setup() async {
    txtbrand = TextEditingController(text: widget.model.nama_brand);
    id_brand = widget.model.id_brand;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      ProsUp();
    }
  }

  ProsUp() async {
    try {
      final respon = await http.post(Uri.parse(URL.urleditbrand.toString()),
          body: {"id_brand": id_brand, "brand": brand});
      final data = jsonDecode(respon.body);
      print(data);
      int code = data['sukses'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
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
    return Scaffold (backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Edit Brand Barang",
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
              controller: txtbrand,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi brand";
                } else {
                  return null;
                }
              },
              onSaved: (e) => brand = e,
              decoration: InputDecoration(
                  labelText: 'brand barang',
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
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              child: Text(
                "edit",
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