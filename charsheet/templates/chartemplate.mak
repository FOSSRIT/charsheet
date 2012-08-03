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
		<script type='text/javascript'
	src='${request.static_url('charsheet:static/js/jquery.dimensions.js')}'>
		</script>
		<script type='text/javascript'
	src='${request.static_url('charsheet:static/js/jquery.delegate.js')}'>
		</script>
		<script type='text/javascript'
	src='${request.static_url('charsheet:static/js/jquery.bgiframe.js')}'>
		</script>
		<script type='text/javascript'
		src='${request.static_url('charsheet:static/js/jquery.tooltip.js')}'>
		</script>
<link href='${request.static_url('charsheet:static/css/jquery.tooltip.css')}'
			rel='stylesheet' type='text/css'>
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
					<tr><td>Hireable?</td><td>
						% if github_data:
							% if github_data['hireable'] == True:
							Yes!
							% else:
							No...
							% endif
						% endif
						</td></tr>
					<tr><td>GitTip</td><td>
						% if github_data:
							<iframe style="border: 0; margin: 0; padding: 0;"
							src="https://www.gittip.com/${username}/widget.html"
							width="48pt" height="20pt"></iframe>
						% else:
							Unavailable
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
					<tr class="tooltip"
						title="Strength - 
						Determined by lines in GitHub repos, questions answered
						on Stack Exchange, and CoderWall badges.">
						<td>Strength:</td>
						<td>${int(stats['strength'])}<progress max="1"
								value="${stats['strength'] % 1}">
						</progress></td></tr>
					<tr class="tooltip"
						title="Dexterity - 
						Determined by GitHub language variety and variety of
						tags on all answered Stack Exchange questions.">
						<td>Dexterity:</td>
						<td>${int(stats['dexterity'])}<progress max="1"
								value="${stats['dexterity'] % 1}">
						</progress></td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr class="tooltip"
						title="Wisdom - 
						Determined by age of oldest linked account, between
						GitHub, Ohloh, and Stack Exchange.">
						<td>Wisdom:</td>
						<td>${int(stats['wisdom'])}<progress max="1"
								value="${stats['wisdom'] % 1}">
						</progress></td></tr>
					<tr class="tooltip"
						title="Leadership - 
						Determined by number of times your GitHub repos have
						been forked and amount of top answers on
						Stack Exchange.">
						<td>Leadership:</td>
						<td>${int(stats['leadership'])}<progress max="1"
								value="${stats['leadership'] % 1}">
						</progress></td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr class="tooltip"
						title="Determination - 
						Determined (ha-ha) by number of repos in your
						GitHub account.">
						<td>Determination:</td>
						<td>${int(stats['determination'])}<progress max="1"
								value="${stats['determination'] % 1}">
						</progress></td></tr>
					<tr class="tooltip"
						title="Popularity - 
						Determined by number of GitHub followers and Stack
						Exchange reputation."><td>Popularity:</td>
						<td>${int(stats['popularity'])}<progress max="1"
								value="${stats['popularity'] % 1}">
						</progress></td></tr>
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
					<tr><td>C</td>
						<td>${int(stats['skills']['c'])}<progress max="1"
							value="${stats['skills']['c'] % 1}">
							</progress></td></tr>
					<tr><td>C++</td><td>${stats['skills']['c++']}</td></tr>
					<tr><td>Java</td><td>${stats['skills']['java']}</td></tr>
					<tr><td>HTML</td><td>${stats['skills']['html']}</td></tr>
					<tr><td>XML</td><td>${stats['skills']['xml']}</td></tr>
					<tr><td>Python</td>
						<td>${stats['skills']['python']}</td></tr>
					<tr><td>PHP</td><td>${stats['skills']['php']}</td></tr>
					<tr><td>JavaScript</td>
						<td>${stats['skills']['javascript']}</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Perl</td><td>${stats['skills']['perl']}</td></tr>
					<tr><td>Shell</td><td>${stats['skills']['shell']}</td></tr>
					<tr><td>Objective-C</td>
						<td>${stats['skills']['objective-c']}</td></tr>
					<tr><td>Ruby</td><td>${stats['skills']['ruby']}</td></tr>
					<tr><td>Haskell</td>
						<td>${stats['skills']['haskell']}</td></tr>
					<tr><td>Lua</td>
						<td>${stats['skills']['lua']}</td></tr>
					<tr><td>Assembly</td>
						<td>${stats['skills']['assembly']}</td></tr>
					<tr><td>Common Lisp</td>
						<td>${stats['skills']['commonlisp']}</td></tr>
				</table>
			</div>
			<div class="grid_4">
				<table>
					<tr><td>Scala</td>
						<td>${stats['skills']['scala']}</td></tr>
					<tr><td>Visual Basic</td>
						<td>${stats['skills']['visualbasic']}</td></tr>
					<tr><td>Arduino</td>
						<td>${stats['skills']['arduino']}</td></tr>
					<tr><td>Erlang</td>
						<td>${stats['skills']['erlang']}</td></tr>
					<tr><td>Go</td>
						<td>${stats['skills']['go']}</td></tr>
					<tr><td>CoffeeScript</td>
						<td>${stats['skills']['coffeescript']}</td></tr>
					<tr><td>Emacs Lisp</td>
						<td>${stats['skills']['emacslisp']}</td></tr>
					<tr><td>VimL</td>
						<td>${stats['skills']['viml']}</td></tr>
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
							${github_data['total_lines_formatted']}
						% else:
							?
						% endif
						</td></tr>
					<tr><td>Top Languages by Repos:</td><td>
						% if github_data:
							% for i in range(3):
								${github_data['languages_count'][i][0]},
							% endfor
						% else:
							?
						% endif
						</td></tr>
					<tr><td>Top Languages by Klocs:</td><td>
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
				<tr><td>FAS Affiliation:</td>
						<td>
						% if fedora_data:
							${fedora_data['affiliation']}
						% else:
							?
						% endif
						</td></tr>
					<tr><td>FAS Status:</td>
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
					<div class="activity-controls">
					<a href="#" class="button less-activity">Less</a>
					<a href="#" class="button more-activity">More</a>
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
								${event['repo']['name']}</a> repo.
							</li>
						% elif event['type'] == 'CommitCommentEvent':
							<li class="event comment-event">
								Commented on
							<a href=
							"${event['payload']['comment']['html_url']}">
								a commit</a> in the
								<a href="${repo_url}">
								${event['repo']['name']}</a> repo.
							</li>
						% elif event['type'] == 'DownloadEvent':
							<li class="event push-event">
								Created a download in the
								<a href="${repo_url}">
								${event['repo']['name']}</a> repo.
							</li>
						% elif event['type'] == "ForkEvent":
							<li class="event create-event">
								Forked
								<a href="${repo_url}">
								${event['repo']['name']}</a>.
							</li>
						% elif event['type'] == 'ForkApplyEvent':
							<li class="event create-event">
								Applied a patch in the fork queue for the
								<a href="${repo_url}">
								${event['repo']['name']}</a> repo.
							</li>
						% elif event['type'] == "GollumEvent":
							<li class="event comment-event">
								Edited the wiki of the
								<a href="${repo_url}">
								${event['repo']['name']}</a> repo.
							</li>
						% elif event['type'] == "MemberEvent":
							<li class="event social-event">
								Was added as a collaborator in the
								<a href="${repo_url}">
								${event['repo']['name']}</a> repo.
							</li>
						% elif event['type'] == "PublicEvent":
							<li class="event create-event">
								Open-sourced the
								<a href="${repo_url}">
								${event['repo']['name']}</a> repo!!!
							</li>
						% elif event['type'] == "PullRequestReviewCommentEvent":
							<li class="event comment-event">
								Commented on
					<a href=
					"${event['payload']['comment']['_links']['html']['href']}">
								a pull request</a> in the
								<a href="${repo_url}">
								${event['repo']['name']}
								</a> repo.
							</li>
						% elif event['type'] == "TeamAddEvent":
							<li class="event social-event">
								Modified a team.
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
					<div class="activity-controls">
					<a href="#" class="button less-activity">Less</a>
					<a href="#" class="button more-activity">More</a>
					</div>
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
					% for badge in coderwall_data['cwc'].badges:
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
