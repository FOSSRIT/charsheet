# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link href='${request.static_url(
			'charsheet:static/css/reset.css')}'
			rel='stylesheet' type='text/css' media='all'>
		<link href='${request.static_url(
			'charsheet:static/css/960_12_col.css')}'
			rel='stylesheet' type='text/css' media="all">
		<link href='${request.static_url('charsheet:static/css/app.css')}'			rel='stylesheet' type='text/css'>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    	<title>Charsheet | Service Login Results</title>
	</head>
    <body>
		
		<!-- Header logo -->
		<a href=".."><h1 class="logo-text"><img class='logo' alt='Charsheet logo'
			src='${request.static_url('charsheet:static/img/icon_64x64.png')}' />
		Charsheet</h1></a>
		<!-- End header logo -->
	
		<div class="container_12">
			<div class="clear"></div>
		
			<div class="grid_12 navbar">
				<a class="button" href="../stats">Global Stats</a>
			</div>
			
			<div class="clear"></div>
			
			<div class="grid_6">
			<p>
			</div>
			<div class="grid_6">
			</div>
			<div class="clear"></div>
			<div class="grid_12">
				<div class="footer">
				<a rel="license"
					href="http://creativecommons.org/licenses/by/3.0/">
						<img alt="Creative Commons License"
						style="border-width:0"
					src="${request.static_url('charsheet:static/img/cc30.png')}" />
				</a>
				<br />This work is licensed under a
				<a rel="license" href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 Unported License</a>.
				Code freely available
				<a href="https://github.com/FOSSRIT/charsheet">on GitHub</a>.
				</div>
			</div>
		</div>
   	</body>
</html>
