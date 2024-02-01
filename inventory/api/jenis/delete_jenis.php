<?php

require_once('../../setup/koneksi.php');
header('Content-Type: tect/xml');
$id = $_POST['id_jenis'];
$c = mysqli_query($koneksi,"SELECT jenis FROM tbl_barang WHERE jenis = '$id'");
$d = mysqli_num_rows ($c );

if ($d >= 1) {
    $respons = [
        'sukses' => 0,
        'message' => "gagal hapus"
    ];
    echo json_encode($respons);
} elseif ($d == 0) {
    $query = mysqli_query($koneksi,"DELETE FROM tbl_jenis WHERE id_jenis = '$id'");
    if ($query) {
        $respons = [
            'sukses' => 1,
            'message' => "berhasil dihapus"
        ];
        echo json_encode($respons);
    }
}
