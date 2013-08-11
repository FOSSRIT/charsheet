<%inherit file="base.mak"/>

<% display_sheet = False %>
<% flash = request.session.pop_flash() %>
<% alert_y = 20 %>
% for message in flash:
    % if message.startswith('Error:'):
        <div style="top: ${alert_y}px" class="alert alert-error">
            <h4 class="alert-heading">Error</h4><p>${message[7:]}</p>
        </div>
    % else:
        <div style="top: ${alert_y}px" class="alert alert-success">
            <h4 class="alert-heading">Success</h4><p>${message}</p>
        </div>
        <% display_sheet = True %>
    % endif
    <% alert_y += 110 %>
% endfor

<div class="container_12">
    <div class="grid_6">
    <h2>Your Charsheet</h2>
    <p>If all went well, your developer character sheet has been
        generated below. In the future, you will be able easily save
        and share your charsheet.</p>
    </div>
    <div class="grid_6">
    <h2>Information</h2>
    <p>Charsheet generated at ${stats['timestamp']}.</p>
    <p>
      <a class='button' href="/">Back</a>
      <a
        href='/submit?${'&'.join(['charsheetform:'+backend+'='+username for backend, username in stats['usernames'].items()])}'
        class='button'>Refresh</a>
    </p>
    </div>
