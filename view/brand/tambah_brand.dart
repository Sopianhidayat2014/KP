import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:penyimpanan_barang/model/brandmodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart  ';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/view/brand/data_brand.dart';

class tambahbrand extends StatefulWidget {
  final VoidCallback reload;
  tambahbrand(this.reload);

  @override
  State<tambahbrand> createState() => _tambahbrandState();
}

class _tambahbrandState extends State<tambahbrand> {
   FocusNode myFocusNode = new FocusNode();
  String? brand;
  final _key = new GlobalKey<FormState>();
  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpanbrand();
    }
  }

  simpanbrand() async {
    try {
      final response = await http.post(Uri.parse(URL.urltambahbrand.toString()),
          body: {"brand": brand});
      final data = jsonDecode(response.body);
      print(data);
      int code = data['sukses'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          widget.reload();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Tambah Brand barang",
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
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan isi brand";
                }
              },
              onSaved: (e) => brand = e,
              decoration: InputDecoration(
                labelText: 'Brand Barang',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Color.fromARGB(255, 32, 54, 70)
                        : Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              child: Text("Simpan", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}