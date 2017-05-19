<?php
// Create a stream
//Code by sat garcia modified by John Graybill
//This code scores the games that get updated
require_once '../includes/DbOperation.php';

$db = new DbOperation();
$opts = array(
    'http'=>array(
        'method'=>"GET",
        'header'=>"JsonOdds-API-Key: 7a6e5354-3121-11e7-b6b0-0afc106a1b07\r\n"
    )
);

$context = stream_context_create($opts);

// Open the file using the HTTP headers set above
$file = file_get_contents('https://jsonodds.com/api/results/nba', false, $context);

// Decode the JSON response, putting it in an associative PHP array this is the array of games that are finished
$odds = json_decode($file, true);

// Debugging: print out the odds data we decoded
//var_dump($odds);

$numGames = count($odds);
var_dump($numGames);
//converts string to a unique ID
function djb_hash($str) {
    for ($i = 0, $h = 5381, $len = strlen($str); $i < $len; $i++) {
        $h = (($h << 5) + $h + ord($str[$i])) & 0x7FFFFFFF;
    }
    return $h;
}
//sort through all games finished
for( $i = 0; $i<$numGames; $i++ ) {
    //if they are games and are the final type so theya re completely finished
    if ($odds[$i]["OddType"] == "Game" && $odds[$i]["Final"] == true) {
        $id = djb_hash($odds[$i]["ID"]);
        var_dump($id);
        var_dump($odds[$i]["HomeScore"]);
        var_dump($odds[$i]["AwayScore"]);
        var_dump($odds[$i]["OddType"]);

        //get the total score difference
        $actual = $odds[$i]["AwayScore"] - $odds[$i]["HomeScore"];

        $result = $db->getGame($id);
        //cehck to see if this game is in the database
        if ($result != null) {

            $change = $db->setFinal($id, $actual);
            $predictions = $db->getPredictions($id);


            $numPredictions = count($predictions);
            //if it is then get all the predictions made for that game if there are any
            if ($predictions != null) {
                for ($z = 0; $z < $numPredictions; $z++) {
                    $pArray = (array)$predictions[$z];
                    //get variables for the predictions
                    $uId = $pArray["userId"];
                    $guess = $pArray["guess"];
                    $pId = $pArray["ID"];
                    $scoredInt = $pArray["scored"];

                    var_dump($result);
                    $line = $result["Line"];
                    //if prediction not scored then we score it
                    if ($scoredInt == 0) {
                        //get absolute values to see which is closer, line or guess
                        $d1 = abs($actual - $guess);
                        $d2 = abs($actual - $line);
                        //base score of 100
                        $base = 100;
                        //distance between guess and line
                        $dist = abs($d2 - $d1);

                        //scoring loop to see how much we add or subtract
                        $extra = 0;
                        for ($c = 0; $c < $dist; $c++) {
                            if ($c < 3) {
                                $extra = $extra + 20;
                            } else if ($c < 5) {
                                $extra = $extra + 30;
                            } else if ($c < 7) {
                                $extra = $extra + 40;
                            } else {
                                $extra = $extra + 50;
                            }


                        }
                        $total = 0;
                        //see which is closer,then add or subtract
                        if ($d1 < $d2) {
                            $total = $base + $extra;
                        } else {
                            $total = $base - $extra;
                        }
                        //set the score of the prediction
                        $scoring = $db->scorePrediction($pId, $total);
                        //get the score of the user
                        $userScore = $db->getUserScore($uId);

                        var_dump($userScore);
                        var_dump($total);

                        var_dump($userScore);
                        //convert user score to a number
                        $intUScore = 1 * $userScore["score"];
                        //add the new prediction to total score
                        $newUserScore = $total + $intUScore;

                        var_dump($newUserScore);
                        //update the user score
                        $updatedUserScore = $db->setUserScore($uId, $newUserScore);

                    }
                }
            }
        }
    }
}



?>