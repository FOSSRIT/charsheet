# -*- coding: utf-8 -*-
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link href='${request.static_url('charsheet:static/css/reset.css')}'
          rel='stylesheet' type='text/css' media='all'>
    <link href='${request.static_url('charsheet:static/css/960_12_col.css')}'
          rel='stylesheet' type='text/css' media="all">
    <link href='${request.static_url('charsheet:static/css/app.css')}'
          rel='stylesheet' type='text/css'>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    ${self.head()}
    <title>${self.title()}</title>
  </head>
  <body>
    <!-- Header logo -->
    <a href="..">
      <h1 class='logo-text'>
        <img class='logo' alt='Charsheet logo'
             src='${request.static_url('charsheet:static/img/icon_64x64.png')}' />
        Charsheet
      </h1>
    </a>
    <!-- End header logo -->
    <% flash = request.session.pop_flash() %>
    <% alert_y = 20 %>
    % for message in flash:
      % if message.startswith('Error:'):
        <div style="top: ${alert_y}px" class="alert alert-error">
          <h4 class="alert-heading">Error</h4><p>${message[7:]}</p>
        </div>
      % else:
        <div style="top: ${alert_y}px" class="alert alert-success">
          <h4 class="alert-heading">Success</h4><p>${message}</p>
        </div>
      % endif
      <% alert_y += 110 %>
    % endfor

    ${self.body()}

    <div class="container_12">
      <div class="grid_12">
        <div class="footer">
          <a rel="license"
             href="http://creativecommons.org/licenses/by/3.0/">
            <img alt="Creative Commons License"
                 style="border-width:0"
                 src="${request.static_url('charsheet:static/img/cc30.png')}" />
          </a>
          <br />This work is licensed under a
          <a rel="license" href="http://creativecommons.org/licenses/by/3.0/">
            Creative Commons Attribution 3.0 Unported License
		  </a>.
          Code freely available
          <a href="https://github.com/FOSSRIT/charsheet">on GitHub</a>.
        </div>
      </div>
    </div>
  </body>
</html>

<%def name='head()'></%def>
