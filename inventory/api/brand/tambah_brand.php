<?php
require_once('../../setup/koneksi.php');
$brand = $_POST['brand'];
header('Content-Type: text/xml');
$query = mysqli_query($koneksi,"INSERT INTO tbl_brand(nama_brand) VALUES ('$brand')");
if ($query) {
    $respons = [
        'success' => 1,
        'message' => "berhasil simpan"
    ];
    echo json_encode($respons);
} else {
    $respons = [
        'succes' => 0,
        'message' => "gagal simpan"
    ];
    echo json_encode($respons);
}