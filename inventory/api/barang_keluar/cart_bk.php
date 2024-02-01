<?php
require_once('../../setup/koneksi.php');
$query = mysqli_query($koneksi,"SELECT * FROM tmp JOIN tbl_barang ON tmp.kode_br=tbl_barang.id_barang JOIN tbl_brand ON tbl_barang.brand = tbl_brand.id_brand WHERE tmp.jenis=2");
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'id_tmp' => $a['id_tmp'],
        'id_barang' => $a['id_barang'],
        'foto' => $a['foto'],
        'nama_barang' => $a['nama_barang'],
        'nama_brand' => $a['nama_brand'],
        'jumlah' => $a['jumlah']
    ];
    array_push($respons, $a);
}
echo json_encode($respons);