<?php
// a file to get all of the predictions made by the user
require_once '../includes/DbOperation.php';

$db = new DbOperation();

//the id of the user
$id = htmlentities($_POST["id"]);

//gets the predictions using a method in DbOperation
$returnValue = $db->getUserPredictions($id);
$returnValue["status"] = "success";
$returnValue["message"] = "here are the predictions for that user";
echo json_encode($returnValue);


$db->closeConnection()
?>