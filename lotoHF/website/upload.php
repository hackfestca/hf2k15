<?php
header('Access-Control-Allow-Origin: http://127.0.0.1');
session_start();


# 
#if($_FILES['userfile']['type'] != "image/gif") {
# echo "Sorry, we only allow uploading GIF images";
# exit;
#}
echo $_FILES['userfile']['type']

$blacklist = array(".php", ".phtml", ".php3", ".php4");
foreach ($blacklist as $item) {
 if(preg_match("/$item\$/i", $_FILES['userfile']['name'])) {
 echo "We do not allow uploading PHP files\n";
 exit;
 }
}


$uploaddir = 'uploads/';
$uploadfile = $uploaddir . basename($_FILES['userfile']['name']);
if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
 echo "Thank you for submiting your CV.\n";
} else {
 echo "File uploading failed.\n";
}
?> 
