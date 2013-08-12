<%inherit file="base.mak"/>

<div id="loading">
  <img src="${request.static_url('charsheet:static/gif/gnu-cat.gif')}" />
</div>

<div class="container_12">
  <div class="clear"></div>

  <div class="grid_12 navbar">
    <a class="button" href="../stats">Global Stats</a>
  </div>

  <div class="clear"></div>

  <div class="grid_6">
    <p>Charsheet is a <a href="https://github.com/FOSSRIT/charsheet">
       free and open-source</a> web app that generates hacker character sheets
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
    <div id="home_form">
      ${handle_search_form.display() | n}
    </div>
    <!-- SLIDESHOW COMMENTED OUT UNTIL I FINISH REDESIGN
    <div class="slideshow">
      <img src="${request.static_url('charsheet:static/img/screenshot3.png')}"
           alt="Charsheet screenshot"
           width="382" height="231" />
      <img src="${request.static_url('charsheet:static/img/screenshot4.png')}"
           alt="Charsheet screenshot"
           width="382" height="231" />
      <img src="${request.static_url('charsheet:static/img/screenshot2.png')}"
           alt="Charsheet screenshot" />
    </div>
    -->
  </div>
  <div class="grid_6">
    <div id='home_form'>
      ${charsheet_form.display() | n}
      <form action="${github_login_url}" method="post">
        <input class="button" type="submit"
               value="Login with GitHub" />
      </form>
    </div>
  </div>
  <div class="clear"></div>
</div>

<%def name='head()'>
  <link href='${request.static_url('charsheet:static/css/home.css')}' rel='stylesheet' type='text/css'>
  <script type='text/javascript'
          src='${request.static_url('charsheet:static/js/jquery.cycle.all.js')}'>
  </script>
  <script src='${request.static_url('charsheet:static/js/home.js')}'>
  </script>
</%def>

<%def name='title()'>Charsheet</%def>
