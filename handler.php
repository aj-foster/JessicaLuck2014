<?php

$password = file_get_contents("secret.txt");
$mysqli = new mysqli("localhost", "services", $password, "jessicaluck2014");


if (!isset($_POST['support-form-name']) || $_POST['support-form-name'] == "") {
	http_response_code(406);
	die("Please provide your name");
}

if (!isset($_POST['support-form-email']) || $_POST['support-form-email'] == "") {
	http_response_code(406);
	die("Please provide your e-mail");
}

if (!filter_var($_POST['support-form-email'], FILTER_VALIDATE_EMAIL)) {
	http_response_code(406);
	die("Please provide a valid e-mail address.");
}

$suggest = null;
$support = null;

if ($_POST['support-check-suggest'] == "Yes") {
	if (!isset($_POST['support-form-suggest']) || $_POST['support-form-suggest'] == "") {
		http_response_code(406);
		die("What is your suggestion?");
	}

	else
		$suggest = $mysqli->real_escape_string($_POST['support-form-suggest']);
}

if ($_POST['support-check-join'] == "Yes") {
	if (!isset($_POST['support-form-join']) || $_POST['support-form-join'] == "") {
		http_response_code(406);
		die("How would you like to help out?");
	}

	else
		$support = $mysqli->real_escape_string($_POST['support-form-join']);
}


$name = $mysqli->real_escape_string($_POST['support-form-name']);
$email = $mysqli->real_escape_string($_POST['support-form-email']);
$organization = $mysqli->real_escape_string($_POST['support-form-org']);


if (!$mysqli->query("INSERT INTO supporters VALUES ()")) {
	http_response_code(406);
	die("There was an error while recording your information.");
}


$allowedExts = array("gif", "jpeg", "jpg", "png");
$temp = explode(".", $_FILES["support-form-picture"]["name"]);
$extension = end($temp);



if ((($_FILES["support-form-picture"]["type"] == "image/gif")
	|| ($_FILES["support-form-picture"]["type"] == "image/jpeg")
	|| ($_FILES["support-form-picture"]["type"] == "image/jpg")
	|| ($_FILES["support-form-picture"]["type"] == "image/pjpeg")
	|| ($_FILES["support-form-picture"]["type"] == "image/x-png")
	|| ($_FILES["support-form-picture"]["type"] == "image/png"))
	&& in_array($extension, $allowedExts)) {

	if ($_FILES["support-form-picture"]["error"] > 0) {
		http_response_code(406);
		die("Error: " . $_FILES["support-form-picture"]["error"]);
	}

	$newName = str_replace(" ", "-", strtolower($_POST["support-form-name"]));
	$newName .= "." . $extension;



	if (file_exists("uploads/" . $newName)) {
		http_response_code(406);
		die("Error: We already have a picture for you.<br>Your information has been saved.");
	}

	else {
		if (!move_uploaded_file($_FILES["support-form-picture"]["tmp_name"],
								"uploads/" . $newName)) {
			http_response_code(406);
			die("Error: Picture could not be saved.<br>Your information was recorded successfully.");
		}
	}
}

else {
	http_response_code(406);
	die("Error: Invalid file");
}

echo "Thank you for your support!";

?>