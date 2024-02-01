<?php
require_once('../../setup/koneksi.php');
$id = $_GET['id'];
$query = mysqli_query($koneksi,"SELECT * FROM tbl_transaksi inner JOIN tbl_barang_keluar ON tbl_transaksi.id_transaksi =  tbl_barang_keluar.id_barang_keluar inner JOIN tbl_barang ON tbl_barang_keluar.barang = tbl_barang.id_barang inner JOIN tbl_brand ON tbl_barang.brand = tbl_brand.id_brand WHERE id_transaksi = '$id'");
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'foto' => $a['foto'],
        'nama_barang' => $a['nama_barang'],
        'nama_brand' => $a['nama_brand'],
        'jumlah_keluar' => $a['jumlah_keluar'],
    ];
    array_push($respons, $a);
}
echo json_encode($respons);