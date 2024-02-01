<?php
require_once('../../setup/koneksi.php');
$query = mysqli_query ($koneksi,"SELECT * FROM tbl_stok JOIN tbl_barang ON tbl_stok.barnag = tbl_barang.id_barang JOIN tbl_brand ON tbl_barang.brand = tbl_brand.id_brand WHERE stok!=0");
$no = 1;
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'no' => '$n',
        'id_barang' => $a['id_barang'],
        'nama_barang' => $a['nama_barang'],
        'nama_brand' => $a['nama_brand'],
    ];
        
    array_push($respons, $a);
}
echo json_encode($respons);