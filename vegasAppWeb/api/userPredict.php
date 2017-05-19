<?php

//code for user making a prediction
$response = array();

if($_SERVER['REQUEST_METHOD']=='POST'){

    //getting values for prediction
    $userId = $_POST['userId'];
    $gameId = $_POST['gameId'];
    $guess = $_POST['guess'];


$returnValue = array();

//including the db operation file
require_once '../includes/DbOperation.php';

$db = new DbOperation();

//inserting values
if($db->makePredictions($userId,$gameId,$guess)){
    $response['error']=false;
    $response['message']='prediction made successfully';
}else{

    $response['error']=true;
    $response['message']='Could not make prediction';
}

}else{
    $response['error']=true;
    $response['message']='You are not authorized';
}
echo json_encode($response);