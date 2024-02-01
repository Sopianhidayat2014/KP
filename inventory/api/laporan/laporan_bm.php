<?php
require_once('../../setup/koneksi.php');
$tgl1 = $_GET['tgl1'];
$tgl2 = $_GET['tgl2'];
$query = mysqli_query($koneksi,"SELECT * FROM tbl_transaksi JOIN tbl_barang_masuk ON tbl_barang_masuk.id_barang_masuk = tbl_transaksi.id_transaksi JOIN tbl_barang ON tbl_barang_masuk.barang = tbl_barang.id_barang JOIN tbl_brand ON tbl_barang.brand = tbl_brand.id_brand WHERE tgl_transaksi BETWEEN '$tgl1' AND '$tgl2'");
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'id_barang_masuk' => $a['id_barang_masuk'],
        'id_barang' => $a['id_barang'],
        'nama_barang' => $a['nama_barang'],
        'nama_brand' => $a['nama_brand'],
        'jumlah_masuk' => $a['jumlah_masuk'],
        'tgl_transaksi' => $a['tgl_transaksi'],
        'keterangan' => $a['keterangan'],
    ];
    array_push($respons, $a);
}
echo json_encode($respons);