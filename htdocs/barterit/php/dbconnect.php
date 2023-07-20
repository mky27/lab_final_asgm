<?php
$servername = "localhost";
$username   = "mikeyong_barterituser";
$password   = "j9DMK3MIqf?2";
$dbname     = "mikeyong_barterit";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
