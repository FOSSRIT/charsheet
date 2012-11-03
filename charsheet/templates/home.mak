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
		
		<!-- Header logo -->
		<a href=".."><h1 class="logo-text"><img class='logo' alt='Charsheet logo'
			src='${request.static_url('charsheet:static/img/icon_64x64.png')}' />
		Charsheet</h1></a>
		<!-- End header logo -->
	
		<div id="loading">
			<img
			src="${request.static_url('charsheet:static/gif/gnu-cat.gif')}" />
		</div>
		<div class="container_12">
			<div class="clear"></div>
		
			<div class="grid_12 navbar">
				<a class="button" href="../stats">Global Stats</a>
			</div>
			
			<div class="clear"></div>
			
			<div class="grid_6">
				<p>Charsheet is an <a href="https://github.com/FOSSRIT/charsheet">
					open-source</a> web app that generates hacker character sheets
					based on data from sites like <a href="https://github.com/">
					GitHub</a>, <a href="http://www.ohloh.net">Ohloh</a>, and
					<a href="http://coderwall.com/">Coderwall</a>.
				</p>
				<p>Generate your developer character sheet by completing
					fields in the form to the right. Skip services you do not
					have an account with.
				</p>
				<p>Please report bugs and submit feature requests
					<a href="https://github.com/FOSSRIT/charsheet/issues">
					here</a>.
				</p>
				<h2>Status</h2>
				<p>Charsheet is currently able to process only 60 GitHub
					requests an hour. Please bear with me as I add OAuth
					following the recent GitHub API changes. -- odd</p>
				<!-- SLIDESHOW COMMENTED OUT UNTIL I FINISH REDESIGN
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
					<form action="${github_login_url}" method="post">
						<input class="button" type="submit"
							value="Login with GitHub" />
					</form>
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
