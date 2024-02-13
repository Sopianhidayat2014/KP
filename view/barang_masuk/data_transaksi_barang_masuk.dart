import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:penyimpanan_barang/model/transaksi_barang_model.dart';
import 'package:penyimpanan_barang/view/barang_masuk/detail_transaksi.dart';
import 'package:penyimpanan_barang/view/barang_masuk/keranjang_barang_masuk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class transaksibm extends StatefulWidget {
  @override
  State<transaksibm> createState() => _transaksibmState();
}

class _transaksibmState extends State<transaksibm> {
  var loading = false;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatdata() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final respons = await http.get(Uri.parse(URL.urltransaksibm));
    if (respons.contentLength == 2) {
    } else {
      final data = jsonDecode(respons.body);
      data.forEach((api) {
        final ab = new transaksi_bm(api['id_transaksi'], api['tujuan'],
            api['total_item'], api['tgl_transaksi'], api['keterangan']);
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

   _proseshapus(String id) async {
    final respons =
        await http.post(Uri.parse(URL.urlhapusbm), body: {"id": id});
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

  alerthapus(String id) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close_fullscreen_outlined),
      title: 'WARNING',
      desc:
          'Menghapus data ini akan mengembalikan stok seperti sebelum barang ini di input, yakin ingin di hapus?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _proseshapus(id);
      },
    ).show();
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
    _lihatdata();
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
                "Transaksi Barang Masuk",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new kerangjangbm()));
        },
        child: FaIcon(FontAwesomeIcons.cartPlus),
        backgroundColor: Colors.white,
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
                            title: Text(
                              x.id_transaksi.toString(),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total: " + x.total_item.toString(),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("(" + x.tgl_transaksi.toString() + ")")
                              ],
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  detailtransaksi(
                                                      x, _lihatdata)));
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.eye,
                                      size: 20,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    alerthapus(x.id_transaksi);
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.trash,
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
