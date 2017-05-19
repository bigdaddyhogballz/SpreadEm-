
<?php
// Code modified originally from Sat Garcia
require_once '../includes/DbOperation.php';

$db = new DbOperation();
$today = date("c");

$opts = array(
    'http'=>array(
        'method'=>"GET",
        'header'=>"JsonOdds-API-Key: 7a6e5354-3121-11e7-b6b0-0afc106a1b07\r\n"
    )
);

$context = stream_context_create($opts);

// Open the file using the HTTP headers set above
$file = file_get_contents('https://jsonodds.com/api/odds/nba?source=3', false, $context);

// Decode the JSON response, putting it in an associative PHP array of games
$odds = json_decode($file, true);

// Debugging: print out the odds data we decoded

var_dump($today);
$passYear = substr($today, 0, 4);
$passMonth = substr($today, 5, 2);
$passDay = substr($today, 8, 2);


$numGames = count($odds);
var_dump($numGames);

//hash function for unique ids
function djb_hash($str) {
    for ($i = 0, $h = 5381, $len = strlen($str); $i < $len; $i++) {
        $h = (($h << 5) + $h + ord($str[$i])) & 0x7FFFFFFF;
    }
    return $h;
}
//loop through the array
for( $i = 0; $i<$numGames; $i++ )
{
    $matchString = $odds[$i]["MatchTime"];
    $strLength = count($matchString);
    $year = substr($matchString, 0, 4); // returns 2017
    $month = substr($matchString, 5, 2); // returns 2017
    $day = substr($matchString, 8, 2);
    $time = substr($matchString, 10, 8);

    $date = $year . "-" . $month . "-" . $day;

    //if($year == $passYear && $month ==$passMonth && $passDay == $day)
  //  {
    //get the data for the games
        $a = djb_hash($odds[$i]["ID"]);
        var_dump($odds[$i]["ID"]);
        var_dump($a);
        var_dump($odds[$i]["HomeTeam"]);
        var_dump($odds[$i]["AwayTeam"]);
        var_dump($odds[$i]["MatchTime"]);
        var_dump($odds[$i]["Odds"]["0"]["PointSpreadHome"]);
        $returnValue = $db->getGame($a);
        $actual = null;
        $completed = 0;
        //if it doesnt exist in the sql table then add a new game
        if($returnValue == null)
        {
            $b = $db->addGame($a,$date,$odds[$i]["HomeTeam"],$odds[$i]["AwayTeam"],$time, $odds[$i]["Odds"]["0"]["PointSpreadHome"], $actual, $completed);
            var_dump("game successfully added");
        }
 //   }
}

$db->closeConnection()




?>