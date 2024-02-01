class laporanBKmodel {
  String? id_barang_keluar;
  String? id_barang;
  String? nama_barang;
  String? nama_brand;
  String? jumlah_keluar;
  String? tgl_transaksi;
  String? keterangan;


  laporanBKmodel(
    this.id_barang_keluar,
    this.id_barang,
    this.nama_barang,
    this.nama_brand,
    this.jumlah_keluar,
    this.tgl_transaksi,
    this.keterangan,
  );
  
  laporanBKmodel.fromJson(Map<String, dynamic>json) {
    id_barang_keluar = json['id_barang_keluar'];
    id_barang = json['id_barang'];
    nama_barang = json['nama_barang'];
    nama_brand = json['nama_brand'];
    jumlah_keluar = json['jumlah_keluar'];
    tgl_transaksi = json['tgl_transksi'];
    keterangan = json['keterangan'];
  }
}