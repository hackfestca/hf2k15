<?php
header('Access-Control-Allow-Origin: http://127.0.0.1');
session_start();

if(!isset($_SESSION['user']) and $_SESSION['user'] =="admin" )
    exit();
$result = array();
#echo $_POST["name"];
if(!empty($_POST["name"])){
 $file = $_POST["name"];
 passthru( "ls ". $file." -al",$result);
 foreach($result as $line) {
        echo $line;
        }
}

?>
<form enctype="multipart/form-data" action="./admin.php" method="post">
    <fieldset>
        <legend>Form</legend>
            <p>
                <label>Debug List Folder :</label>
                <input name="name" type="string" />
                <input type="submit" name="submit" value="send" />
            </p>
    </fieldset>
</form>
