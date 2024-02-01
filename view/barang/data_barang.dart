import 'package:flutter/material.dart';
import 'package:penyimpanan_barang/view/barang/edit_barang.dart';
import 'package:penyimpanan_barang/view/barang/tambah_barang.dart';
import 'package:penyimpanan_barang/view/barang/detail_barang.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/model/barangmodel.dart';

class databarang extends StatefulWidget {
  @override
  State<databarang> createState() => _databarangState();
}

class _databarangState extends State<databarang> {
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
    final response = await http.get(Uri.parse(URL.urldatabarang));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new barangmodel(
          api['id_barang'], 
          api['nama_barang'], 
          api['nama_jenis'], 
          api['nama_brand'],
          api['foto'], 
          api['id_jenis'], 
          api['id_brand']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  ProsesHapus(String id) async {
    try {
      final response = await http
          .post(Uri.parse(URL.urlhapusbarang), body: {"id_barang": id});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        int value = data['sukses'];
        String pesan = data['pesan'];
        if (value == 1) {
          setState(() {
            _lihatdata();
          });
        } else {
          print(pesan);
          dialogHapus(pesan);
        }
      }
    } catch (e) {}
  }

  dialogHapus(String pesan) {
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
                "Data Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => tambahbarang((_lihatdata))));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
          onRefresh: _lihatdata,
          key: _refresh,
          child: loading
              ? Center(child: Text("belum ada data"))
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
                            ListTile(
                              leading: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                  maxWidth: 64,
                                  maxHeight: 64,
                                ),
                                child: Image.network(
                                  URL.path + x.foto.toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                x.nama_barang.toString(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                detailbarang(x, _lihatdata)));
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.eye,
                                    color: Colors.grey,
                                  ),
                                  iconSize: 20,
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                editbarang (x, _lihatdata)));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      ProsesHapus(x.id_barang);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    )),
                                SizedBox(width: 8)
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )),
    );
  }
}
