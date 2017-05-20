<?php

/*
 * A class to deal with all operands to and from the SQL servers
 */
class DbOperation
{
    private $conn;

    var $dbhost = null;
    var $dbuser = null;
    var $dbpass = null;
    var $dbname = null;
    var $result = null;


    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DbConnect.php';


        // opening db connection
        $db = new DbConnect();
        $this->conn = $db->connect();

    }

    //Function to create a new user
    public function register($name, $pass)
    {
        // the sql query statement
        $stmt = $this->conn->prepare("INSERT INTO users(name, password) values(?, ?)");
        $stmt->bind_param("ss", $name, $pass);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }

    }
    //Function to create a new game
    public function addGame($id, $date,$home,$away,$time,$line, $actual, $completed)
    {
        $stmt = $this->conn->prepare("INSERT INTO games(ID, Date, Home, Away, Time, Line, Actual, completed) values(?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("isssiiii", $id, $date, $home, $away, $time, $line, $actual, $completed);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }

    }
    //function to get a specific game with given id
    public function getGame($id)
    {
        $returnValue = array();
        $sql = "select * from games where id='" . $id . "'";

        $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnValue = $row;
            }
        }
        return $returnValue;
    }

    public function makePredictions($userId, $gameId, $guess)
    {
        $stmt = $this->conn->prepare("INSERT INTO predictions(userId, gameId, guess) values(?, ?, ?)");
        $stmt->bind_param("iis", $userId, $gameId, $guess);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }

    }
    // gets the connection
    public function getConnection() {
        return $this->conn;
    }
    //closes the connection
    public function closeConnection() {
        if ($this->conn != null)
            $this->conn->close();
    }
    //gets the information on a specific user with a username
    public function getUserDetails($email)
    {
        $returnValue = array();
        $sql = "select * from users where name='" . $email . "'";

        $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnValue = $row;
            }
        }
        return $returnValue;
    }

//sets the reuslt of a game
    public function setFinal($id, $actual)
    {
        $returnValue = array();
        $sql = "UPDATE games SET completed = 1, scored = 1, Actual =$actual  WHERE id=$id";

        $result = $this->conn->query($sql);
        return $returnValue;
    }
    //sets the score of a prediction
    public function scorePrediction($id, $score)
    {
        $returnValue = array();
        $sql = "UPDATE predictions SET scored = 1, score =$score  WHERE ID=$id";

        $result = $this->conn->query($sql);
        return $returnValue;
    }
    //sets the score of the user
    public function setUserScore($id, $score)
    {
        $returnValue = array();
        $sql = "UPDATE users SET score =$score  WHERE id=$id";

        $result = $this->conn->query($sql);
        return $returnValue;
    }
//gets predections for that game
    public function getPredictions($gameId)
    {
        $returnValue = array();
        $sql = "select * from predictions where gameId= $gameId";

        $result = $this->conn->query($sql);
        $resultArray = array();
        // Loop through each row in the result set
        while($row = $result->fetch_object())
        {
            // Add each row into our results array
            $tempArray = $row;
            array_push($resultArray, $tempArray);
        }

        //Finally, encode the array to JSON and output the results
        return $resultArray;
    }
    //gets all the predictions for a specific userid
    public function getUserPredictions($id)
    {
        $returnValue = array();
        $sql = "select * from predictions where userId= $id";

        $result = $this->conn->query($sql);
        $resultArray = array();
        // Loop through each row in the result set
        while($row = $result->fetch_object())
        {
            // Add each row into our results array
            $tempArray = $row;
            array_push($resultArray, $tempArray);
        }

        //Finally, encode the array to JSON and output the results
        return $resultArray;
    }

    //gets the score of a user given a specific id
    public function getUserScore($iD)
    {
        $returnValue = array();
        $sql = "select score from users where id= $iD";

        $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnValue = $row;
            }
        }
        return $returnValue;
    }
    
    
//gets the games with a given string date
    public function getTodaysGames($date)
    {
        $sql = "select * from games where Date='" . $date . "'";


        $result = $this->conn->query($sql);
        $resultArray = array();
        // Loop through each row in the result set
        while($row = $result->fetch_object())
        {
            // Add each row into our results array
            $tempArray = $row;
            array_push($resultArray, $tempArray);
        }

         //Finally, encode the array to JSON and output the results
        return $resultArray;
    }
    //gets the top 10 users and their scores
    public function getTopScores()
    {
        $sql = "select name,score from users ORDER BY score DESC LIMIT 10";


        $result = $this->conn->query($sql);
        $resultArray = array();
        // Loop through each row in the result set
        while($row = $result->fetch_object())
        {
            // Add each row into our results array
            $tempArray = $row;
            array_push($resultArray, $tempArray);
        }

        //Finally, encode the array to JSON and output the results
        return $resultArray;
    }
    //gets user infomation given a username
    public function getUserInfo($email)
    {
        $sql = "select * from users where name='" . $email . "'";


        $result = $this->conn->query($sql);
        $resultArray = array();
        // Loop through each row in the result set
        while($row = $result->fetch_object())
        {
            // Add each row into our results array
            $tempArray = $row;
            array_push($resultArray, $tempArray);
        }

        //Finally, encode the array to JSON and output the results
        return $resultArray;
    }

    //gets the user info with username and password
    public function getUserDetailsWithPassword($email, $userPassword)
    {
        $returnValue = array();
        $sql = "select id,name from users where name='" . $email . "' and password='" .$userPassword . "'";

        $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
            if (!empty($row)) {
                $returnValue = $row;
            }
        }
        return $returnValue;
    }

}