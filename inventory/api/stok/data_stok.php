<?php
require_once('../../setup/koneksi.php');
$query = mysqli_query($koneksi,"SELECT * FROM tbl_stok JOIN tbl_barang ON tbl_stok.barang = tbl_barang.id_barang JOIN tbl_jenis ON tbl_barang.jenis = tbl_jenis.id_jenis JOIN tbl_brand ON tbl_barang.brand = tbl_brand.id_brand");
$no = 1;
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $n = $no++;
    $a = [
        'no' => "$n",
        'id_barang' => $a['id_barang'],
        'nama_barang' => $a['nama_barang'],
        'nama_jenis' => $a['nama_jenis'],
        'nama_brand' => $a['nama_brand'],
        'stok' => $a['stok']
    ];
    array_push($respons, $a);
}
echo json_encode($respons);