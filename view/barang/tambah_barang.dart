import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:penyimpanan_barang/model/barangmodel.dart';
import 'package:penyimpanan_barang/model/brandmodel.dart';
import 'package:penyimpanan_barang/model/jenismodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class tambahbarang extends StatefulWidget {
  final VoidCallback reload;
  tambahbarang(this.reload);

  @override
  State<tambahbarang> createState() => _tambahbarangState();
}

class _tambahbarangState extends State<tambahbarang> {
  FocusNode myFocusNode = new FocusNode();
  String? barang, jenisB, brandB;
  final _key = new GlobalKey<FormState>();
  File? _imageFile;
  final image_picker = ImagePicker();

  _pilihgalery() async {
    final image = await image_picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        print('Tidak Ada Gambar Yang dipilih');
      }
    });
  }

  _pilihcamera() async {
    final image = await image_picker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        print('Tidak Ada Gambar Yang dipilih');
      }
    });
  }

  jenismodel? _jenis;
  final String? linkjenis = URL.urldatajenis;
  Future<List<jenismodel>> _fetchjenis() async {
    var response = await http.get(Uri.parse(linkjenis.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<jenismodel> listofjenis = items.map<jenismodel>((json) {
        return jenismodel.fromJson(json);
      }).toList();
      return listofjenis;
    } else {
      throw Exception('gagal');
    }
  }

  brandmodel? _brand;
  final String? linkbrand = URL.urldatabrand;
  Future<List<brandmodel>> _fetchbrand() async {
    var response = await http.get(Uri.parse(linkbrand.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<brandmodel> listofbrand = items.map<brandmodel>((json) {
        return brandmodel.fromJson(json);
      }).toList();
      return listofbrand;
    } else {
      throw Exception('gagal');
    }
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      save();
    }
  }

  save() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile!.openRead()));
      var length = await _imageFile!.length();
      var uri = Uri.parse(URL.urltambahbarang);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nama'] = barang!;
      request.fields['jenis'] = jenisB!;
      request.fields['brand'] = brandB!;
      request.files.add(http.MultipartFile("foto", stream, length,
          filename: path.basename(_imageFile!.path)));
      var respon = await request.send();
      if (respon.statusCode > 2) {
        print("berhasil upload");
        if (this.mounted) {
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
        }
      } else {
        print("gagal");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  notiffoto() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Upload Foto",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Silahkan Pilih Sumber File",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          _pilihcamera();
                        },
                        child: FaIcon(
                          FontAwesomeIcons.camera,
                          size: 50,
                        )),
                    SizedBox(
                      width: 50,
                    ),
                    InkWell(
                        onTap: () {
                          _pilihgalery();
                        },
                        child: FaIcon(
                          FontAwesomeIcons.image,
                          size: 50,
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
        width: double.infinity,
        height: 150.0,
        child: Icon(
          CupertinoIcons.camera_viewfinder,
          size: 100,
        ));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Tambah Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Text("Foto Produk"),
            Container(
                width: double.infinity,
                height: 150.0,
                child: InkWell(
                    onTap: () {
                      notiffoto();
                    },
                    child: _imageFile == null
                        ? placeholder
                        : Image.file(_imageFile!, fit: BoxFit.contain))),
            SizedBox(height: 20),
            TextFormField(
              validator: (e) {
                if ((e as dynamic).isEmpty) {
                  return "Silahkan isi nama barang";
                }
              },
              onSaved: (e) => barang = e,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                labelText: 'Nama Barang',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<jenismodel>>(
                future: _fetchjenis(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<jenismodel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: Color.fromARGB(255, 32, 54, 70),
                            width: 0.80)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      items: snapshot.data!
                          .map((listjenis) => DropdownMenuItem(
                                child: Text(listjenis.nama_jenis.toString()),
                                value: listjenis,
                              ))
                          .toList(),
                      onChanged: (jenismodel? value) {
                        setState(() {
                          _jenis = value;
                          jenisB = _jenis!.id_jenis;
                        });
                      },
                      isExpanded: true,
                      hint: Text(jenisB == null
                          ? "Pilih Jenis"
                          : _jenis!.nama_jenis.toString()),
                    )),
                  );
                }),
            SizedBox(height: 20),
            FutureBuilder<List<brandmodel>>(
                future: _fetchbrand(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<brandmodel>> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: Color.fromARGB(255, 32, 54, 70),
                            width: 0.80)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                      items: snapshot.data!
                          .map((listbrand) => DropdownMenuItem(
                                child: Text(listbrand.nama_brand.toString()),
                                value: listbrand,
                              ))
                          .toList(),
                      onChanged: (brandmodel? value) {
                        setState(() {
                          _brand = value;
                          brandB = _brand!.id_brand;
                        });
                      },
                      isExpanded: true,
                      hint: Text(brandB == null
                          ? "Pilih Brand"
                          : _brand!.nama_brand.toString()),
                    )),
                  );
                }),
            SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            )
          ],
        ),
      ),
    );
  }
}
