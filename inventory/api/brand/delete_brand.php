<?php

require_once('../../setup/koneksi.php');
header('Content-Type: tect/xml');
$id = $_POST['id_brand'];
$t = mysqli_query($koneksi,"SELECT brand FROM tbl_barang WHERE brand = '$id'");
$e = mysqli_num_rows ($t );

if ($e >= 1) {
    $respons = [
        'sukses' => 0,
        'message' => "gagal hapus"
    ];
    echo json_encode($respons);
} elseif ($e == 0) {
    $query = mysqli_query($koneksi,"DELETE FROM tbl_brand WHERE id_brand = '$id'");
    if ($query) {
        $respons = [
            'sukses' => 1,
            'message' => "berhasil dihapus"
        ];
        echo json_encode($respons);
    }
}