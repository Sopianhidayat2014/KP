class tujuanmodel {
  String? id_tujuan;
  String? tujuan;
  String? tipe;
  tujuanmodel(this.id_tujuan, this.tujuan, this.tipe);
  tujuanmodel.fromJson(Map<String, dynamic> json) {
    id_tujuan = json['id_tujuan'];
    tujuan = json['tujuan'];
    tipe = json['tipe'];
  }
}