from pyramid.httpexceptions import (
    HTTPFound,
    HTTPNotFound,
    )
from pyramid.response import Response
from pyramid.view import view_config
from pyramid.security import (
    authenticated_userid,
    remember,
    forget,
)

import json
import operator
import urllib
import urllib2

import forms


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {
        'charsheet_form': forms.CharsheetForm,
    }


@view_config(route_name='login', renderer='login.mak')
def login(request):
    login_url = request.resource_url(request.context, 'login')
    referrer = request.url
    if referrer == login_url:
        referrer = '/'  # never use the login form as came_from
    came_from = request.params.get('came_from', referrer)
    request.session['came_from'] = came_from
    return dict(
        openid_url=request.registry.settings['openid.provider'],
        url='http://' + request.registry.settings['charsheet.base_url'] \
                + '/dologin.html',
        came_from=came_from,
        )


@view_config(route_name='logout')
def logout(request):
    headers = forget(request)
    return HTTPFound(location=request.resource_url(request.context),
            headers=headers)


def openid_success(context, request, *args, **kwargs):
    identity = request.params['openid.identity']
    email = request.params['openid.sreg.email']
    if not identity.startswith(request.registry.settings['openid.provider']):
        request.session.flash(
            'Error: Invalid OpenID provider. You can only use {0}.'.format(
                request.registry.settings['openid.provider']))
        return HTTPFound(location=request.application_url + '/login')
    username = identity.split('/')[-1]
    headers = remember(request, email)
    came_from = request.session['came_from']
    del(request.session['came_from'])
    response = HTTPFound(location=came_from)
    response.headerlist.extend(headers)
    return response


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):

    try:
        usernames = {
            'github': request.params['charsheetform:github'],
            'ohloh': request.params['charsheetform:ohloh'],
            'coderwall': request.params['charsheetform:coderwall'],
            'stack_exchange': request.params['charsheetform:stack_exchange'],
            'fedora': request.params['charsheetform:fedora'],
        }

        master_field = request.params['charsheetform:master']
        if master_field:
            for name in usernames:
                usernames[name] = master_field

        passwords = {
            'fedora': request.params['charsheetform:fedora_pass'],
        }

        username = 'Sugar Magnolia'
        for name in usernames:
            if usernames[name]:
                username = usernames[name]
                break
    except KeyError:
        return HTTPFound(location=request.route_url('home'))

    # TODO: Put these dicts in a dict?
    coderwall_dict = None
    github_dict = None
    ohloh_dict = None
    stack_exchange_dict = None
    fedora_dict = None

    cwc = None  # Coderwall module object

    ### Coderwall ###
    if usernames['coderwall']:
        from coderwall import CoderWall

        try:
            cwc = CoderWall(usernames['coderwall'])
            coderwall_dict = {
                'endorsements': cwc.endorsements,
            }
        except NameError:
            request.session.flash(
                'Error: Unable to find username on Coderwall.')

    ### GitHub ###
    if usernames['github']:
        from pygithub3 import Github, exceptions
        gh = Github()
        try:
            github_api = "https://api.github.com"

            user = gh.users.get(usernames['github'])

            # Get user repos
            user_repos = []
            user_languages = {}  # Structured as language: lines
            for page in gh.repos.list(user=usernames['github']):
                # Results are paginated.
                for repo in page:
                    user_repos.append(repo)
            # Get number of repos per language
            language_count = {}  # language: number of repos
            for repo in user_repos:
                if repo.language not in language_count.keys():
                    language_count[repo.language] = 1
                else:
                    language_count[repo.language] += 1
            # Don't want no None languages in mah language dict
            if None in language_count.keys():
                del language_count[None]

            # Sort languages by number of repos
            sorted_language_count = sorted(language_count.iteritems(),
                key=operator.itemgetter(1), reverse=True)

            # Get lines written per language and
            # number of times language is used
            for repo in user_repos:
                repo_languages = gh.repos.list_languages(
                    user=repo.owner.login, repo=repo.name)
                for language in repo_languages:
                    if language in user_languages.keys():
                        user_languages[language] += repo_languages[language]
                    else:
                        user_languages[language] = repo_languages[language]

            # Sort languages by lines of code in repos
            sorted_languages = sorted(user_languages.iteritems(),
                key=operator.itemgetter(1), reverse=True)

            # Get total lines in all repos and format with thousands seperators
            total_lines = 0
            for language, lines in user_languages.items():
                total_lines += lines
            import locale
            locale.setlocale(locale.LC_ALL, 'en_US')
            total_lines = locale.format("%d", total_lines, grouping=True)

            # Get recent user activity
            api_request = urllib2.Request("{0}/users/{1}/events/public".format(
                github_api, usernames['github']))
            api_response = urllib2.urlopen(api_request)
            events_json = json.load(api_response)

            recent_events = events_json[:25]

            github_dict = {
                'avatar_url': user.avatar_url,
                'bio': user.bio,
                'blog': user.blog,
                'company': user.company,
                'email': user.email,
                'recent_events': recent_events,
                'languages': sorted_languages,
                'languages_count': sorted_language_count,
                'location': user.location,
                'name': user.name,
                'public_repos': user.public_repos,
                'repos': gh.repos.list(usernames['github']).all(),
                'total_lines': total_lines,
                }

        except exceptions.NotFound:
            request.session.flash('Error: Unable to find username on GitHub.')

    ### Ohloh ###
    if usernames['ohloh']:
        # Import ElementTree for XML parsing (Python 2.5+)
        import elementtree.ElementTree as ET

        # Ohloh requires an API key and the account email, and returns
        # account information in name: value pairs.

        ohloh_api_key = '1Bwg3nXZa0OAD87lw1B4JA'  # Remove before production

        params = urllib.urlencode({'api_key': ohloh_api_key, 'v': 1})
        url = "http://www.ohloh.net/accounts/{0}.xml?{1}".format(
            usernames['ohloh'], params)
        ohloh_response = urllib.urlopen(url)

        # Parse response into XML object
        ohloh_data = ET.parse(ohloh_response)

        # Check if Ohloh returned an error
        element = ohloh_data.getroot()
        error = element.find("error")
        if error:
            request.session.flash('Error: Unable to connect to Ohloh.')
        else:
            if element.find("result/account") != None:
                ohloh_dict = {
                    'id': element.find("result/account/id").text,
                }
                for node in element.find("result/account/kudo_score"):
                    ohloh_dict[node.tag] = node.text
            else:
                request.session.flash('Error: Unable to find username on \
                    Ohloh.')

    ### Stack Exchange ###
    if usernames['stack_exchange']:
        stack_exchange_dict = {}

    ### Fedora Account System ###
    if usernames['fedora']:
        from fedora import client
        try:
            fas = client.AccountSystem(
                username=usernames['fedora'],
                password=passwords['fedora']
                )
            user = fas.person_by_username(usernames['fedora'])
            fedora_dict = {
                'affiliation': user.affiliation,
                'irc': user.ircnick,
                'status': user.status,
            }
        except NameError:
            request.session.flash('Error: Unable to connect to the Fedora \
                Account System.')
        except client.AuthError:
            request.session.flash('Error: Fedora Account System authorization \
                failed.')

    request.session.flash("Character sheet generated.")
    return {
            'username': username,
            'cwc': cwc,
            'coderwall_data': coderwall_dict,
            'github_data': github_dict,
            'ohloh_data': ohloh_dict,
            'stack_exchange_data': stack_exchange_dict,
            'fedora_data': fedora_dict,
           }

conn_err_msg = """\
Pyramid is having a problem using your SQL database.  The problem
might be caused by one of the following things:

1.  You may need to run the "initialize_charsheet_db" script
    to initialize your database tables.  Check your virtual
    environment's "bin" directory for this script and try to run it.

2.  Your database server may not be running.  Check that the
    database server referred to by the "sqlalchemy.url" setting in
    your "development.ini" file is running.

After you fix the problem, please restart the Pyramid application to
try it again.
"""
