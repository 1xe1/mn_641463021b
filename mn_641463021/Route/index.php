<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE, PUT");
header("Access-Control-Allow-Headers: *");
include "../conn.php";

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        getRoutes();
        break;
    case 'POST':
        addRoute();
        break;
    case 'PUT':
        updateRoute();
        break;
    case 'DELETE':
        deleteRoute();
        break;
    default:
        http_response_code(405);
        echo json_encode(array('message' => 'Unsupported HTTP method'));
        break;
}

function getRoutes() {
    global $conn;

    // $sql = "SELECT route.RouteID, route.AttractionID,route.AttractionID, touristattractions.AttractionName, route.Time FROM route JOIN touristattractions ON route.AttractionID = touristattractions.AttractionID WHERE route.statusDelete = 0";
    $sql = "SELECT * FROM route WHERE route.statusDelete = 0";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $routes = array();
        while ($row = $result->fetch_assoc()) {
            $routes[] = $row;
        }
        echo json_encode($routes);
    } else {
        echo json_encode(array('message' => 'No routes found.'));
    }
}

function addRoute() {
    global $conn;

    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['AttractionID']) && isset($data['Time'])) {
        $attractionID = $conn->real_escape_string($data['AttractionID']);
        $time = $conn->real_escape_string($data['Time']);

        $sql = "SELECT MAX(RouteID) AS MAX_ID FROM route";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $Max_ID = $row['MAX_ID'] + 1;

        $insertSql = "INSERT INTO route (RouteID, AttractionID, Time, statusDelete) VALUES ('$Max_ID', '$attractionID', '$time', 0)";

        if ($conn->query($insertSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Route added successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error adding route: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. AttractionID and Time are required.'));
    }
}

function updateRoute() {
    global $conn;

    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['RouteID']) && isset($data['AttractionID']) && isset($data['Time'])) {
        $routeID = $conn->real_escape_string($data['RouteID']);
        $attractionID = $conn->real_escape_string($data['AttractionID']);
        $time = $conn->real_escape_string($data['Time']);

        $updateSql = "UPDATE route SET AttractionID='$attractionID', Time='$time' WHERE RouteID='$routeID'";

        if ($conn->query($updateSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Route updated successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error updating route: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. RouteID, AttractionID, and Time are required.'));
    }
}

function deleteRoute() {
    global $conn;

    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['RouteID'])) {
        $routeID = $conn->real_escape_string($data['RouteID']);

        $deleteSql = "UPDATE route SET statusDelete=1 WHERE RouteID='$routeID'";
        if ($conn->query($deleteSql) === TRUE) {
            http_response_code(200);
            echo json_encode(array('message' => 'Route deleted successfully.'));
        } else {
            http_response_code(500);
            echo json_encode(array('message' => 'Error deleting route: ' . $conn->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array('message' => 'Invalid data. RouteID is required.'));
    }
}
?>
