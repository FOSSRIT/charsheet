# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link href='${request.static_url('charsheet:static/css/charsheet.css')}'				rel='stylesheet' type='text/css'>
    	<title>charsheet - OpenID Login</title>
	</head>
    <body>
		<h1>charsheet - OpenID Login</h1>
		<div id='charsheet_form'>
			<form method="POST" action="${url}">
				<input type="text" value="${openid_url}"
					name="openid" size=40 />
				<input type="submit" value="Login with OpenID" />
			</form>
		</div>
   	</body>
</html>
