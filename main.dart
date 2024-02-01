import 'package:flutter/material.dart';
import 'package:penyimpanan_barang/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.greenAccent),
    home: splash(),
  ));
}
