# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link href='${request.static_url(
			'charsheet:static/css/960_12_col.css')}'
			rel='stylesheet' type='text/css' media="all">
		<link href='${request.static_url('charsheet:static/css/home.css')}'				rel='stylesheet' type='text/css'>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
		<script type='text/javascript'
	src='${request.static_url('charsheet:static/js/jquery.cycle.all.js')}'>
		</script>
		<script
	src='${request.static_url('charsheet:static/js/home.js')}'>
		</script>
    	<title>Charsheet</title>
	</head>
    <body>
		<h1><img class='logo' alt='Charsheet logo'
			src='${request.static_url('charsheet:static/img/icon_64x64.png')}' />
		Charsheet</h1>
		<div id="loading">
			<img
			src="${request.static_url('charsheet:static/gif/gnu-cat.gif')}" />
		</div>
		<div class="container_12">
			<div class="clear"></div>
			
			<div class="grid_6">
				<p>Generate your developer character sheet by completing
					fields in the form to the right.
				</p>
				<p>Skip services you do not have an account for.
				</p>
				<p>Report bugs and submit feature requests
					<a href="https://github.com/FOSSRIT/charsheet/issues">
					here</a>.
				</p>
				<!-- SLIDESHOW COMMENTED OUT
				<div class="slideshow">
					<img
			src="${request.static_url('charsheet:static/img/screenshot3.png')}"
			alt="Charsheet screenshot"
			width="382" height="231"
					/>
					<img
			src="${request.static_url('charsheet:static/img/screenshot4.png')}"
			alt="Charsheet screenshot"
			width="382" height="231"
					/>
					<img
			src="${request.static_url('charsheet:static/img/screenshot2.png')}"
			alt="Charsheet screenshot"
					/>
				</div>
				-->
			</div>
			<div class="grid_6">
					<div id='charsheet_form'>
					${charsheet_form.display() | n}
					</div>
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
