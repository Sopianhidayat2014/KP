import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/model/tujuanmodel.dart';
import 'package:penyimpanan_barang/view/barang_masuk/data_transaksi_barang_masuk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class tambahbarangmasuk extends StatefulWidget {
  final VoidCallback reload;
  tambahbarangmasuk(this.reload);

  @override
  State<tambahbarangmasuk> createState() => _tambahbarangmasukState();
}

class _tambahbarangmasukState extends State<tambahbarangmasuk> {
  FocusNode ktFocusNode = new FocusNode();
  String? Tjuan, ket;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
  }

  final _key = new GlobalKey<FormState>();
  tujuanmodel? _currentT;
  final String linkT = URL.urltujuanbm.toString();
  Future<List<tujuanmodel>> _fetchBR() async {
    var respons = await http.get(Uri.parse(linkT.toString()));
    print('hasil: ' + respons.statusCode.toString());
    if (respons.statusCode == 200) {
      final items = json.decode(respons.body).cast<Map<String, dynamic>>();
      List<tujuanmodel> listOfT = items.map<tujuanmodel>((json) {
        return tujuanmodel.fromJson(json);
      }).toList();
      return listOfT;
    } else {
      throw Exception('gagal');
    }
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      save();
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
            MaterialPageRoute(builder: (context) => new transaksibm()));
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dismiss from callback $type');
      },
    ).show();
  }

  save() async {
    try {
      final respons = await http.post(Uri.parse(URL.urltambahbm.toString()), body: {
        "tujuan": Tjuan,
        "ket": ket,
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
  void initState() {
    super.initState();
    getPref();
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
                "Tambah Barang Masuk",
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
            FutureBuilder<List<tujuanmodel>>(
              future: _fetchBR(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<tujuanmodel>> snapshot) {
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
                          .map((listT) => DropdownMenuItem(
                                child: Text(listT.tujuan.toString()),
                                value: listT,
                              ))
                          .toList(),
                      onChanged: (tujuanmodel? value) {
                        setState(() {
                          _currentT = value;
                          Tjuan = _currentT!.id_tujuan;
                        });
                      },
                      isExpanded: true,
                      hint: Text(Tjuan == null
                          ? "Pilih Tujuan Transaksi"
                          : _currentT!.tujuan.toString()),
                    )));
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan isi keterangan";
                }
              },
              onSaved: (e) => ket = e,
              focusNode: ktFocusNode,
              decoration: InputDecoration(
                labelText: 'keterangan',
                labelStyle: TextStyle(
                    color: ktFocusNode.hasFocus
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
