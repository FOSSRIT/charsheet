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
		<table>
			<tr><td>${charsheet_form.display()}</td></tr>
		</table>
   	</body>
</html>
