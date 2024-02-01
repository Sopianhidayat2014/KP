import 'package:flutter/material.dart';
import 'dart:async';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:penyimpanan_barang/view/homepage.dart';

class splash extends StatefulWidget {
  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    startscreen();
  }

  startscreen() {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
        return homepage((() {}));
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FooterView(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                        'asset/_56a59687-162c-4aaa-8c71-7515986d05c2.jpeg',
                        height: 150,
                        fit: BoxFit.contain),
                  ),
                  Text(
                    "Bintang Alumunium",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
        footer: Footer(
          padding: EdgeInsets.only(bottom: 50),
          backgroundColor: Colors.white,
          child: Text(
            'Copyright @2023, Bintang Alumunium',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.0,
                color: Color(0xFF162A49)),
          ),
        ),
      ),
    );
  }
}
