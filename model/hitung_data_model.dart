class hitungdata {
  String? stok;
  String? jm;
  String? jk;
  hitungdata(this.stok, this.jm, this.jk);
  hitungdata.fromJson(Map<String, dynamic> json) {
    stok = json['stok'];
    jm = json['jm'];
    jk = json['jk'];
  }
}