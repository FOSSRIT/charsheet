# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link href='${request.static_url('charsheet:static/css/reset.css')}'
          rel='stylesheet' type='text/css' media='all'>
    <link href='${request.static_url('charsheet:static/css/960_12_col.css')}'
          rel='stylesheet' type='text/css' media="all">
    <link href='${request.static_url('charsheet:static/css/app.css')}'  rel='stylesheet' type='text/css'>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    ${self.head()}
    <title>${self.title()}</title>
  </head>
  <body>
	<!-- Header logo -->
	<a href=".."><h1 class="logo-text"><img class='logo' alt='Charsheet logo'
		src='${request.static_url('charsheet:static/img/icon_64x64.png')}' />
	Charsheet</h1></a>
	<!-- End header logo -->

    ${self.body()}
  </body>
</html>
