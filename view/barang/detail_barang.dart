import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/model/barangmodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class detailbarang extends StatefulWidget {
  final VoidCallback reload;
  final barangmodel model;
  detailbarang(this.model, this.reload);

  @override
  State<detailbarang> createState() => _detailbarangState();
}

class _detailbarangState extends State<detailbarang> {
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
              child: Text("Detail Barang" + widget.model.id_barang.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20.0)),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                width: double.infinity,
                height: 250.0,
                child: InkWell(
                    onTap: () {
                      showImageViewer(
                          context,
                          Image.network(URL.path + widget.model.foto.toString())
                              .image,
                          swipeDismissible: true);
                    },
                    child: Image.network(
                        URL.path + widget.model.foto.toString(),
                        fit: BoxFit.contain))),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(children: <Widget>[
                  ListTile(title: Text("Id Barang")),
                  ListTile(
                      title: Text(
                    widget.model.id_barang.toString(),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  )),
                ]),
                TableRow(children: <Widget>[
                  ListTile(title: Text("Nama Barang")),
                  ListTile(
                      title: Text(
                    widget.model.nama_barang.toString(),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  )),
                ]),
                TableRow(children: <Widget>[
                  ListTile(title: Text("Jenis")),
                  ListTile(
                      title: Text(
                    widget.model.id_jenis.toString(),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  )),
                ]),
                TableRow(children: <Widget>[
                  ListTile(title: Text("Brand")),
                  ListTile(
                      title: Text(
                    widget.model.nama_brand.toString(),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  )),
                ]),
              ],
            )
          ],
        )),
      ),
    );
  }
}
