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
    $get_stok = mysqli_query($koneksi,"SELECT stok FROM tbl_stok WHERE barang = '$br'");
    $dstok = mysqli_fetch_array($get_stok);
    if ($jm > $dstok['stok']) {
        $respons = [
            'sukses' => 0,
            'message' => "Jumlah lebih besar dari stok"
        ];
        echo json_encode($respons);
    }else {
        $in = mysqli_query($koneksi,"INSERT INTO tmp(kode_br,jumlah,jenis) VALUES('$br','$jm','2')");
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
}