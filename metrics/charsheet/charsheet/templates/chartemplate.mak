<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<link href='${request.static_url(
			'charsheet:static/css/reset.css')}'
			rel='stylesheet' type='text/css' media='all'>
		<link href='${request.static_url(
			'charsheet:static/css/960_12_col.css')}'
			rel='stylesheet' type='text/css' media="all">
		<link href='${request.static_url('charsheet:static/css/charsheet.css')}'			rel='stylesheet' type='text/css'>
    	<title>Character Sheet for ${username}</title>
	</head>
    <body>
		<h1>${username}</h1>
		<ul id="user-bio">
			<li><img class="avatar" src="${github_data['avatar_url']}" /></li>
			<li>Location: ${cwc.location}</li>
			<li>Public GitHub Repos: ${github_data['public_repos']}</li>
			<li>Ohloh Kudos: ${ohloh_data['kudo_rank']}
				<span style="font-size: 0.8em">
					(Ranked no. ${ohloh_data['position']})</li>
		</ul>
		<!--#Dot-style attributes Mockup-->
		<h2>Languages</h2>
		<div align="left" id="languages">
		<p><strong>Foo</strong>
			<img width="1%"
				src="${request.static_url(
					'charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%"
				src="${request.static_url(
					'charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%"
				src="${request.static_url(
					'charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%"
				src="${request.static_url(
					'charsheet:static/icons/glyphicons_048_dislikes.png')}">
			<img width="1%"
				src="${request.static_url(
					'charsheet:static/icons/glyphicons_048_dislikes.png')}">
		</p>
		<p><strong>Coderwall Endorsements</strong>
			% for endorsement in range(cwc.endorsements):
				<img width="1%"
				src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			% endfor
		</p>
      	<table>
        % for stat_name, value in stats:
          <tr>
            <td><img src="${request.static_url('charsheet:static/icons/glyphicons_' + stat_name + '.png')}"></td>
            <td><progress value="${value}" max="100"> </progress></td>
          </tr>
        % endfor
		</table>
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
		<h2>Coderwall Achievements</h2>
		<table class="badge-list">
			% for badge in cwc.badges:
				<tr><td><img src="${badge.image_uri}"/></td><td>${badge.name}</td><td>${badge.description}</td></li>
			% endfor
		</table>
	</body>
</html>
