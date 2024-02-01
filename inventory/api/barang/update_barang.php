<?php
require_once('../../setup/koneksi.php');
$id = $_POST['id_barang'];
$nama = $_POST['nama'];
$brand = $_POST['brand'];
$jenis = $_POST['jenis'];
$f = mysqli_query($koneksi,"SELECT foto FROM tbl_barang WHERE id_barang = '$id'");
$img = mysqli_fetch_array($f);
if (!isset($_FILES['foto']['name'])) {
    $query = mysqli_query($koneksi,"UPDATE tbl_barang SET nama_barang = '$nama', brand = '$brand', jenis = '$jenis' WHERE id_barang = '$id'");
    if ($query) {
        $respons = [
            'sukses' => 1,
            'message' => "berhasil update"
    
        ];
        echo json_encode($respons); 
    } else {
        $respons = [
            'sukses' => 0,
            'message' => "gagal update"
    
        ];
        echo json_encode($respons); 
    }
} elseif (isset($_FILES['foto']['name'])) {
    $rand = rand();
    $ekstensi = ['png','jpg','jpeg'];
    $ukuran = $_FILES['foto']['size'];
    $filename = str_replace(" ","",$_FILES['foto']['name']);
    $ext = pathinfo($filename, PATHINFO_EXTENSION);
    $img = $rand.$filename;
    $path = "../../gambar/" . $img;
    if (!in_array($ext,$ekstensi)) {
        $respons = [
            'sukses' => 0,
            'message' => "file tidak cocok"
    
        ];
        echo json_encode($respons); 
    }
}else{
    if($ukuran < 1044070) {
        unlink('../../gambar/' . $img['foto']);
        move_uploaded_file($_FILES['foto']['tmp_name'], $path);
        $query = mysqli_query($koneksi,"UPDATE tbl_barang SET nama_barang = '$nama', foto = '$img', brand = '$brand', jenis = '$jenis' WHERE id_barang = '$id'");
        if ($query) {
            $respons = [
                'sukses' => 1,
                'message' => "berhasil update"
        
            ];
            echo json_encode($respons); 
        }else {
            $respons = [
                'sukses' => 0,
                'message' => "gagal update"
        
            ];
            echo json_encode($respons); 
        }
    }else{
        $respons = [
            'sukses' => 0,
            'message' => "file terlalu besar"
    
        ];
        echo json_encode($respons); 
    }
    
}