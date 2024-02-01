<?php

require_once('../../setup/koneksi.php');
header('Content-Type: tect/xml');
$id = $_POST['id_jenis'];
$jenis = $_POST['jenis'];
$query = mysqli_query($koneksi,"UPDATE tbl_jenis SET nama_jenis ='$jenis' WHERE id_jenis = '$id'");

if($query){
    $respons = [
        'succes' => 1,
        'message' => "berhasil update"
    ];

    echo json_encode($respons);
} else {
    $respons = [
        'succes' => 0,
        'message' => "gagal edit"
    ];

    echo json_encode($respons); 
}