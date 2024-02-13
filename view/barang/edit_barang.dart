import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penyimpanan_barang/model/barangmodel.dart';
import 'package:penyimpanan_barang/model/brandmodel.dart';
import 'package:penyimpanan_barang/model/jenismodel.dart';
import 'package:penyimpanan_barang/model/api.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

import 'package:penyimpanan_barang/view/barang/data_barang.dart';

class editbarang extends StatefulWidget {
  final VoidCallback reload;
  final barangmodel model;
  editbarang(this.model, this.reload);

  @override
  State<editbarang> createState() => _editbarangState();
}

class _editbarangState extends State<editbarang> {
  FocusNode myFocusNode = new FocusNode();
  String? id_barang, nama, brand, jenis;
  final _key = new GlobalKey<FormState>();
  File? _imagefile;
  final image_picker = ImagePicker();
  TextEditingController? txtbarang;
  setup() async {
    txtbarang = TextEditingController(text: widget.model.nama_barang);
    id_barang = widget.model.id_barang;
  }

  _pilihgalery() async {
    final image = await image_picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imagefile = File(image.path);
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
        _imagefile = File(image.path);
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

  check() async {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      await (form as dynamic).save();
      prosesUp();
    }
  }

  prosesUp() async {
    try {
      final stream =
          http.ByteStream(DelegatingStream.typed(_imagefile!.openRead()));
      var length = await _imagefile!.length();
      var uri = Uri.parse(URL.urleditbarang);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_barang'] = id_barang.toString();
      request.fields['nama'] = nama.toString();
      request.fields['jenis'] = jenis == null ? widget.model.id_jenis! : jenis!;
      request.fields['brand'] = brand == null ? widget.model.id_brand! : brand!;
      request.files.add(http.MultipartFile("foto", stream, length,
          filename: path.basename(_imagefile!.path)));
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
      if (await noImgUp()) {
      } else {
        debugPrint(e.toString());
      }
    }
  }

  dialogsukses(String pesan) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc: pesan,
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => new databarang()));
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dismiss from callback $type');
      },
    ).show();
  }

  noImgUp() async {
    try {
      final respon =
          await http.post(Uri.parse(URL.urleditbarang.toString()), body: {
        "id_barang": id_barang,
        "nama": nama,
        "brand": brand == null ? widget.model.id_brand! : brand!,
        "jenis": jenis == null ? widget.model.id_jenis! : jenis!
      });
      final data = jsonDecode(respon.body);
      int code = data['sukses'];
      String pesan = data['message'] ?? '';
      print(data);
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
          dialogsukses(pesan);
        });
        return true;
      } else {
        print(pesan);
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  foto() async {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Silahkan Pilih File",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 18.0),
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
                    SizedBox(width: 50),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Edit Data Barang",
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
                      foto();
                    },
                    child: _imagefile == null
                        ? Image.network(URL.path + widget.model.foto.toString())
                        : Image.file(_imagefile!, fit: BoxFit.contain))),
            SizedBox(height: 20),
            TextFormField(
              controller: txtbarang,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi nama";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nama = e,
              decoration: InputDecoration(
                labelText: 'Nama',
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
                          jenis = _jenis!.id_jenis;
                        });
                      },
                      isExpanded: true,
                      hint: Text(
                          jenis == null || jenis == widget.model.nama_jenis
                              ? widget.model.nama_jenis.toString()
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
                          brand = _brand!.id_brand;
                        });
                      },
                      isExpanded: true,
                      hint: Text(
                          brand == null || brand == widget.model.nama_brand
                              ? widget.model.nama_brand.toString()
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
                "Edit",
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
