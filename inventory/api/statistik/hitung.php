<?php
require_once('../../setup/koneksi.php');
$ks = mysqli_query($koneksi,"SELECT SUM(stok) AS ts FROM tbl_stok");
$ds = mysqli_fetch_array($ks);
$kbm = mysqli_query($koneksi,"SELECT SUM(jumlah_masuk) AS tbm FROM tbl_barang_masuk");
$qbm = mysqli_fetch_array($kbm);
$kbk = mysqli_query($koneksi,"SELECT SUM(jumlah_keluar) AS tbk FROM tbl_barang_keluar");
$qbk = mysqli_fetch_array($kbk);
$respons = [];
$a = [
    'stok' => $ds['ts'],
    'jm' => $qbm['tbm'],
    'jk' => $qbk['tbk'],
];
array_push($respons, $a);
echo json_encode($respons);
 