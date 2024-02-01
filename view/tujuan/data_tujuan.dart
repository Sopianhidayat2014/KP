import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'dart:convert';
import 'package:penyimpanan_barang/model/tujuanmodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/view/barang/tambah_barang.dart';
import 'package:penyimpanan_barang/view/jenis/edit_jenis.dart';
import 'package:penyimpanan_barang/view/tujuan/edit_tujuan.dart';
import 'package:penyimpanan_barang/view/tujuan/tambah_tujuan.dart';

class datatujuan extends StatefulWidget {

  @override
  State<datatujuan> createState() => _datatujuanState();
}

class _datatujuanState extends State<datatujuan> {
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
    final response = await http.get(Uri.parse(URL.urldatatujuan));
    if (response.contentLength == 2) {
    }else{
      final data = json.decode(response.body);
      data.forEach((api){
        final ab = new tujuanmodel(api['id_tujuan'], api['tujuan'], api['tipe']);
      list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

 
    _proseshapus(String id) async {
    final response = await http.post(Uri.parse(URL.urlhapustujuan), body: {"id_tujuan" : id});
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
      btnOkColor: Colors.red
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
                "Tujuan Barang",
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
                  builder: (context) => tambahtujuan((_lihatdata))));
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
                              title: Text(x.tujuan.toString()),
                              trailing: Wrap(
                                children: [
                                  //edit
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (context) => new edittujuan(x,_lihatdata)));
                                      },
                                      icon: Icon(Icons.edit)),

                                  //hapus
                                  IconButton(
                                      onPressed: () {
                                        _proseshapus(x.id_tujuan);
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