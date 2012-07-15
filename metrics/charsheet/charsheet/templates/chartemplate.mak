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
		<h1>Character Record Sheet</h1>
		<div class="container_12">
			<div class="clear"></div>
			
			<!-- GENERAL INFORMATION -->
			
			<div class="grid_4">
				<table>
					<tr><td>Handle:</td><td>${username}</td></tr>
					<tr><td>Name:</td><td>${github_data['name']}</td></tr>
					<tr><td>Email:</td><td>${github_data['email']}</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Location:</td>
						<td>${github_data['location']}</td></tr>
					<tr><td>Company:</td><td>${github_data['company']}</td></tr>
					<tr><td>Blog:</td>
						<td><a href="${github_data['blog']}">[Link]</a>
						</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<img class="avatar" src="${github_data['avatar_url']}" />
				<p>${github_data['bio']}</p>
			</div>
			<div class="clear"></div>
			
			<!-- ATTRIBUTES  -->
			
			<div class="grid_12">
				<h2>Attributes</h2>
			</div>
			<div class="grid_4">
			</div>
			<div class="grid_4">
			</div>
			<div class="grid_4">
			</div>
			<div class="clear">
			</div>
			
			<!-- SKILLS  -->
			
			<div class="grid_12">
				<h2>Skills</h2>
			</div>
			<div class="grid_4">
			</div>
			<div class="grid_4">
			</div>
			<div class="grid_4">
			</div>
			<div class="clear">
			</div>
			
			<!-- STATISTICS  -->
			
			<div class="grid_12">
				<h2>Statistics</h2>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Public GitHub Repos:</td>
						<td>${github_data['public_repos']}</td></tr>
					<tr><td></td><td></td></tr>
					<tr><td></td><td></td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Ohloh Profile:</td><td><a href=
						'http://www.ohloh.net/accounts/
						${ohloh_data['id']}?ref=Detailed'
						target='_top'>
					<img
						alt='Ohloh Profile'
						border='0' height='35'
						src='http://www.ohloh.net/accounts/${ohloh_data['id']}
							/widgets/account_detailed.gif'
						width='191' />
					</a></td></tr>
					<tr><td>Ohloh Rank:</td>
						<td>${ohloh_data['kudo_rank']}</td></tr>
					<tr><td></td><td></td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Coderwall Endorsements:</td>
						<td>
						${coderwall_data['endorsements']}
						</td>
					</tr>
				</table>
			</div>
			<div class="clear">
			</div>
		</div>
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
