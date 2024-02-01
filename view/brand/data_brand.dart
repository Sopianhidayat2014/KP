import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:penyimpanan_barang/model/brandmodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:penyimpanan_barang/view/brand/edit_brand.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/view/brand/tambah_brand.dart';

class databrand extends StatefulWidget {

  @override
  State<databrand> createState() => _databrandState();
}

class _databrandState extends State<databrand> {
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
    final response = await http.get(Uri.parse(URL.urldatabrand));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new brandmodel(api['id_brand'], api['nama_brand']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  ProsesHapus(String id) async {
  try {
    final response = await http.post(Uri.parse(URL.urlhapusbrand), body: {"id_brand": id});

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
                "Brand Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),

      //button floating tambah brand
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => tambahbrand((_lihatdata))));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
          onRefresh: _lihatdata,
          key: _refresh,
          child: loading
              ? Center(
                  child: Text("Belum ada data"),
                )

              //list View Barang
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
                              title: Text(x.nama_brand.toString()),
                              trailing: Wrap(
                                children: [
                                  //edit
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    editbrand(x, _lihatdata)));
                                      },
                                      icon: Icon(Icons.edit)),

                                  //hapus
                                  IconButton(
                                      onPressed: () {
                                        ProsesHapus(x.id_brand);
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })),
    );
  }
}