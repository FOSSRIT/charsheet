# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link href='${request.static_url('charsheet:static/css/charsheet.css')}'				rel='stylesheet' type='text/css'>
    	<title>charsheet</title>
	</head>
    <body>
		<h1>charsheet</h1>
		<div id='charsheet_form'>
			${charsheet_form.display()}
		</div>
   	</body>
</html>
