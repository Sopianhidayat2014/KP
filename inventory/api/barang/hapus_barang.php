<?php
require_once('../../setup/koneksi.php');
$id = $_POST['id_barang'];
$f = mysqli_query($koneksi,"SELECT foto FROM tbl_barang WHERE id_barang = '$id'");
$gambar = mysqli_fetch_array($f);
$ci = mysqli_query($koneksi,"SELECT barang FROM tbl_barang_masuk WHERE barang = '$id'");
$di = mysqli_num_rows($ci);
$co = mysqli_query($koneksi,"SELECT barang FROM tbl_barang_keluar WHERE barang = '$id'");
$do = mysqli_num_rows($co);
if ($di >= 1 || $do >= 1) {

    $respons = [
        'sukses' => 0,
        'message' => "gagal hapus!, barang ini sudah terhubung ke transaksi masuk atau keluar"

    ];
    echo json_encode($respons); 
} elseif ($id == 0 || $do == 0) {
    unlink('../../gambar/'. $gambar['foto']);
    $query = mysqli_query($koneksi,"DELETE FROM tbl_barang WHERE id_barang = '$id'");
    if ($query) {
        $delStok = mysqli_query($koneksi,"DELETE FROM tbl_stok WHERE barang = '$id'");

        $respons = [
            'sukses' => 1,
            'message' => "berhasil dihapus "
    
        ];
        echo json_encode($respons); 
    }
}
