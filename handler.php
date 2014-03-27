<?php

// Welcome to PHP!  This file takes in data from the Support form and saves it
// accordingly.  For the sake of security, the true username and the password
// for the MySQL database have been ommitted.  If you create a file called
// "secret.txt" that contains the password to the MySQL database, this file will
// use it.

$password = trim(file_get_contents("secret.txt"));
$mysqli = new mysqli("localhost", "services", $password, "jessicaluck2014");


// The majority of any form handling script is dealing with improper user input.
// Trust me, if you make forms long enough, you will deal with every possible
// user error.  Take the time to think about it ahead of time.

// Firstly, what if the user just submitted the form without choosing any action
// to take?

if (!isset($_POST['support-check-suggest']) && !isset($_POST['support-check-support'])) {

	// Note that http_response_code() requires PHP 5.4 which is NOT standard on
	// Ubuntu 12.04 LTS.  By choosing a response code in the 400s, the $.ajax
	// function in our javascript file will interpret the response as an error
	// and display the message accordingly.

	http_response_code(406);
	die("Please choose an action");
}


$suggest = null;
$support = null;

// What if someone wanted to suggest a platform point but didn't include their
// suggestion?

if (isset($_POST['support-check-suggest']) && $_POST['support-check-suggest'] == "Yes") {

	if (!isset($_POST['support-form-suggest']) || $_POST['support-form-suggest'] == "") {
		http_response_code(406);
		die("What is your suggestion?");
	}

	else
		$suggest = $mysqli->real_escape_string($_POST['support-form-suggest']);
}


// What if someone wanted to show their support but didn't include their name or
// e-mail, or what if their e-mail is invalid?  What if they want to help out
// with the campaign but didn't say how?

if (isset($_POST['support-check-support']) && $_POST['support-check-support'] == "Yes") {

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

	if ($_POST['support-check-join'] == "Yes") {
		if (!isset($_POST['support-form-join']) || $_POST['support-form-join'] == "") {
			http_response_code(406);
			die("How would you like to help out?");
		}

		else
			$support = $mysqli->real_escape_string($_POST['support-form-join']);
	}
}


// With error conditions out of the way, we can collect the data, strip it of
// any potentially malicious input (i.e. SQL Injection), and store it.

$name = $mysqli->real_escape_string($_POST['support-form-name']);
$email = $mysqli->real_escape_string($_POST['support-form-email']);
$organization = $mysqli->real_escape_string($_POST['support-form-org']);
$more = ($_POST['support-check-join'] == "Yes") ? 1 : 0;
$picture = ($_FILES["support-form-picture"]["name"] != "") ? 1 : 0;

// I elected to go ahead and store the user information first: even if the photo
// upload fails, we'll at least have their contact information.

if (!$mysqli->query("INSERT INTO supporters VALUES (NULL, '" . $name . "', '" .
					$email . "', '" . $organization . "', " . $more . ", '" .
					$support . "', '" . $suggest . "', " . $picture . ")")) {
	http_response_code(406);
	die("There was an error while recording your information.");
}


// The rest of the script deals with the photo upload.

$allowedExts = array("gif", "jpeg", "jpg", "png");
$temp = explode(".", $_FILES["support-form-picture"]["name"]);
$extension = end($temp);


if ($_FILES["support-form-picture"]["name"] != "") {

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
		die("Error: Invalid file, or too large (>5mb).");
	}
}

echo "Thank you for your support!";

?>