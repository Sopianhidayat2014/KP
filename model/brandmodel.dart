class brandmodel{
  String? id_brand;
  String? nama_brand;
  brandmodel(this.id_brand, this.nama_brand);
  brandmodel.fromJson(Map<String, dynamic>json) {
    id_brand = json['id_brand'];
    nama_brand = json['nama_brand'];
  }
}