<?php
require_once('../../setup/koneksi.php');
$jenis = $_POST['jenis'];
header('Content-Type: text/xml');
$query = mysqli_query($koneksi,"INSERT INTO tbl_jenis(nama_jenis) VALUES ('$jenis')");
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
