<?php
//gets the leaderboards
require_once '../includes/DbOperation.php';

$db = new DbOperation();
//gets the getTopScores() functions results from DbOperation
$returnValue = $db->getTopScores();
$returnValue["status"] = "success";
$returnValue["message"] = "here are the top scores";
echo json_encode($returnValue);


$db->closeConnection()
?>