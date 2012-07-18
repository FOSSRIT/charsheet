# -*- coding: utf-8 -*-
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
		% if coderwall_data:
		<link href='http://coderwall.com/stylesheets/jquery.coderwall.css'
			media='all' rel='stylesheet' type='text/css'>
		<script src='http://coderwall.com/javascripts/jquery.coderwall.js'>
			</script>
		% endif
    	<title>Character Sheet for ${username}</title>
	</head>
    <body>
		<% display_sheet = False %>
		<% flash = request.session.pop_flash() %>
		% for message in flash:
			% if message.startswith('Error:'):
				<div class="alert alert-error">
					<h4 class="alert-heading">Error</h4><p>${message[7:]}</p>
				</div>
			% else:
				<div class="alert alert-success">
					<h4 class="alert-heading">Success<h4><p>${message}</p>
				</div>
				<% display_sheet = True %>
			% endif
		% endfor
		% if display_sheet == True:
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
						% if github_data['blog'] != None:
						<td><a href="${github_data['blog']}">[Link]</a>
						% else:
						<td>None
						% endif
						</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<img class="avatar" src="${github_data['avatar_url']}" />
				% if github_data['bio'] != None:
				<p>${github_data['bio'] | n}</p>
				% else:
				<p>This dev has not yet set a bio on GitHub.</p>
				% endif
			</div>
			<div class="clear"></div>
			
			<!-- ATTRIBUTES  -->
			
			<div class="grid_12">
				<h2>Attributes</h2>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Attribute 1:</td><td>value</td></tr>
					<tr><td>Attribute 2:</td><td>value</td></tr>
					<tr><td>Attribute 3:</td><td>value</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Attribute 4:</td><td>value</td></tr>
					<tr><td>Attribute 5:</td><td>value</td></tr>
					<tr><td>Attribute 6:</td><td>value</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Attribute 7:</td><td>value</td></tr>
					<tr><td>Attribute 8:</td><td>value</td></tr>
					<tr><td>Attribute 9:</td><td>value</td></tr>
				</table>
			</div>
			<div class="clear">
			</div>
			
			<!-- SKILLS  -->
			
			<div class="grid_12">
				<h2>Skills</h2>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Skill 1:</td><td>value</td></tr>
					<tr><td>Skill 2:</td><td>value</td></tr>
					<tr><td>Skill 3:</td><td>value</td></tr>
					<tr><td>Skill 4:</td><td>value</td></tr>
					<tr><td>Skill 5:</td><td>value</td></tr>
					<tr><td>Skill 6:</td><td>value</td></tr>
					<tr><td>Skill 7:</td><td>value</td></tr>
					<tr><td>Skill 8:</td><td>value</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Skill 9:</td><td>value</td></tr>
					<tr><td>Skill 10:</td><td>value</td></tr>
					<tr><td>Skill 11:</td><td>value</td></tr>
					<tr><td>Skill 12:</td><td>value</td></tr>
					<tr><td>Skill 13:</td><td>value</td></tr>
					<tr><td>Skill 14:</td><td>value</td></tr>
					<tr><td>Skill 15:</td><td>value</td></tr>
					<tr><td>Skill 16:</td><td>value</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Skill 17:</td><td>value</td></tr>
					<tr><td>Skill 18:</td><td>value</td></tr>
					<tr><td>Skill 19:</td><td>value</td></tr>
					<tr><td>Skill 20:</td><td>value</td></tr>
					<tr><td>Skill 21:</td><td>value</td></tr>
					<tr><td>Skill 22:</td><td>value</td></tr>
					<tr><td>Skill 23:</td><td>value</td></tr>
					<tr><td>Skill 24:</td><td>value</td></tr>
				</table>
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
					<tr><td>Total Lines in Repos:</td>
						<td>${github_data['total_lines']}</td></tr>
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
						<td>${ohloh_data['position']}</td></tr>
					<tr><td></td><td></td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Coderwall Endorsements:</td>
						<td>
						% if coderwall_data:
							${coderwall_data['endorsements']}
						% else:
							?
						% endif
						</td>
					</tr>
					% if coderwall_data:
					<tr><td colspan='2'>
						<section class="coderwall"
							data-coderwall-username="${username}"
							data-coderwall-orientation="vertical"></section>
						</td>
					</tr>
					% endif
				</table>
			</div>
			<div class="clear">
			</div>
			<div class="grid_12">
				% if coderwall_data:
				<h2>Coderwall Achievements</h2>
				<table class="badge-list">
					% for badge in cwc.badges:
						<tr><td><img src="${badge.image_uri}"/></td>
						<td>${badge.name}</td><td>${badge.description}</td></tr>
					% endfor
				</table>
				% else:
				<p>Add your Coderwall username to see your badges.</p>
				% endif
			</div>
		</div>
		% endif
	</body>
</html>
