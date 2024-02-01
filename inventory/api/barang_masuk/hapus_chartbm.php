<?php
require_once('../../setup/koneksi.php');
$id = $_POST['id'];
$query = mysqli_query($koneksi,"DELETE FROM tmp WHERE id_tmp = '$id'");
if ($query) {
    $respons = [
        'sukses' => 1,
        'message' => "berhasil hapus"
    ];
    echo json_encode($respons);
}else {
    $respons = [
        'sukses' => 0,
        'message' => "gagal hapus"
    ];
    echo json_encode($respons);
}