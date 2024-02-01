<?php
require_once('../../setup/koneksi.php');
header('Content-type: text/xml');
$id = $_POST['id_tujuan'];
$tujuan = $_POST['tujuan'];
if ($_POST['tipe'] == "Masuk") {
    $_POST['tipe'] = "M";
}elseif ($_POST['tipe'] == "keluar") {
    $_POST['tipe'] = "K";
}

$tipe = $_POST['tipe'];
$query = mysqli_query($koneksi,"UPDATE tbl_tujuan SET tujuan = '$tujuan', tipe = '$tipe' WHERE id_tujuan = '$id'");
if ($query) {
    $respons = [
        'sukses' => 1,
        'message' => "berhasil berhasil update"
    ];
    echo json_encode($respons);
} else {
    $respons = [
        'sukses' => 0,
        'message' => "gagal update"
    ];
    echo json_encode($respons);
}