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
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
		<script src='${request.static_url('charsheet:static/js/charsheet.js')}'></script>
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
					<h4 class="alert-heading">Success</h4><p>${message}</p>
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
				% if github_data:
					<img class="avatar" src="${github_data['avatar_url']}" />
					% if github_data['bio'] != None:
					<p>${github_data['bio'] | n}</p>
					% else:
					<p>This dev has not yet set a bio on GitHub.</p>
					% endif
				% else:
					<p>No bio for this dev.</p>
				% endif
			</div>
			<div class="grid_4">
				<table>
					<tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_070_umbrella.png')}'/> Handle:</td>
					<td>${username}</td></tr>
					<tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_003_user.png')}'/> Name:</td><td>
						% if github_data:
							${github_data['name']}
						% else:
							?
						% endif
					</td></tr>
					<tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_010_envelope.png')}'/> Email:</td><td>
						% if github_data:
						
							${github_data['email']}
						% else:
							?	
						% endif
					</td></tr>
					<tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_245_chat.png')}'/> IRC:</td><td>
						% if fedora_data:
							${fedora_data['irc']}
						% else:
							?
						% endif
					</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_340_globe.png')}'/> Location:</td>
						<td>
						% if github_data:
							${github_data['location']}
						% else:
							?
						% endif
						</td></tr>
					<tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_341_briefcase.png')}'/> Company:</td><td>
						% if github_data:
							${github_data['company']}
						% else:
							?
						% endif
						</td></tr>
					<tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_235_pen.png')}'/> Blog:</td><td>
						% if github_data:
							% if github_data['blog'] != None:
							<a href="http://${github_data['blog']}">[Link]</a>
							% else:
							None
							% endif
						% else:
							?
						% endif
						</td></tr>
				</table>
			</div>
			<div class="clear"></div>
			
			<!-- ATTRIBUTES  -->
			
			<div class="grid_12">
				<h2>Attributes</h2>
			</div>
			<div class="clear"></div>
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
			<div class="clear"></div>
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
			<div class="clear"></div>
			<div class="grid_4">
				<table>
					<tr><td>Public GitHub Repos:</td>
						<td>
						% if github_data:
							${github_data['public_repos']}
						% else:
							?
						% endif
						</td></tr>
					<tr><td>Total Lines in Repos:</td>
						<td>
						% if github_data:
							${github_data['total_lines']}
						% else:
							?
						% endif
						</td></tr>
					<tr><td>Top Languages by Repos</td><td>
						% if github_data:
							% for i in range(3):
								${github_data['languages_count'][i][0]},
							% endfor
						% else:
							?
						% endif
						</td></tr>
					<tr><td>Top Languages by Klocs</td><td>
						% if github_data:
							% for i in range(3):
								${github_data['languages'][i][0]}, 
							% endfor	
						% else:
							?
						% endif
						</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Ohloh Profile:</td><td>
						% if ohloh_data:
							<a href=
							'http://www.ohloh.net/accounts/
							${ohloh_data['id']}?ref=Detailed'
							target='_top'>
							<img
								alt='Ohloh Profile'
								border='0' height='35'
								src='http://www.ohloh.net/accounts/
									${ohloh_data['id']}
									/widgets/account_detailed.gif'
								width='191' />
							</a>
						% else:
						Not available.
						% endif
						</td></tr>
					<tr><td>Ohloh Rank:</td>
						<td>
						% if ohloh_data:
							${ohloh_data['position']}
						% else:
							?
						% endif
						</td></tr>
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
							data-coderwall-orientation="horizontal"></section>
						</td>
					</tr>
					% endif
				</table>
			</div>
			<div class="clear"></div>
			<div class="grid_12">
				<h2>Information</h2>
			</div>
			<div class="clear"></div>
			<div class="grid_4">
				<table>
				<tr><td>FAS Affiliation</td>
						<td>
						% if fedora_data:
							${fedora_data['affiliation']}
						% else:
							?
						% endif
						</td></tr>
					<tr><td>FAS Status</td>
						<td>
						% if fedora_data:
							${fedora_data['status']}
						% else:
							?
						% endif
						</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
				</table>
			</div>
			<div class="grid_4">
				<table>
				</table>
			</div>
			<div class="clear"></div>

			<!-- RECENT GITHUB ACTIVITY -->

			<div class="grid_12">
				% if github_data:
					<h2>Recent GitHub Activity</h2>
					<div id="activity-controls">
					<a href="#" class="button" id="less-activity">Less</a>
					<a href="#" class="button" id="more-activity">More</a>
					</div>
					<ul id="recent-activity">
					% for event in github_data['recent_events']:
						<% repo_url = "https://github.com/" \
							+ event['repo']['name'] %>
						% if event['type'] == 'PushEvent':
							<li class="event push-event">
								Pushed ${event['payload']['size']} commit(s)
								to <a href="${repo_url}">
								${event['repo']['name']}</a>.
							</li>
						% elif event['type'] == 'IssuesEvent':
							<li class="event issues-event">
								${event['payload']['action'].capitalize()}
								issue
							<a href="${event['payload']['issue']['html_url']}">
								${event['payload']['issue']['title']}</a>
								in the
								<a href="${repo_url}">
								${event['repo']['name']}
								</a> repo.
							</li>
						% elif event['type'] == 'IssueCommentEvent':
							<li class="event comment-event">
								Commented on
							<a href="${event['payload']['issue']['html_url']}">
								${event['payload']['issue']['title']}</a>
								in the
								<a href="${repo_url}">
								${event['repo']['name']}
								</a> repo.
							</li>
						% elif event['type'] == 'CreateEvent':
							<li class="event create-event">
								Created
								${event['payload']['ref_type']}
								${event['payload']['ref']} in the
								<a href="${repo_url}">
								${event['repo']['name']}
								</a> repo.
							</li>
						% elif event['type'] == 'DeleteEvent':
							<li class="event delete-event">
								Deleted
								${event['payload']['ref_type']}
								${event['payload']['ref']} in the
								<a href="${repo_url}">
								${event['repo']['name']}
								</a> repo.
							</li>
						% elif event['type'] == 'WatchEvent':
							<li class="event social-event">
								${event['payload']['action'].capitalize()}
								watching
								<a href="${repo_url}">
								${event['repo']['name']}</a>.
							</li>
						% elif event['type'] == 'FollowEvent':
							<li class="event social-event">
								Started following
								<a href=
									"${event['payload']['target']['html_url']}">
								${event['payload']['target']['login']}</a>.
							</li>
						% elif event['type'] == 'GistEvent':
							<li class="event create-event">
								<% action = (
									event['payload']['action'] + 'ed'
									).capitalize() %>
								${action} gist <a href=
								"${event['payload']['gist']['html_url']}">
								${event['payload']['gist']['description']}</a>.
							</li>
						% elif event['type'] == 'PullRequestEvent':
							<li class="event create-event">
								<% action = (
									event['payload']['action']
									).capitalize() %>
								${action} pull request
								<a href=
				"${event['payload']['pull_request']['_links']['html']['href']}">
							${event['payload']['pull_request']['title']}</a>
								in the
								<a href="${repo_url}">
								${event['repo']['name']}
								</a> repo.
							</li>
						% elif event['type'] == 'CommitCommentEvent':
							<li class="event comment-event">
								Commented on
							<a href=
							"${event['payload']['comment']['html_url']}">
								a commit</a> in the
								<a href="${repo_url}">
								${event['repo']['name']}
								</a> repo.
							</li>
						% elif event['type'] == "ForkEvent":
							<li class="event create-event">
								Forked
								<a href="${repo_url}">
								${event['repo']['name']}</a>.
							</li>
						% else:
							<li class="event other-event">
								Performed
								${event['type']}
								on <a href="${repo_url}">
								${event['repo']['name']}</a>.
							</li>
						% endif
					% endfor
					</ul>
				% else:
					<p>Add your GitHub username to see your recent commits.</p>
				% endif
			</div>
			<div class="clear"></div>

			<!-- CODERWALL ACHIEVEMENTS -->

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
