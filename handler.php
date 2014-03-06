<?php

if (!isset($_POST['support-form-name']) || $_POST['support-form-name'] == "") {
	http_response_code(406);
	die("Please provide your name");
}

if (!isset($_POST['support-form-email']) || $_POST['support-form-email'] == "") {
	http_response_code(406);
	die("Please provide your e-mail");
}

if ($_POST['support-form-more'] == "Yes") {

	if (!isset($_POST['support-form-how']) || $_POST['support-form-how'] == "") {
		http_response_code(406);
		die("How would you like to help out?");
	}
}

else
	echo "Thank you for your support!";

?>