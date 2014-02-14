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
  <h1>Handle Search</h1>
  <form method="post" enctype="multipart/form-data"
        id="searchform" action="/handle_search">
    <span class="error"></span>
    <table>
      <tbody>
        <tr>
          <th><label for="handle">Handle</label></th>
          <td>
            <input type="text" id="handle" name="handle">
          </td>
        </tr>
      </tbody>
    </table>

    <input type="submit" id="submit" value="Search">
  </form>
</%def>

<%def name='generate_form()'>
  <h1>Accounts</h1>
  <form method="post" enctype="multipart/form-data"
        id="charsheetform" action="/submit">
    <table id="charsheetform">
      <tbody>
	  <!-- Disabling this for now. Not very useful.
        <tr>
          <th><label for="master">All</label></th>
          <td>
            <input type="text" id="master" name="master">
          </td>
        </tr>
	  End field disable -->

        <tr>
          <th><label for="github">Github</label></th>
          <td>
            % if not request.session.get('token'):
              <a href="${github_login_url}" class="button">Login with GitHub</a>
            % else:
              <input type="text" readonly id="github" name="github"
                     value="${request.session.get('username')}"></input>
              <input type="hidden" id="github_token" name="github_token"
                     value=${request.session.get('token')}>
            % endif
          </td>
        </tr>

        <tr>
          <th><label for="ohloh">Ohloh</label></th>
          <td>
            <input type="text" id="ohloh" name="ohloh">
          </td>
        </tr>

        <tr>
          <th><label for="coderwall">Coderwall</label></th>
          <td>
            <input type="text" id="coderwall" name="coderwall">
          </td>
        </tr>
      </tbody>
    </table>
    <input type="submit" id="submit" value="Generate">

  </form>
</%def>
