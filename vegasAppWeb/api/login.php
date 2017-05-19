

<?php
//a file to check login information
require '../includes/DbOperation.php';
$email = htmlentities($_POST["name"]);
$password = htmlentities($_POST["password"]);
$returnValue = array();
//doesnt do anything if the login is missing a field
if(empty($email) || empty($password))
{
    $returnValue["status"] = "error";
    $returnValue["message"] = "Missing required field";
    echo json_encode($returnValue);
    return;
}

$secure_password = md5($password);
//gets the user info checks to see that it exists with both fields
$dao = new DbOperation();
$userDetails = $dao->getUserDetailsWithPassword($email,$password);

if(!empty($userDetails))
{
    $returnValue["status"] = "Success";
    $returnValue["message"] = "User is registered";
    echo json_encode($returnValue);
} else {

    $returnValue["status"] = "error";
    $returnValue["message"] = "User is not found";
    echo json_encode($returnValue);
}

$dao->closeConnection();

?>