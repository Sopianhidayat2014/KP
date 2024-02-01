<?php
require_once('../../setup/koneksi.php');
$query = mysqli_query ($koneksi,"SELECT * FROM tbl_transaksi inner JOIN tbl_tujuan ON tbl_transaksi.jenis_transaksi = tbl_tujuan.id_tujuan WHERE tbl_transaksi.tipe='M'");
$respons = [];
while ($a = mysqli_fetch_array($query)) {
    $a = [
        'id_transaksi' => $a['id_transaksi'],
        'tujuan' => $a['tujuan'],
        'total_item' => $a['total_item'],
        'tgl_transaksi' => $a['tgl_transaksi'],
        'keterangan' => $a['keterangan']
    ];
    array_push($respons, $a);
}
echo json_encode ($respons);