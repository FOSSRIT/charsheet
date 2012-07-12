<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link href='${request.static_url('charsheet:static/css/charsheet.css')}' rel='stylesheet' type='text/css'>
    	<title>Character Sheet for ${username}</title>
	</head>
    <body>
		<h2 class="title">Username: ${username}</h2>
		<!--#Dot-style attributes Mockup-->
		<h3>Languages</h3>
		<div align="left" id="languages">
		<strong>Foo</strong>
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_048_dislikes.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_048_dislikes.png')}"><br/><br/>
		<strong>Endorsements</strong>
			% for endorsement in range(cwc.endorsements):
				<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			% endfor
		<br/><br/>
      	<table>
        % for stat_name, value in stats:
          <tr>
            <td><img src="${request.static_url('charsheet:static/icons/glyphicons_' + stat_name + '.png')}"></td>
            <td><progress value="${value}" max="100"> </progress></td>
          </tr>
        % endfor
		</table>
		<br/><br/>
		<!--
		% for a in ['one', 'two', 'three', 'four', 'five']:
			% if a[0] == 't':
			<strong>its two or three</strong>
			% elif a[0] == 'f':
			<em>four/five</em>
			% else:
			one
			% endif
		% endfor
		-->
		<h2>From: ${cwc.location}</h2>
		<h2>Endorsements: ${cwc.endorsements}</h2>
		<ul class="badge-list">
			% for badge in cwc.badges:
				<li><img class="badge-image" src="${badge.image_uri}"/> ${badge.name}<br/><br/> ${badge.description}</li>
			% endfor
		</ul>
   </body>
</html>
