<?php
/**
 * Created by PhpStorm.
 * User: johngraybll
 * Date: 4/2/17
 * Time: 9:47 PM
 * a function to get the user information given a username
 */
require_once '../includes/DbOperation.php';

$db = new DbOperation();

//the username
$name = htmlentities($_POST["name"]);

$returnValue = $db->getUserInfo($name);

if(!empty($returnValue))
{
    $returnValue["status"] = "Success";
    $returnValue["message"] = "User info is available";
    echo json_encode($returnValue);
} else {

    $returnValue["status"] = "error";
    $returnValue["message"] = "There is no user by that name";
    echo json_encode($returnValue);
}

$db->closeConnection()
?>