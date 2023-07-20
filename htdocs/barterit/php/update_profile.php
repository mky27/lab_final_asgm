<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['id'];
$user_name = $_POST['name'];
$user_email = $_POST['email'];
$user_phone = $_POST['phone'];
$user_password = sha1($_POST['password']);

$sqlupdate = "UPDATE `tbl_users` SET `user_name`='$user_name',`user_email`='$user_email',`user_phone`='$user_phone',`user_password`='$user_password' WHERE `user_id` = '$userid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>