<?php
require_once('../../setup/koneksi.php');
$query = mysqli_query ($koneksi,"SELECT * FROM tbl_barang JOIN tbl_jenis ON tbl_barang.jenis = tbl_jenis.id_jenis JOIN tbl_brand ON tbl_barang.brand = tbl_brand.id_brand");
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'id_barang' => $a['id_barang'],
        'nama_barang' => $a['nama_barang'],
        'nama_jenis' => $a['nama_jenis'],
        'nama_brand' => $a['nama_brand'],
        'foto' => $a['foto'],
        'id_jenis' => $a['id_jenis'],
        'id_brand' => $a['id_brand'],
    ];
        
    array_push($respons, $a);
}
echo json_encode($respons);