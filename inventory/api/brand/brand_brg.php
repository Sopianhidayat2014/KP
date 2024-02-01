<?php

require_once('../../setup/koneksi.php');
$query = mysqli_query($koneksi,"SELECT * FROM `tbl_brand`;");
$respons = [];
while ($l = mysqli_fetch_array($query)){
    $l = [
        'id_brand' => $l['id_brand'],
        'nama_brand' => $l['nama_brand']
    ];
    array_push($respons, $l);
}

echo json_encode($respons);