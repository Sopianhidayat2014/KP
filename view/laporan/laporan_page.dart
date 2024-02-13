import 'package:flutter/material.dart';
import 'package:penyimpanan_barang/model/laporan_bm_model.dart';
import 'package:penyimpanan_barang/model/tanggal_model.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'dart:convert';

class laporanpage extends StatefulWidget {
  final tanggalmodel tanggalModel;
  laporanpage({Key? key, required this.tanggalModel}) : super(key: key);

  @override
  State<laporanpage> createState() =>
      _laporanpageState(tanggalModel: tanggalModel);
}

class _laporanpageState extends State<laporanpage> {
   late tanggalmodel tanggalModel;
  _laporanpageState({required this.tanggalModel}) : super();
  final list = [];
  var loading = false;
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
    final respons = await http.get(Uri.parse(URL.urllaporanBM +
        this.tanggalModel.tgl1.toString() +
        "&&tgl2=" +
        this.tanggalModel.tgl2.toString()));
    if (respons.contentLength == 2) {
    } else {
      final data = jsonDecode(respons.body);
      data.forEach((api) {
        final ab = new laporanBMmodel(
            api['id_barang_masuk'],
            api['id_barang'],
            api['nama_barang'],
            api['nama_brand'],
            api['jumlah_masuk'],
            api['tgl_transaksi'],
            api['keterangan']);
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
                "Periode" +
                    this.tanggalModel.tgl1.toString().substring(0, 10) +
                    " s/d " +
                    this.tanggalModel.tgl2.toString().substring(0, 10),
                style: TextStyle(color: Colors.white, fontSize: 16.0),
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
                                    ListTile(title: Text("Kode Barang Masuk")),
                                    ListTile(
                                        title: Text(
                                      x.id_barang_masuk.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    )),
                                  ]),
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
                                    ListTile(title: Text("Jumlah Masuk")),
                                    ListTile(
                                        title: Text(
                                      x.jumlah_masuk.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    )),
                                  ]),
                                  TableRow(children: <Widget>[
                                    ListTile(title: Text("tgl Masuk")),
                                    ListTile(
                                        title: Text(
                                      x.tgl_transaksi.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    )),
                                  ]),
                                  TableRow(children: <Widget>[
                                    ListTile(title: Text("Keterangan")),
                                    ListTile(
                                        title: Text(
                                      x.keterangan.toString(),
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
