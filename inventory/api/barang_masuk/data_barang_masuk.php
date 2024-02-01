<?php
require_once('../../setup/koneksi.php');
$id = $_GET['id'];
$query = mysqli_query($koneksi,"SELECT * FROM tbl_transaksi inner JOIN tbl_barang_masuk ON tbl_transaksi.id_transaksi = tbl_barang_masuk.id_barang_masuk inner JOIN tbl_barang ON tbl_barang_masuk.barang = tbl_barang.id_barang inner JOIN tbl_brand ON tbl_barang.brand = tbl_brand.id_brand WHERE id_transaksi = '$id'");
$respon = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'foto' => $a['foto'],
        'nama_barang' => $a['nama_barang'],
        'nama_brand' => $a['nama_brand'],
        'jumlah_masuk' => $a['jumlah_masuk'],
    ];
    array_push($respon, $a);
}
echo json_encode($respon);