import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:penyimpanan_barang/costume/datepicker.dart';
import 'package:penyimpanan_barang/model/tanggal_model.dart';
import 'package:penyimpanan_barang/view/laporan/laporan_page.dart';

class formlaporanbm extends StatefulWidget {
  const formlaporanbm({super.key});

  @override
  State<formlaporanbm> createState() => _formlaporanbmState();
}

class _formlaporanbmState extends State<formlaporanbm> {
  final _key = new GlobalKey<FormState>();
  send() {
    tanggalmodel tanggalModel = tanggalmodel("$tgl1", "$tgl2");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => laporanpage(tanggalModel: tanggalModel)));
  }

  String? pilihTanggal, labeltext;
  DateTime tgl1 = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selecDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl1,
        firstDate: DateTime(1990),
        lastDate: DateTime(2099));
    if (picked != null && picked != tgl1) {
      setState(() {
        tgl1 = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl1);
      });
    } else {}
  }

  String? Tanggal2, labeltext2;
  DateTime tgl2 = new DateTime.now();
  final TextStyle valueStyle2 = TextStyle(fontSize: 16.0);
  Future<Null> _selecDate2(BuildContext context) async {
    final DateTime? picked2 = await showDatePicker(
        context: context,
        initialDate: tgl2,
        firstDate: DateTime(1990),
        lastDate: DateTime(2099));
    if (picked2 != null && picked2 != tgl2) {
      setState(() {
        tgl2 = picked2;
        pilihTanggal = new DateFormat.yMd().format(tgl2);
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
  }

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
                child: Text(
                  "Form Laporan Barang Masuk",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              DateDropDown(
                labelText: "Dari",
                valueText: new DateFormat.yMd().format(tgl1),
                valueStyle: valueStyle,
                onPressed: () {
                  _selecDate(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              DateDropDown(
                labelText: "Sampai",
                valueText: new DateFormat.yMd().format(tgl2),
                valueStyle: valueStyle2,
                onPressed: () {
                  _selecDate2(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Color.fromARGB(255, 41, 69, 91),
                onPressed: () {
                  send();
                },
                child: Text(
                  "Laporan",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )
            ],
          ),
        ));
  }
}
