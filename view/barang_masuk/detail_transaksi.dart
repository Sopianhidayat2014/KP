import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/model/barang_masuk_model.dart';
import 'package:penyimpanan_barang/model/transaksi_barang_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class detailtransaksi extends StatefulWidget {
  final VoidCallback reload;
  final transaksi_bm model;
  detailtransaksi(this.model, this.reload);

  @override
  State<detailtransaksi> createState() => _detailtransaksiState();
}

class _detailtransaksiState extends State<detailtransaksi> {
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
    final respons = await http
        .get(Uri.parse(URL.urldetailbm + widget.model.id_transaksi.toString()));
    if (respons.contentLength == 2) {
    } else {
      final data = jsonDecode(respons.body);
      data.forEach((api) {
        final ab = new barangmasukmodel(api['foto'], api['nama_barang'],
            api['nama_brand'], api['jumlah_masuk']);
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
                "Transaksi #" + widget.model.id_transaksi.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: _lihatdata,
                key: _refresh,
                child: loading
                    ? Center(child: Text("Data Masih Kosong"))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final x = list[i];
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: 64,
                                      minWidth: 64,
                                      maxHeight: 64,
                                      maxWidth: 64,
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
                                      Text(x.nama_barang.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                      Divider(color: Colors.transparent),
                                      Text("Brand " + x.nama_brand.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                      Divider(color: Colors.transparent),
                                      Text(
                                          "Jumlah " + x.jumlah_masuk.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )),
          ),
          Flexible(
              child: loading == true
                  ? Text("")
                  : Column(
                      children: [
                        Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(children: <Widget>[
                                ListTile(title: Text("Keterangan")),
                                ListTile(
                                    title: Text(
                                  widget.model.keterangan.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                              ]),
                              TableRow(children: <Widget>[
                                ListTile(title: Text("Tujuan Transaksi")),
                                ListTile(
                                    title: Text(
                                  widget.model.tujuan.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                              ]),
                              TableRow(children: <Widget>[
                                ListTile(title: Text("Total Barang Masuk")),
                                ListTile(
                                    title: Text(
                                  widget.model.total_item.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                )),
                              ])
                            ]),
                      ],
                    ))
        ],
      ),
    );
  }
}
