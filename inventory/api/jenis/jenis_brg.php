<?php

require_once('../../setup/koneksi.php');
$query = mysqli_query($koneksi,"SELECT * FROM `tbl_jenis`;");
$respons = [];
while ($a = mysqli_fetch_array($query)){
    $a = [
        'id_jenis' => $a['id_jenis'],
        'nama_jenis' => $a['nama_jenis']
    ];
    array_push($respons, $a);
}

echo json_encode($respons);