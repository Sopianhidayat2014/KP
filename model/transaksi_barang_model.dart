class transaksi_bm {
  String? id_transaksi;
  String? tujuan;
  String? total_item;
  String? tgl_transaksi;
  String? keterangan;
  transaksi_bm(this.id_transaksi, this.tujuan, this.total_item, this.tgl_transaksi, this.keterangan);

  transaksi_bm.fromJson(Map<String, dynamic> json) {
    id_transaksi = json['id_transaksi'];
    tujuan = json['tujuan'];
    total_item = json['total_item'];
    tgl_transaksi = json['tgl_transaksi'];
    keterangan = json['keterangan'];
  }
}