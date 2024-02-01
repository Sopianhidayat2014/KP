class URL {
  static String url = "http://192.168.34.101/inventory/api/";
  static String path = "http://192.168.34.101/inventory/gambar/";

  //api jenis
  static String urldatajenis = url + "jenis/jenis_brg.php";
  static String urltambahjenis = url + "jenis/tambah_jenis.php";
  static String urleditjenis = url + "jenis/edit_jenis.php";
  static String urlhapusjenis = url + "jenis/delete_jenis.php";

  //api brand
  static String urldatabrand = url + "brand/brand_brg.php";
  static String urlhapusbrand = url + "brand/delete_brand.php";
  static String urleditbrand = url + "brand/edit_brand.php";
  static String urltambahbrand = url + "brand/tambah_brand.php";

  //api barang
  static String urldatabarang = url + "barang/data_barang.php";
  static String urlhapusbarang = url + "barang/hapus_barang.php";
  static String urleditbarang = url + "barang/update_barang.php";
  static String urltambahbarang = url + "barang/input_barang.php";

  //api tujuan
  static String urldatatujuan = url + "tujuan/data_tujuan.php";
  static String urlhapustujuan = url + "tujuan/hapus_tujuan.php";
  static String urledittujuan = url + "tujuan/update_tujuan.php";
  static String urltambahtujuan = url + "tujuan/input_tujuan.php";
  static String urltujuanbm = url + "tujuan/tujuan_bm.php";
  static String urltujuanbk = url + "tujuan/tujuan_bk.php";
  
  //api transaksi tambah barang masuk
  static String urltransaksibm = url + "barang_masuk/transaksi_bm.php";
  static String urlhapusbm = url + "barang_masuk/hapus_bm.php";
  static String urlbabm = url + "laporan/ba_bm.php?id=";
  static String urldetailbm = url + "barang_masuk/data_barang_masuk.php?id=";
  static String urlcartbm = url + "barang_masuk/cart_bm.php";
  static String urlhapuscbm = url + "barang_masuk/hapus_chartbm.php";
  static String urlinputcbm = url + "barang_masuk/input_cartbm.php";
  static String urltambahbm = url + "barang_masuk/input_bm.php";
  
  //api transaksi tambah barang keluar
  static String urltransaksibk = url + "barang_keluar/transaksi_bk.php";
  static String urlhapusbk = url + "barang_keluar/hapus_bk.php";
  static String urlbabk = url + "laporan/ba_bk.php?id=";
  static String urldetailbk = url + "barang_keluar/data_barang_keluar.php?id=";
  static String urlcartbk = url + "barang_keluar/cart_bk.php";
  static String urldatabk = url + "barang_keluar/data_bk.php";
  static String urlhapuscbk = url + "barang_keluar/hapus_cartbk.php";
  static String urlinputcbk = url + "barang_keluar/input_cartbk.php";
  static String urltambahbk = url + "barang_keluar/input_bk.php";
 
  //api laporan
  static String urllaporanBM = url + "laporan/laporan_bm.php";
  static String urllaporanBK = url + "laporan/laporan_bk.php";
  
  //api stok
  static String urlstokbarang = url + "stok/data_stok.php";

  //api statistik
  static String urlhitung = url + "statistik/hitung.php";
}
