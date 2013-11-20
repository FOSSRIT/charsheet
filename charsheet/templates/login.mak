<%inherit file="base.mak"/>

<h1>charsheet - OpenID Login</h1>
<div id='charsheet_form'>
  <form method="POST" action="${url}">
    <input type="text" value="${openid_url}" name="openid" size=40 />
    <input type="submit" value="Login with OpenID" />
  </form>
</div>

<%def name='title()'>Charsheet - OpenID Login</%def>
