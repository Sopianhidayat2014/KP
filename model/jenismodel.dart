class jenismodel{
  String? id_jenis;
  String? nama_jenis;
  jenismodel(this.id_jenis, this.nama_jenis);
  jenismodel.fromJson(Map<String, dynamic>json) {
    id_jenis = json['id_jenis'];
    nama_jenis = json['nama_jenis'];
  }
}