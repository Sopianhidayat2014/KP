<?php
require_once('../../setup/koneksi.php');
$tujuan = $_POST['tipe'];
if ($_POST['tipe'] == "Masuk") {
    $_POST['tipe'] = "M";
}elseif ($_POST['tipe'] == "keluar") {
    $_POST['tipe'] = "K";
}
$tipe = $_POST['tipe'];
header('Content-type: text/xml');
$query = mysqli_query($koneksi,"INSERT INTO tbl_tujuan(tujuan,tipe) VALUES ('$tujuan', '$tipe')");
if ($query) {
    $respons = [
        'sukses' => 1,
        'message' => "berhasil simpan"
    ];
    echo json_encode($respons);
} else {
    $respons = [
        'sukses' => 0,
        'message' => "Gagal simpan"
    ];
    echo json_encode($respons);
}