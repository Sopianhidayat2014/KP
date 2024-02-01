<?php
require_once('../../setup/koneksi.php');
date_default_timezone_set('asia/jakarta');
if ($_POST['ket'] == '') {
    $respons = [
        'sukses' => 0,
        'message' => "Data Input tidak boleh kosong"
    ];
    echo json_encode($respons);
}else {
    $tujuan = $_POST['tujuan'];
    $ket = $_POST['ket'];
    $qs = mysqli_query($koneksi,"SELECT * FROM tmp WHERE jenis = 2");
    $query = mysqli_query($koneksi,"SELECT MAX(id_barang_keluar) AS max_code FROM tbl_barang_keluar");
    $data = mysqli_fetch_array($query);
    $a = $data['max_code'];
    $urut = (int)substr($a,2,3);
    $urut++;
    $id = "BK".sprintf("%03s",$urut);
    $tgl = date('Y-m-d');
    while ($c = mysqli_fetch_array($qs)) {
        mysqli_query($koneksi,"INSERT INTO tbl_barang_keluar(id_barang_keluar,barang,jumlah_keluar) VALUES('$id','$c[kode_br]','$c[jumlah]')");
        $qstok = mysqli_query($koneksi,"SELECT * FROM tbl_stok WHERE barang = '$c[kode_br]'");
        $x = mysqli_fetch_array($qstok);
        $stok = $x['stok'] - $c['jumlah'];
        $ups = mysqli_query($koneksi,"UPDATE tbl_stok SET stok = '$stok' WHERE barang = '$c[kode_br]'");
        
    }
    $sum = mysqli_query($koneksi,"SELECT SUM(jumlah_keluar) AS sm FROM tbl_barang_keluar WHERE id_barang_keluar = '$id'");
    $m = mysqli_fetch_array($sum);
    $transaksi = mysqli_query($koneksi,"INSERT INTO tbl_transaksi (id_transaksi,jenis_transaksi,keterangan,total_item,tgl_transaksi,tipe)VALUES('$id','$_POST[tujuan]','$_POST[ket]','$m[sm]','$tgl','K')");
    mysqli_query($koneksi,"DELETE FROM tmp WHERE jenis = 2");
    if ($transaksi) {
        $respons = [
            'sukses' => 1,
            'message' => "Berhasil input barang keluar"
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