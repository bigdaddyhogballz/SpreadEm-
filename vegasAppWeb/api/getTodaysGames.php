<?php

require_once '../includes/DbOperation.php';


// a file to get the games of a certain date
$db = new DbOperation();

//date passed in
$today = htmlentities($_POST["date"]);

// calls getTodaysGames in the DbOperation.php
$returnValue = $db->getTodaysGames($today);


//returns the games
if(!empty($userDetails))
{
    $returnValue["status"] = "Success";
    $returnValue["message"] = "There are Games Today";
    echo json_encode($returnValue);
} else {

    $returnValue["status"] = "error";
    $returnValue["message"] = "There are no games on this day";
    echo json_encode($returnValue);
}

$db->closeConnection()
?>