</div>
% if display_sheet == True:
<div class="container_12 sheet_parent">
<div class="sheet">
<h1>Character Record Sheet</h1>
    <div class="clear"></div>

    <!-- GENERAL INFORMATION -->

    <div class="grid_4">
        <table>
        <tr>
        <td>
        % if stats:
            <img class="avatar" src="${stats.get('gravatar')}" />
        % else:
            Username:
        % endif
        </td>
            <td>${stats.name}</td>
        </tr>
        <tr class="tooltip" id="foo" title="<strong>Foo</strong>
            - Foo is the average
            of your six attribute scores.<br />
            <strong>${int((stats['stats']['foo'] % 1) * 100)}%</strong>
            to next level">
            <td>Foo:</td><td>${int(stats['stats']['foo'])}</td></tr>
        <tr class="tooltip" title="<strong>Foo Bar</strong>
            - Your Foo Bar shows
            your progress towards the next level of Foo.<br />
            <strong>${int((stats['stats']['foo'] % 1) * 100)}%</strong>
            to next level"><td>Foo Bar:</td>
            <td>
            <progress max="1" value="${stats['stats']['foo'] % 1}">
                </progress></td></tr>
        </table>
    </div>
    <div class="grid_4">
        <table class="one-line">
            <tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_003_user.png')}'/> Name:</td><td>
                % if stats:
                    ${stats['name']}
                % else:
                    ?
                % endif
            </td></tr>
            <tr class="one-line"><td><img src='${request.static_url('charsheet:static/icons/glyphicons_010_envelope.png')}'/> Email:</td><td>
                % if stats['github'].get('email'):
                    ${stats['github']['email']}
                % else:
                    ?
                % endif
            </td></tr>
            <tr><td><img src='${request.static_url('charsheet:static/icons/glyphicons_235_pen.png')}'/> Blog:</td><td>
                % if stats:
                    % if stats['github'].get('blog'):
                    <a href="http://${stats['github']['blog']}">
                        ${stats['github']['blog'].strip('/')}</a>
                    % else:
                    None
                    % endif
                % else:
                    ?
                % endif
                </td></tr>
            <tr>
            <td colspan="2">
            Charsheet ${int(stats['stats']['percent_complete'] * 100)}% complete.
            </td>
            </tr>
        </table>
    </div>
    <div class="grid_4">
        <table class="one-line">
            <tr class="one-line"><td><img src='${request.static_url('charsheet:static/icons/glyphicons_340_globe.png')}'/> Location:</td>
                <td>
                % if stats['github'].get('location'):
                    ${stats['github']['location']}
                % else:
                    ?
                % endif
                </td></tr>
            <tr class="one-line"><td><img src='${request.static_url('charsheet:static/icons/glyphicons_341_briefcase.png')}'/> Company:</td><td>
                % if stats['github'].get('company'):
                    ${stats['github']['company']}
                % else:
                    ?
                % endif
                </td></tr>
            <tr><td>Hireable?</td><td>
                % if stats['github'].get('hireable'):
                    Yes!
                % else:
                    No...
                % endif
                </td></tr>
            <tr><td>GitTip:</td><td>
                % if stats:
                    <iframe style="vertical-align: middle;
                            border: 0; margin: 0; padding: 0;"
        src="https://www.gittip.com/${stats['usernames']['github']}/widget.html"
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
                title="<strong>Strength</strong><br />
                (${stats['ohloh']['lines']} lines / 1000000)
                    <br />+ (2 * ${len(stats['coderwall']['badges'])} badge(s))<br />
                <strong>${int((stats['stats']['strength'] % 1) * 100)}%</strong>
                to next level">
                <td>Strength:</td>
                <td>${int(stats['stats']['strength'])}<progress max="1"
                        value="${stats['stats']['strength'] % 1}">%
                </progress></td></tr>
            <tr class="tooltip"
                title="<strong>Dexterity</strong><br />
                5 * ${len(stats['ohloh']['languages_by_lines'])} language(s)
                <br />
            <strong>${int((stats['stats']['dexterity'] % 1) * 100)}%</strong>
            to next level">
                <td>Dexterity:</td>
                <td>${int(stats['stats']['dexterity'])}<progress max="1"
                        value="${stats['stats']['dexterity'] % 1}">
                </progress></td></tr>
        </table>
    </div>
    <div class="grid_4">
        <table>
            <tr class="tooltip"
                title="<strong>Wisdom</strong><br />
                ${round(stats['stats']['age_months'], 2)} month(s)
                <br />
            <strong>${int((stats['stats']['wisdom'] % 1) * 100)}%</strong>
            to next level">
                <td>Wisdom:</td>
                <td>${int(stats['stats']['wisdom'])}<progress max="1"
                        value="${stats['stats']['wisdom'] % 1}">
                </progress></td></tr>
            <tr class="tooltip"
                title="<strong>Leadership</strong><br />
                ${stats['github']['forks']} fork(s)<br />
            <strong>${int((stats['stats']['leadership'] % 1) * 100)}%</strong>
            to next level">
                <td>Leadership:</td>
                <td>${int(stats['stats']['leadership'])}<progress max="1"
                        value="${stats['stats']['leadership'] % 1}">
                </progress></td></tr>
        </table>
    </div>
    <div class="grid_4">
        <table>
            <tr class="tooltip"
                title="<strong>Determination</strong><br />
                ${len(stats['github']['public_repos'])} public repo(s)<br />
            <strong>${int((stats['stats']['determination'] % 1) * 100)}%</strong>
            to next level">
                <td>Determination:</td>
                <td>${int(stats['stats']['determination'])}<progress max="1"
                        value="${stats['stats']['determination'] % 1}">
                </progress></td></tr>
            <tr class="tooltip"
                title="<strong>Popularity</strong><br />
                ${stats['github']['followers']} follower(s)<br />
            <strong>${int((stats['stats']['popularity'] % 1) * 100)}%</strong>
            to next level"><td>Popularity:</td>
                <td>${int(stats['stats']['popularity'])}<progress max="1"
                        value="${stats['stats']['popularity'] % 1}">
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
        ${self.skill_block(['C', 'C++', 'Java', 'HTML', 'XML', 'Python', 'PHP', 'JavaScript'])}
        ${self.skill_block(['Perl', 'Shell', 'Objective-C', 'Ruby', 'Haskell', 'Lua', 'Assembly', 'Common Lisp'])}
        ${self.skill_block(['Scala', 'Visual Basic', 'Arduino', 'Erlang', 'Go', 'CoffeeScript', 'Emacs Lisp', 'VimL'])}
        <div class="clear"></div>

    <!-- STATISTICS  -->

    <div class="grid_12">
        <h2>Statistics</h2>
    </div>
    <div class="clear"></div>
    <div class="grid_4">
        <table>
            <tr><td>Public GitHub Repos:</td>
                <td>
                % if stats['github'].get('public_repos'):
                    ${len(stats['github']['public_repos'])}
                % else:
                    ?
                % endif
                </td></tr>
            <tr><td>Lines Committed:</td>
                <td>
                % if stats['ohloh'].get('lines'):
                    ${stats['ohloh']['lines']}
                % else:
                    ?
                % endif
                </td></tr>
            <tr><td>Most Repos:</td><td>
                % if stats['github'].get('languages_by_repos'):
    ${", ".join([lang for lang in stats['github']['languages_by_repos'][:3]])}
                % else:
                    ?
                % endif
                </td></tr>
            <tr><td>Most Code:</td><td>
                % if stats['ohloh'].get('languages_by_lines'):
    ${", ".join([lang['name'] for lang in stats['ohloh']['languages_by_lines'][:3]])}
                % else:
                    ?
                % endif
                </td></tr>
        </table>
    </div>
    <div class="grid_4">
        <table>
            <tr><td>Ohloh Profile:</td><td>
                % if stats['ohloh'].get('id'):
                    <a
                        href='http://www.ohloh.net/accounts/${stats['ohloh']['id']}?ref=Detailed'
                        target='_top'>
                    <img
                        alt='Ohloh Profile'
                        border='0' height='35'
                        src='http://www.ohloh.net/accounts/${stats['ohloh']['id']}/widgets/account_detailed.gif'
                        width='191' />
                    </a>
                % else:
                Not available.
                % endif
                </td></tr>
            <tr><td>Ohloh Rank:</td>
                <td>
                % if stats['ohloh'].get('position'):
                    ${stats['ohloh']['position']}
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
                % if stats['usernames'].get('coderwall'):
            <a href="http://coderwall.com/${stats['usernames']['coderwall']}">
                <img alt="Endorse ${stats['usernames']['coderwall']}
                        on Coderwall"
                    src="http://api.coderwall.com/${stats['usernames']['coderwall']}/endorsecount.png" />
                % else:
                    ?
                % endif
                </td>
            </tr>
        </table>
    </div>

    <div class="clear"></div>

    <!-- CODERWALL ACHIEVEMENTS -->

    <div class="grid_12">
        % if stats['coderwall'].get('badges'):
        <h2>Coderwall Achievements</h2>
        <table class="badge-list">
            <% badges_printed = 0 %>
            <tr>
            % for badge in stats['coderwall']['badges']:
                <td class="tooltip"
                    title="<strong>${badge['name']}</strong>
                    - ${badge['description']}.">
                    <img src="${badge['image_uri']}"/></td>
                <% badges_printed += 1 %>
                % if (badges_printed % 8 == 0) and badges_printed > 0:
                    </tr><tr>
                % endif
            % endfor
            </tr>
        </table>
        % else:
        <p>Add your Coderwall username to see your badges.</p>
        % endif
    </div>
    <div class="clear"></div>

    <!-- RECENT GITHUB ACTIVITY -->

    <div class="grid_12">
        % if stats['github'].get('name'):
            <h2>Recent GitHub Activity</h2>
            <div class="activity-controls">
            <a href="#" class="button less-activity">Less</a>
            <a href="#" class="button more-activity">More</a>
            </div>
            <ul id="recent-activity">
            % for event in stats['github']['recent_events']:
                <% repo_url = "https://github.com/"+event.repo.name %>
                <li class="event ${event.type}">
                <span class='timestamp'>${event.created_at}</span>
                <span class='details'>
                % if event.type == 'PushEvent':
                    Pushed ${event.payload['size']} commit(s) to
                % elif event.type == 'IssuesEvent':
                    ${event.payload['action'].capitalize()} issue
                    <a href="${event.payload['issue']['html_url']}">
                    ${event.payload['issue']['title']}</a> in
                % elif event.type == 'IssueCommentEvent':
                    Commented on
                    <a href="${event.payload['issue']['html_url']}">
                    ${event.payload['issue']['title']}</a> in
                % elif event.type == 'CreateEvent':
                    Created ${event.payload['ref_type']}
                    ${event.payload['ref']} in
                % elif event.type == 'DeleteEvent':
                    Deleted ${event.payload['ref_type']}
                    ${event.payload['ref']} in
                % elif event.type == 'WatchEvent':
                    ${event.payload['action'].capitalize()} watching
                % elif event.type == 'FollowEvent':
                    Started following
                    <a href="${event.payload['target']['html_url']}">
                    ${event.payload['target']['login']}</a>.
                % elif event.type == 'GistEvent':
                    <% action = (event.payload['action'] + 'ed').capitalize() %>
                    ${action} gist
                    <a href="${event.payload['gist']['html_url']}">
                    ${event.payload['gist']['description']}</a>.
                % elif event.type == 'PullRequestEvent':
                    <% action = (event.payload['action']).capitalize() %>
                    ${action} pull request
                    <a href="${event.payload['pull_request']['_links']['html']['href']}">
                    ${event.payload['pull_request']['title']}</a> in
                % elif event.type == 'CommitCommentEvent':
                    Commented on
                    <a href="${event.payload['comment']['html_url']}">
                    a commit</a> in
                % elif event.type == 'DownloadEvent':
                    Created a download in
                % elif event.type == "ForkEvent":
                    Forked
                % elif event.type == 'ForkApplyEvent':
                    Applied a patch in the fork queue for
                % elif event.type == "GollumEvent":
                    Edited the wiki of
                % elif event.type == "MemberEvent":
                    Was added as a collaborator to
                % elif event.type == "PublicEvent":
                    Open-sourced
                % elif event.type == "PullRequestReviewCommentEvent":
                    Commented on
                    <a href="${event.payload['comment']['_links']['html']['href']}">
                    a pull request</a> in
                % elif event.type == "TeamAddEvent":
                    Modified a team.
                % else:
                    Performed ${event.type} on
                % endif
                % if not event.repo.name == '/':
                    <a href="${repo_url}">${event.repo.name}</a>.
                % endif
                </span>
                </li>
            % endfor
            </ul>
            <div class="activity-controls">
            <a href="#" class="button less-activity">Less</a>
            <a href="#" class="button more-activity">More</a>
            </div>
        % else:
            <p>Add your GitHub username to see your recent activity.</p>
        % endif
    </div>
