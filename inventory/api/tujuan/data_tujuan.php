<?php

require_once('../../setup/koneksi.php');
$query = mysqli_query($koneksi,"SELECT * FROM tbl_tujuan");
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'id_tujuan'=> $a['id_tujuan'],
        'tujuan'=> $a['tujuan'],
        'tipe'=> $a['tipe'],
    ];
    array_push($respons, $a);
}
echo json_encode($respons);