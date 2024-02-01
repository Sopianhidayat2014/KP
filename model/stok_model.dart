class stokmodel {
  String? no;
  String? id_barang;
  String? nama_barang;
  String? nama_jenis;
  String? nama_brand;
  String? stok;
  stokmodel(
    this.no,
    this.id_barang,
    this.nama_barang,
    this.nama_jenis,
    this.nama_brand,
    this.stok,
  );
  stokmodel.fromJson(Map<String, dynamic>json) {
    no = json['no'];
    id_barang = json['id_barang'];
    nama_barang = json['nama_barang'];
    nama_jenis = json['nama_jenis'];
    nama_brand = json['nama_brand'];
    stok = json['stok'];
  }
}