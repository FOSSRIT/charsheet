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
      ${self.search_form()}
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
    % if request.session.get('token'):
      <form action="${github_login_url}" method="post">
        <input class="button" type="submit" value="Login with GitHub" />
      </form>
    % else:
      Already logged into Github!
    % endif
  </div>
  <div class="grid_6" id='home_form'>
    ${self.generate_form()}
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

<%def name='search_form()'>
  <link media="all" href="/resources/tw2.forms/static/forms.css"
        type="text/css" rel="stylesheet">
  <title>Handle Search</title>
  <h1>Handle Search</h1>
  <form method="post" enctype="multipart/form-data"
        id="handlesearchform:form" action="/handle_search">
    <span class="error"></span>
    <table id="handlesearchform">
      <tbody>
        <tr id="handlesearchform:handle:container" class="odd">
          <th><label for="handle">Handle</label></th>
          <td>
            <input type="text" id="handlesearchform:handle" name="handlesearchform:handle">

            <span id="handlesearchform:handle:error"></span>
          </td>
        </tr>
        <tr class="error"><td colspan="2">
          <span id="handlesearchform:error"></span>
        </td></tr>
      </tbody>
    </table>

    <input type="submit" id="submit" value="Search">
  </form>
</%def>

<%def name='generate_form()'>
  <link media="all" href="/resources/tw2.forms/static/forms.css"
        type="text/css" rel="stylesheet">
  <title>Accounts</title>
  <h1>Accounts</h1>
  <form method="post" enctype="multipart/form-data"
        id="charsheetform:form" action="/submit">
    <span class="error"></span>
    <table id="charsheetform">
      <tbody>
        <tr id="charsheetform:master:container" class="odd">
          <th><label for="master">All</label></th>
          <td>
            <input type="text" id="charsheetform:master" name="charsheetform:master">

            <span id="charsheetform:master:error"></span>
          </td>
        </tr>
        <tr id="charsheetform:ohloh:container" class="even">
          <th><label for="ohloh">Ohloh</label></th>
          <td>
            <input type="text" id="charsheetform:ohloh" name="charsheetform:ohloh">

            <span id="charsheetform:ohloh:error"></span>
          </td>
        </tr>
        <tr id="charsheetform:coderwall:container" class="odd">
          <th><label for="coderwall">Coderwall</label></th>
          <td>
            <input type="text" id="charsheetform:coderwall" name="charsheetform:coderwall">

            <span id="charsheetform:coderwall:error"></span>
          </td>
        </tr>
        <tr class="error"><td colspan="2">
          <input type="hidden" id="charsheetform:id" name="charsheetform:id">
          <input type="hidden" id="charsheetform:github" name="charsheetform:github">
          <input type="hidden" id="charsheetform:github_token" name="charsheetform:github_token">
          <span id="charsheetform:error"></span>
        </td></tr>
      </tbody>
    </table>

    <input type="submit" id="submit" value="Generate">
  </form>
</%def>
