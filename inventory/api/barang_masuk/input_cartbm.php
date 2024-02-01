<?php
require_once('../../setup/koneksi.php');
if ($_POST['barang'] == '' || $_POST['jumlah'] == "0") {
    $respons = [
        'sukses' => 0,
        'message' => "Data Input tidak boleh kosong"
    ];
    echo json_encode ($respons);
} else {
    $br = $_POST['barang'];
    $jm = $_POST['jumlah'];
    $in = mysqli_query($koneksi,"INSERT INTO tmp(kode_br,jumlah,jenis) VALUES('$br','$jm','1')");
    if ($in) {
        $respons = [
            'sukses' => 1,
            'message' => "Berhasil Input keranjang masuk"
        ];
        echo json_encode($respons);
    } else {
        $respons = [
            'sukses' => 0,
            'message' => "gagal"
        ];
        echo json_encode($respons);
    } 
}