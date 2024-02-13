import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:penyimpanan_barang/model/jenismodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:penyimpanan_barang/view/jenis/edit_jenis.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/view/jenis/tambah_jenis.dart';

class datajenis extends StatefulWidget {
  @override
  State<datajenis> createState() => _datajenisState();
}

class _datajenisState extends State<datajenis> {
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
    final response = await http.get(Uri.parse(URL.urldatajenis));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new jenismodel(api['id_jenis'], api['nama_jenis']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _prosesHapus(String id) async {
    final response =
        await http.post(Uri.parse(URL.urlhapusjenis), body: {"id_jenis": id});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int value = data['sukses'];
      String pesan = data['message'];
      if (value == 1) {
        setState(() {
          _lihatdata();
        });
      } else {
        print(pesan);
        dialogHapus(pesan);
      }
    }
  }

  dialogHapus(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'sukses',
      desc: pesan,
      btnOkOnPress: () {
        _prosesHapus(pesan);
      },
      btnOkIcon: Icons.check,
      btnOkColor: Colors.green,
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
                "Jenis Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),

      //button floating tambah jenis
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => tambahjenis((_lihatdata))));
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
                              title: Text(x.nama_jenis.toString()),
                              trailing: Wrap(
                                children: [
                                  //edit
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    editjenis(x, _lihatdata)));
                                      },
                                      icon: Icon(Icons.edit)),

                                  //hapus
                                  IconButton(
                                      onPressed: () {
                                        dialogHapus(x.id_jenis);
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