</div>
</div>
</div>
% endif

<%def name='head()'>
  <link href='${request.static_url('charsheet:static/css/charsheet.css')}' rel='stylesheet' type='text/css'>
  <script src='${request.static_url('charsheet:static/js/charsheet.js')}'></script>
  <script src='${request.static_url('charsheet:static/js/jquery.tipTip.js')}'>
  </script>
  <link href='${request.static_url('charsheet:static/css/tipTip.css')}'
        media='all' rel='stylesheet' type='text/css'>
  % if coderwall_data:
    <link href='http://coderwall.com/stylesheets/jquery.coderwall.css'
          media='all' rel='stylesheet' type='text/css'>
    <script src='http://coderwall.com/javascripts/jquery.coderwall.js'>
    </script>
  % endif
</%def>

<%def name='title()'>Character Sheet for ${stats.name}</%def>

<%def name='skill_block(skills)'>
  <div class="grid_4">
    <table>
      % for skill in skills:
        <% slugged_skill = skill.lower().replace(' ', '') %>
        <tr>
          <td>${skill}</td>
          <td>${int(stats['stats']['skills'][slugged_skill])}
            <progress max="1" value="${stats['stats']['skills'][slugged_skill] % 1}">
            </progress>
          </td>
        </tr>
      % endfor
    </table>
  </div>
</%def>
