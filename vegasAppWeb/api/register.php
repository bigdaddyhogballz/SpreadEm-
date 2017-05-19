<?php

//creating response array
// code from https://www.simplifiedios.net/swift-php-mysql-tutorial/
$response = array();

if($_SERVER['REQUEST_METHOD']=='POST'){

    //getting values
    $userName = $_POST['name'];
    $userPassword = $_POST['password'];

    //including the db operation file
    require_once '../includes/DbOperation.php';

    $db = new DbOperation();

    //inserting values
    if($db->register($userName,$userPassword)){
        $response['error']=false;
        $response['message']='User added successfully';
    }else{

        $response['error']=true;
        $response['message']='Could not add User';
    }

}else{
    $response['error']=true;
    $response['message']='You are not authorized';
}
echo json_encode($response);