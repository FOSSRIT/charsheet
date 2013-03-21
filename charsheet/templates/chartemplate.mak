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
        <link href='${request.static_url('charsheet:static/css/app.css')}'          rel='stylesheet' type='text/css'>
        <link href='${request.static_url('charsheet:static/css/charsheet.css')}'            rel='stylesheet' type='text/css'>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
        <script src='${request.static_url('charsheet:static/js/charsheet.js')}'></script>
        <script
        src='${request.static_url('charsheet:static/js/jquery.tipTip.js')}'>
        </script>
        <link href='${request.static_url('charsheet:static/css/tipTip.css')}'
                media='all' rel='stylesheet' type='text/css'>
        % if coderwall_data:
            <link href='http://coderwall.com/stylesheets/jquery.coderwall.css'
                media='all' rel='stylesheet' type='text/css'>
            <script src='http://coderwall.com/javascripts/jquery.coderwall.js'>
                </script>
        % endif
        <title>Character Sheet for ${stats.name}</title>
    </head>
    <body>
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

        <!-- Header logo -->
        <a href=".."><h1 class="logo-text"><img class='logo' alt='Charsheet logo'
            src='${request.static_url('charsheet:static/img/icon_64x64.png')}' />
        Charsheet</h1></a>
        <!-- End header logo -->

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
                        5 * ${len(stats['ohloh']['languages'])} language(s)
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
            <div class="grid_4">
                <table>
                    <tr><td>C</td>
                        <td>${int(stats['stats']['skills']['c'])}<progress max="1"
                            value="${stats['stats']['skills']['c'] % 1}">
                            </progress></td></tr>
                    <tr><td>C++</td>
                        <td>${int(stats['stats']['skills']['c++'])}<progress max="1"
                            value="${stats['stats']['skills']['c++'] % 1}">
                            </progress></td></tr>
                    <tr><td>Java</td>
                        <td>${int(stats['stats']['skills']['java'])}<progress max="1"
                            value="${stats['stats']['skills']['java'] % 1}">
                            </progress></td></tr>
                    <tr><td>HTML</td>
                        <td>${int(stats['stats']['skills']['html'])}<progress max="1"
                            value="${stats['stats']['skills']['html'] % 1}">
                            </progress></td></tr>
                    <tr><td>XML</td>
                        <td>${int(stats['stats']['skills']['xml'])}<progress max="1"
                            value="${stats['stats']['skills']['xml'] % 1}">
                            </progress></td></tr>
                    <tr><td>Python</td>
                        <td>${int(stats['stats']['skills']['python'])}<progress max="1"
                            value="${stats['stats']['skills']['python'] % 1}">
                            </progress></td></tr>
                    <tr><td>PHP</td>
                        <td>${int(stats['stats']['skills']['php'])}<progress max="1"
                            value="${stats['stats']['skills']['php'] % 1}">
                            </progress></td></tr>
                    <tr><td>JavaScript</td>
                        <td>${int(stats['stats']['skills']['javascript'])}
                            <progress max="1"
                            value="${stats['stats']['skills']['javascript'] % 1}">
                            </progress></td></tr>
                </table>
            </div>
            <div class="grid_4">
                <table>
                    <tr><td>Perl</td>
                        <td>${int(stats['stats']['skills']['perl'])}<progress max="1"
                            value="${stats['stats']['skills']['perl'] % 1}">
                            </progress></td></tr>
                    <tr><td>Shell</td>
                        <td>${int(stats['stats']['skills']['shell'])}<progress max="1"
                            value="${stats['stats']['skills']['shell'] % 1}">
                            </progress></td></tr>
                    <tr><td>Objective-C</td>
                        <td>${int(stats['stats']['skills']['objective-c'])}
                            <progress max="1"
                            value="${stats['stats']['skills']['objective-c'] % 1}">
                            </progress></td></tr>
                    <tr><td>Ruby</td>
                        <td>${int(stats['stats']['skills']['ruby'])}<progress max="1"
                            value="${stats['stats']['skills']['ruby'] % 1}">
                            </progress></td></tr>
                    <tr><td>Haskell</td>
                        <td>${int(stats['stats']['skills']['haskell'])}<progress max="1"
                            value="${stats['stats']['skills']['haskell'] % 1}">
                            </progress></td></tr>
                    <tr><td>Lua</td>
                        <td>${int(stats['stats']['skills']['lua'])}<progress max="1"
                            value="${stats['stats']['skills']['lua'] % 1}">
                            </progress></td></tr>
                    <tr><td>Assembly</td>
                        <td>${int(stats['stats']['skills']['assembly'])}<progress max="1"
                            value="${stats['stats']['skills']['assembly'] % 1}">
                            </progress></td></tr>
                    <tr><td>Common Lisp</td>
                        <td>${int(stats['stats']['skills']['commonlisp'])}
                            <progress max="1"
                            value="${stats['stats']['skills']['commonlisp'] % 1}">
                            </progress></td></tr>
                </table>
            </div>
            <div class="grid_4">
                <table>
                    <tr><td>Scala</td>
                        <td>${int(stats['stats']['skills']['scala'])}<progress max="1"
                            value="${stats['stats']['skills']['scala'] % 1}">
                            </progress></td></tr>
                    <tr><td>Visual Basic</td>
                        <td>${int(stats['stats']['skills']['visualbasic'])}
                            <progress max="1"
                            value="${stats['stats']['skills']['visualbasic'] % 1}">
                            </progress></td></tr>
                    <tr><td>Arduino</td>
                        <td>${int(stats['stats']['skills']['arduino'])}<progress max="1"
                            value="${stats['stats']['skills']['arduino'] % 1}">
                            </progress></td></tr>
                    <tr><td>Erlang</td>
                        <td>${int(stats['stats']['skills']['erlang'])}<progress max="1"
                            value="${stats['stats']['skills']['erlang'] % 1}">
                            </progress></td></tr>
                    <tr><td>Go</td>
                        <td>${int(stats['stats']['skills']['go'])}<progress max="1"
                            value="${stats['stats']['skills']['go'] % 1}">
                            </progress></td></tr>
                    <tr><td>CoffeeScript</td>
                        <td>${int(stats['stats']['skills']['coffeescript'])}
                            <progress max="1"
                            value="${stats['stats']['skills']['coffeescript'] % 1}">
                            </progress></td></tr>
                    <tr><td>Emacs Lisp</td>
                        <td>${int(stats['stats']['skills']['emacslisp'])}
                            <progress max="1"
                            value="${stats['stats']['skills']['emacslisp'] % 1}">
                            </progress></td></tr>
                    <tr><td>VimL</td>
                        <td>${int(stats['stats']['skills']['viml'])}<progress max="1"
                            value="${stats['stats']['skills']['viml'] % 1}">
                            </progress></td></tr>
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
                % if stats:
                    <h2>Recent GitHub Activity</h2>
                    <div class="activity-controls">
                    <a href="#" class="button less-activity">Less</a>
                    <a href="#" class="button more-activity">More</a>
                    </div>
                    <ul id="recent-activity">
                    % for event in stats['github'].get('recent_events'):
                        <% repo_url = "https://github.com/"+event.repo.name %>
                        % if event.type == 'PushEvent':
                            <li class="event push-event">
                                Pushed ${event.payload['size']} commit(s)
                                to <a href="${repo_url}">
                                ${event.repo.name}</a>.
                            </li>
                        % elif event.type == 'IssuesEvent':
                            <li class="event issues-event">
                                ${event.payload['action'].capitalize()}
                                issue
                            <a href="${event.payload['issue']['html_url']}">
                                ${event.payload['issue']['title']}</a>
                                in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == 'IssueCommentEvent':
                            <li class="event comment-event">
                                Commented on
                            <a href="${event.payload['issue']['html_url']}">
                                ${event.payload['issue']['title']}</a>
                                in the
                                <a href="${repo_url}">${event.repo.name}</a>
                                repo.
                            </li>
                        % elif event.type == 'CreateEvent':
                            <li class="event create-event">
                                Created
                                ${event.payload['ref_type']}
                                ${event.payload['ref']} in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == 'DeleteEvent':
                            <li class="event delete-event">
                                Deleted
                                ${event.payload['ref_type']}
                                ${event.payload['ref']} in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == 'WatchEvent':
                            <li class="event social-event">
                                ${event.payload['action'].capitalize()}
                                watching
                                <a href="${repo_url}">
                                ${event.repo.name}</a>.
                            </li>
                        % elif event.type == 'FollowEvent':
                            <li class="event social-event">
                                Started following
                                <a href=
                                    "${event.payload['target']['html_url']}">
                                ${event.payload['target']['login']}</a>.
                            </li>
                        % elif event.type == 'GistEvent':
                            <li class="event create-event">
                                <% action = (
                                    event.payload['action'] + 'ed'
                                    ).capitalize() %>
                                ${action} gist <a href=
                                "${event.payload['gist']['html_url']}">
                                ${event.payload['gist']['description']}</a>.
                            </li>
                        % elif event.type == 'PullRequestEvent':
                            <li class="event create-event">
                                <% action = (
                                    event.payload['action']
                                    ).capitalize() %>
                                ${action} pull request
                                <a href=
                "${event.payload['pull_request']['_links']['html']['href']}">
                            ${event.payload['pull_request']['title']}</a>
                                in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == 'CommitCommentEvent':
                            <li class="event comment-event">
                                Commented on
                            <a href=
                            "${event.payload['comment']['html_url']}">
                                a commit</a> in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == 'DownloadEvent':
                            <li class="event push-event">
                                Created a download in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == "ForkEvent":
                            <li class="event create-event">
                                Forked
                                <a href="${repo_url}">
                                ${event.repo.name}</a>.
                            </li>
                        % elif event.type == 'ForkApplyEvent':
                            <li class="event create-event">
                                Applied a patch in the fork queue for the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == "GollumEvent":
                            <li class="event comment-event">
                                Edited the wiki of the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == "MemberEvent":
                            <li class="event social-event">
                                Was added as a collaborator in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == "PublicEvent":
                            <li class="event create-event">
                                Open-sourced the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo!!!
                            </li>
                        % elif event.type == "PullRequestReviewCommentEvent":
                            <li class="event comment-event">
                                Commented on
                    <a href=
                    "${event.payload['comment']['_links']['html']['href']}">
                                a pull request</a> in the
                                <a href="${repo_url}">
                                ${event.repo.name}</a> repo.
                            </li>
                        % elif event.type == "TeamAddEvent":
                            <li class="event social-event">
                                Modified a team.
                            </li>
                        % else:
                            <li class="event other-event">
                                Performed
                                ${event.type}
                                on <a href="${repo_url}">
                                ${event.repo.name}</a>.
                            </li>
                        % endif
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
        <div class="container_12">
            <div class="grid_12">
                <div class="footer">
                <a rel="license"
                    href="http://creativecommons.org/licenses/by/3.0/">
                        <img alt="Creative Commons License"
                        style="border-width:0"
                    src="${request.static_url('charsheet:static/img/cc30.png')}" />
                </a>
                <br />This work is licensed under a
                <a rel="license" href="http://creativecommons.org/licenses/by/3.0/">
                Creative Commons Attribution 3.0 Unported License</a>.
                Code freely available
                <a href="https://github.com/FOSSRIT/charsheet">on GitHub</a>.
                </div>
            </div>
        </div>
        </div>
        % endif
    </body>
</html>
