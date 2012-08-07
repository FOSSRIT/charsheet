# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link href='${request.static_url(
			'charsheet:static/css/960_12_col.css')}'
			rel='stylesheet' type='text/css' media="all">
		<link href='${request.static_url('charsheet:static/css/charsheet.css')}'				rel='stylesheet' type='text/css'>
    	<title>Charsheet</title>
	</head>
    <body>
		<h1>Charsheet</h1>
		<div class="container_12">
			<div class="clear"></div>
			
			<div class="grid_6">
				<p>Generate your developer character sheet by completing
					fields in the form to the right.
				</p>
				<p>Skip services you do not have an account for.
				</p>
				<p>Report bugs and submit feature requests
					<a href="https://github.com/FOSSRIT/surf-2012/issues">
					here</a>.
				</p>
			</div>
			<div class="grid_6">
				<div id='charsheet_form'>
					${charsheet_form.display()}
					<!-- <a href="/login">Login with OpenID for FAS</a> -->
				</div>
			</div>
			<div class="clear"></div>
		</div>
   	</body>
</html>
