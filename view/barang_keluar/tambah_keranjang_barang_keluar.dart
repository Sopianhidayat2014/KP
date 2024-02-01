import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/model/barangmodel.dart';
import 'package:penyimpanan_barang/view/barang_keluar/keranjang_barang_keluar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class tambahKBK extends StatefulWidget {
  @override
  State<tambahKBK> createState() => _tambahKBKState();
}

class _tambahKBKState extends State<tambahKBK> {
  FocusNode jmFocusNode = new FocusNode();
  String? Barang;
  String? Jumlah;

  final _key = new GlobalKey<FormState>();
  barangmodel? _currentBR;
  final String? inkBR = URL.urldatabarang;
  Future<List<barangmodel>> _fetchBR() async {
    var respons = await http.get(Uri.parse(inkBR.toString()));
    print('hasil: ' + respons.statusCode.toString());
    if (respons.statusCode == 200) {
      final items = json.decode(respons.body).cast<Map<String, dynamic>>();
      List<barangmodel> listOfBR = items.map<barangmodel>((json) {
        return barangmodel.fromJson(json);
      }).toList();
      return listOfBR;
    } else {
      throw Exception('gagal');
    }
  }

  dialogsukses(String pesan) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc: pesan,
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new keranjangBK()));
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dismiss from callback $type');
      },
    ).show();
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      simpan();
    }
  }

  simpan() async {
    try {
      final respons =
          await http.post(Uri.parse(URL.urlinputcbk.toString()), body: {
        "barang": Barang,
        "jumlah": Jumlah,
      });
      final data = jsonDecode(respons.body);
      print(data);
      int code = data['sukses'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          dialogsukses(pesan);
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
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
                "Tambah Keranjang Barang Keluar",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            FutureBuilder<List<barangmodel>>(
              future: _fetchBR(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<barangmodel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Container(
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
                      items: snapshot.data!
                          .map((listBR) => DropdownMenuItem(
                                child: Text(listBR.nama_barang.toString() +
                                    "(" +
                                    listBR.nama_brand.toString() +
                                    ")"),
                                value: listBR,
                              ))
                          .toList(),
                      onChanged: (barangmodel? value) {
                        setState(() {
                          _currentBR = value;
                          Barang = _currentBR!.id_barang;
                        });
                      },
                      isExpanded: true,
                      hint: Text(Barang == null
                          ? "Pilih Tujuan Transaksi"
                          : _currentBR!.nama_brand.toString() +
                              "(" +
                              _currentBR!.nama_brand.toString() +
                              ")"),
                    )));
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan isi Jumlah";
                }
              },
              onSaved: (e) => Jumlah = e,
              focusNode: jmFocusNode,
              decoration: InputDecoration(
                labelText: 'Jumlah Barang',
                labelStyle: TextStyle(
                    color: jmFocusNode.hasFocus
                        ? Colors.blue
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
              child: Text(
                "Simpan",
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
