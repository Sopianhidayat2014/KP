import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/model/keranjangBmodel.dart';
import 'package:penyimpanan_barang/view/barang_keluar/tambah_barang_keluar.dart';
import 'package:penyimpanan_barang/view/barang_keluar/tambah_keranjang_barang_keluar.dart';
import 'package:penyimpanan_barang/view/barang_masuk/tambah_keranjang_barang_masuk.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class keranjangBK extends StatefulWidget {
  @override
  State<keranjangBK> createState() => _keranjangBKState();
}

class _keranjangBKState extends State<keranjangBK> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refersh =
      GlobalKey<RefreshIndicatorState>();
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _lihatdata();
  }

  Future<void> _lihatdata() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final respons = await http.get(Uri.parse(URL.urlcartbk));
    if (respons.contentLength == 2) {
    } else {
      final data = jsonDecode(respons.body);
      data.forEach((api) {
        final ab = new keranjangmodel(api['id_tmp'], api['id_barang'],
            api['foto'], api['nama_barang'], api['nama_brand'], api['jumlah']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _proseshapus(String id) async {
    final respons =
        await http.post(Uri.parse(URL.urlhapuscbk), body: {"id": id});
    final data = jsonDecode(respons.body);
    int value = data['sukses'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatdata();
      });
    } else {
      print(pesan);
      dialoghapus(pesan);
    }
  }

  dialoghapus(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'ERROR',
      desc: pesan,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
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
                "Keranjang Barang Keluar",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            width: double.infinity,
            child: MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new tambahKBK()));
              },
              child: Text(
                "Tambah",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: RefreshIndicator(
                onRefresh: _lihatdata,
                key: _refersh,
                child: loading
                    ? Center(
                        child: Text("Data Masih Kosong",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal)))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final x = list[i];
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                      leading: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 64,
                                          minHeight: 64,
                                          maxWidth: 64,
                                          maxHeight: 64,
                                        ),
                                        child: Image.network(
                                          URL.path + x.foto.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("ID " + x.id_barang.toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Text(x.id_barang.toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Text(
                                              "Brand" + x.nama_brand.toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                          Text("Jumlah " + x.jumlah.toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Divider(
                                            color: Colors.transparent,
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            _proseshapus(x.id_tmp);
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.trash,
                                            size: 20,
                                            color: Colors.red,
                                          ))),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(5),
            width: double.infinity,
            child: loading == true
                ? Text("")
                : MaterialButton(
                    color: Color.fromARGB(255, 41, 69, 91),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new tambahBK(_lihatdata)));
                    },
                    child: Text(
                      "Proses Data",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
          )
        ],
      ),
    );
  }
}
