class barangkeluarmodel {
  String? foto;
  String? nama_barang;
  String? nama_brand;
  String? jumlah_keluar;
  
  barangkeluarmodel(this.foto, this.nama_barang, this.nama_brand, this.jumlah_keluar);
   barangkeluarmodel.fromJson(Map<String, dynamic> json){
    foto = json['foto'];
    nama_barang = json['nama_barang'];
    nama_brand = json['nama_brand'];
    jumlah_keluar = json['jumlah_keluar'];
  }
}