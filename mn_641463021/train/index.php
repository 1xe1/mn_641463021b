<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT"); // Include PUT method
header("Access-Control-Allow-Headers: *");
include "../conn.php"; // Include your database connection file

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // Return a 200 OK response for the preflight request
    http_response_code(200);
    exit();
}

// Handle different HTTP methods
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Retrieve train data
        getTrains();
        break;
    case 'POST':
        // Add a new train
        addTrain();
        break;
    case 'PUT':
        // Update an existing train
        updateTrain();
        break;
    case 'DELETE':
        // Delete a train
        deleteTrain();
        break;
    default:
        // Unsupported method
        http_response_code(405); // Method Not Allowed
        echo json_encode(array('message' => 'Unsupported HTTP method'));
        break;
}

function getTrains() {
    global $conn;

    $sql = "SELECT * FROM train WHERE statusDelete='0'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $trains = array();
        while ($row = $result->fetch_assoc()) {
            $trains[] = $row;
        }
        echo json_encode($trains);
    } else {
        echo json_encode(array('message' => 'No trains found.'));
    }
}

function addTrain() {
    global $conn;

    // Assuming JSON data is sent in the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['TrainNumber'])) {
        $trainNumber = $data['TrainNumber'];

        $sql = "SELECT MAX(TrainID) AS MAX_ID FROM train";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $maxID = intval($row['MAX_ID']) + 1;
            

        // Insert the new train
        $insertSql = "INSERT INTO train (TrainID, TrainNumber) VALUES ('$maxID', '$trainNumber')";

        if ($conn->query($insertSql) === TRUE) {
            // Explicitly set HTTP status code to 200
            http_response_code(200);
            echo json_encode(array('message' => 'Train added successfully.'));
        } else {
            // Explicitly set HTTP status code to 500 for server error
            http_response_code(500);
            echo json_encode(array('message' => 'Error adding train: ' . $conn->error));
        }
    } else {
        // Explicitly set HTTP status code to 400 for bad request
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. TrainNumber is required.'));
    }
}

function updateTrain() {
    global $conn;

    // Parsing JSON data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['TrainID']) && isset($data['TrainNumber'])) {
        $trainID = $data['TrainID'];
        $trainNumber = $data['TrainNumber'];

        // Update the train
        $updateSql = "UPDATE train SET TrainNumber='$trainNumber' WHERE TrainID='$trainID'";

        if ($conn->query($updateSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Train updated successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error updating train: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. TrainID and TrainNumber are required.'));
    }
}

function deleteTrain() {
    global $conn;

    // Parsing JSON data from the request body
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['TrainID'])) {
        $trainID = $data['TrainID'];

        // Deleting the train from the database
        // $deleteSql = "DELETE FROM train WHERE TrainID='$trainID'";
        $deleteSql = "UPDATE train SET statusDelete='1' WHERE TrainID='$trainID'";
        if ($conn->query($deleteSql) === TRUE) {
            // Setting HTTP status code to 200 for success
            http_response_code(200);
            echo json_encode(array('message' => 'Train deleted successfully.'));
        } else {
            // Setting HTTP status code to 500 for server error
            http_response_code(500);
            echo json_encode(array('message' => 'Error deleting train: ' . $conn->error));
        }
    } else {
        // Setting HTTP status code to 400 for bad request
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. TrainID is required.'));
    }
}

?>
