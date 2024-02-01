import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/model/stok_model.dart';

class datastok extends StatefulWidget {
  @override
  State<datastok> createState() => _datastokState();
}

class _datastokState extends State<datastok> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatdata();
  }

  Future<void> _lihatdata() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final respons = await http.get(Uri.parse(URL.urlstokbarang));
    if (respons.contentLength == 2) {
    } else {
      final data = json.decode(respons.body);
      data.forEach((api) {
        final ab = new stokmodel(
            api['no'],
            api['id_barang'],
            api['nama_barang'],
            api['nama_jenis'],
            api['nama_brand'],
            api['stok']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
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
                "Data Stok Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: RefreshIndicator(
          onRefresh: _lihatdata,
          key: _refresh,
          child: loading
              ? Center(
                  child: Text("Data Masih Kosong"),
                )
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Card(
                          color: const Color.fromARGB(255, 250, 248, 246),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: <TableRow>[
                                  TableRow(children: <Widget>[
                                    ListTile(title: Text("Kode Barang")),
                                    ListTile(
                                        title: Text(
                                      x.id_barang.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    )),
                                  ]),
                                  TableRow(children: <Widget>[
                                    ListTile(title: Text("Nama Barang")),
                                    ListTile(
                                        title: Text(
                                      x.nama_barang.toString() +
                                          "(" +
                                          x.nama_brand.toString() +
                                          ")",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    )),
                                  ]),
                                  TableRow(children: <Widget>[
                                    ListTile(title: Text("Stok")),
                                    ListTile(
                                        title: Text(
                                      x.stok.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    )),
                                  ]),
                                ],
                              )
                            ],
                          ),
                        ));
                  },
                )),
    );
  }
}
