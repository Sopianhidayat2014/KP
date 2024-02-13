import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penyimpanan_barang/model/hitung_data_model.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:penyimpanan_barang/view/barang_keluar/data_transaksi_barang_keluar.dart';
import 'package:penyimpanan_barang/view/barang_masuk/data_transaksi_barang_masuk.dart';
import 'package:penyimpanan_barang/view/laporan/form_laporan_barang_keluar.dart';
import 'package:penyimpanan_barang/view/laporan/form_laporan_barang_masuk.dart';
import 'package:penyimpanan_barang/view/stok/data_stok.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:penyimpanan_barang/view/barang/data_barang.dart';
import 'package:penyimpanan_barang/view/brand/data_brand.dart';
import 'package:penyimpanan_barang/view/jenis/Data_jenis.dart';
import 'dart:convert';

import 'package:penyimpanan_barang/view/tujuan/data_tujuan.dart';

class homepage extends StatefulWidget {
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  FocusNode myFocusNode = new FocusNode();
  bool _MDTileExpand = false;
  bool _TsTileExpand = false;
  bool _LpTileExpand = false;

  var loading = false;
  String Stl = "0";
  String Sbm = "0";
  String Sbk = "0";
  final ex = List<hitungdata>.empty(growable: true);

  keluar() {
    setState(() {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
    });
  }

  _hitungBR() async {
    setState(() {
      loading = true;
    });
    ex.clear();
    try {
      final respons = await http.get(Uri.parse(URL.urlhitung));
      if (respons.statusCode == 200) {
        final data = jsonDecode(respons.body);

        if (data is List) {
          data.forEach((api) {
            final exp = new hitungdata(api['stok'], api['jm'], api['jk']);
            ex.add(exp);
            setState(() {
              ex.add(exp);
              setState(() {
                Stl = exp.stok.toString();
                Sbm = exp.jm.toString();
                Sbk = exp.jk.toString();
              });
            });
          });
        }
      }
    } catch (e) {}

    setState(() {
      _hitungBR();
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _hitungBR();
  }

  notifexit() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: true,
      animType: AnimType.bottomSlide,
      title: 'Anda yakin ingin keluar?',
      reverseBtnOrder: true,
      btnOkText: 'Keluar',
      btnOkOnPress: () {
        keluar();
      },
      btnCancelOnPress: () {},
      desc: 'tekan "keluar" apabila anda yakin ingin keluar.',
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.green,
        title: Text('Bintang Alumunium'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: const Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: Color.fromARGB(255, 160, 238, 206), width: 5),
                    ),
                  ),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      title: Text("Total Barang Masuk",
                          style: TextStyle(
                              color: Color.fromARGB(255, 23, 23, 41))),
                      subtitle: Sbm == "null"
                          ? Text("0",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : Text(Sbm,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                      trailing: FaIcon(FontAwesomeIcons.box, size: 40),
                    )
                  ]),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: const Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: Color.fromARGB(255, 160, 238, 206), width: 5),
                    ),
                  ),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      title: Text("Total Barang Keluar",
                          style: TextStyle(
                              color: Color.fromARGB(255, 23, 23, 41))),
                      subtitle: Sbk.toString() == "null"
                          ? Text("0",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : Text(Sbk,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                      trailing: FaIcon(FontAwesomeIcons.boxOpen, size: 40),
                    )
                  ]),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: const Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                          color: Color.fromARGB(255, 160, 238, 206), width: 5),
                    ),
                  ),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      title: Text("Total",
                          style: TextStyle(
                              color: Color.fromARGB(255, 23, 23, 41))),
                      subtitle: Stl.toString() == "null"
                          ? Text("0",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))
                          : Text(Stl,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                      trailing: FaIcon(FontAwesomeIcons.boxesStacked, size: 40),
                    )
                  ]),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Toko Bintang Alumunium',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              accountEmail:
                  Text('INVENTORY', style: TextStyle(color: Colors.white)),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage(
                    'asset/_56a59687-162c-4aaa-8c71-7515986d05c2.jpeg'),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 41, 69, 91),
              ),
            ),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: FaIcon(
                  FontAwesomeIcons.database,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                title: Text(
                  "Data",
                  style: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 51, 53, 54)),
                ),
                trailing: FaIcon(
                    _MDTileExpand
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronRight,
                    size: 15,
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 119, 120, 121)),
                children: [
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Jenis"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new datajenis()));
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Brand"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new databrand()));
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Barang"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new databarang()));
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Tujuan"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new datatujuan()));
                    },
                  ),
                ],
                onExpansionChanged: ((bool expanded) {
                  setState(() => _MDTileExpand = expanded);
                }),
              ),
            ),
            Divider(height: 25, thickness: 1),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: FaIcon(
                  FontAwesomeIcons.exchange,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                title: Text(
                  "Transaksi",
                  style: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 51, 53, 54)),
                ),
                trailing: FaIcon(
                    _TsTileExpand
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronRight,
                    size: 15,
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 119, 120, 121)),
                children: [
                  ListTile(
                    leading: Text(""),
                    title: Text("Barang Masuk"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new transaksibm()));
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Barang Keluar"),
                    onTap: () {
                       Navigator.push(
                       context,
                      MaterialPageRoute(
                      builder: (context) => new dataBK()));
                    },
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() => _TsTileExpand = expanded);
                },
              ),
            ),
            Divider(height: 25, thickness: 1),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: FaIcon(
                  FontAwesomeIcons.clipboardList,
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : Color.fromARGB(255, 119, 120, 121),
                ),
                title: Text(
                  "Laporan",
                  style: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : Color.fromARGB(255, 51, 53, 54)),
                ),
                trailing: FaIcon(
                    _LpTileExpand
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronRight,
                    size: 15,
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 119, 120, 121)),
                children: [
                  ListTile(
                    leading: Text(""),
                    title: Text("Data Stok"),
                    onTap: () {
                       Navigator.push(
                       context,
                      MaterialPageRoute(
                      builder: (context) => new datastok()));
                    },
                  ),
                  /*ListTile(
                    leading: Text(""),
                    title: Text("Laporan Data Masuk"),
                    onTap: () {
                       Navigator.push(
                       context,
                      MaterialPageRoute(
                      builder: (context) => new formlaporanbm()));
                    },
                  ),
                  ListTile(
                    leading: Text(""),
                    title: Text("Laporan Data Keluar"),
                    onTap: () {
                       Navigator.push(
                       context,
                      MaterialPageRoute(
                      builder: (context) => new formlaporanbk()));
                    },
                  ),*/
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() => _LpTileExpand = expanded);
                },
              ),
            ),
            Divider(height: 25, thickness: 1),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Keluar"),
              onTap: () => notifexit(),
            ),
          ],
        ),
      ),
      drawerEnableOpenDragGesture: false,
    );
  }
}
