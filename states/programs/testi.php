<?php
echo "Hello World!";
// (c) 2016 Tero Karvinen http://TeroKarvinen.com

$user='koirat';
$password='koirat';
$database=$user;
$dsn="mysql:host=localhost;charset=UTF8;dbname=$database";
$pdo=new PDO($dsn, $user, $password);
$pdoStatement=$pdo->prepare('SELECT * FROM model;');
$pdoStatement->execute();
$hits=$pdoStatement->fetchAll();
foreach($hits as $row) {
echo "<p>".$row['rotu']."</p>\n";
}


?>
