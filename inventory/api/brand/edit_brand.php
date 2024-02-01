<?php

require_once('../../setup/koneksi.php');
header('Content-Type: tect/xml');
$id = $_POST['id_brand'];
$brand = $_POST['brand'];
$query = mysqli_query($koneksi,"UPDATE tbl_brand SET nama_brand ='$brand' WHERE id_brand = '$id'");

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