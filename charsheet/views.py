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

from datetime import datetime
from dateutil import parser, relativedelta
from httplib import BadStatusLine
import json
import operator
import pytz
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
            usernames['github'] = master_field
            usernames['ohloh'] = master_field
            usernames['coderwall'] = master_field

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

    utc = pytz.UTC  # For datetime handling

    ### Coderwall ###
    if usernames['coderwall']:
        from coderwall import CoderWall

        try:
            cwc = CoderWall(usernames['coderwall'])
            coderwall_dict = {
                'endorsements': cwc.endorsements,
                'badges': len(cwc.badges),
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
            # TODO: Consolidate this loop into the loop a few blocks below
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

            # Get lines written per language and number of times
            # language is used. Also get number of forks of user's original
            # repos.
            gh_forks = 0
            for repo in user_repos:
                repo_languages = gh.repos.list_languages(
                    user=repo.owner.login, repo=repo.name)
                # The owner of an original repo counts as having a fork it
                # seems, so we want to make sure not to count that.
                if repo.forks > 1:
                    gh_forks += repo.forks - 1
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
            total_lines_formatted = locale.format(
                    "%d", total_lines, grouping=True)

            # Get age of account, in months
            gh_age_months = abs(relativedelta.relativedelta(user.created_at,
                    user.created_at.now()).months)

            # Get recent user activity
            api_request = urllib2.Request("{0}/users/{1}/events/public".format(
                github_api, usernames['github']))
            api_response = urllib2.urlopen(api_request)
            events_json = json.load(api_response)

            recent_events = events_json[:25]

            github_dict = {
                'age_months': gh_age_months,
                'avatar_url': user.avatar_url,
                'bio': user.bio,
                'blog': user.blog,
                'company': user.company,
                'email': user.email,
                'followers': user.followers,
                'forks': gh_forks,
                'hireable': user.hireable,
                'recent_events': recent_events,
                'languages': sorted_languages,
                'languages_count': sorted_language_count,
                'languages_lines': user_languages,
                'num_languages': len(user_languages),
                'location': user.location,
                'name': user.name,
                'public_repos': user.public_repos,
                'repos': gh.repos.list(usernames['github']).all(),
                'total_lines': total_lines,
                'total_lines_formatted': total_lines_formatted,
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
                # If there's no error and we've got the account, let's get
                # some data.
                ohloh_dict = {
                    'id': element.find("result/account/id").text,
                    'created_at': element.find(
                            "result/account/created_at").text,
                }
                for node in element.find("result/account/kudo_score"):
                    ohloh_dict[node.tag] = node.text

                # Get age of account, in months
                ohloh_creation_datetime = parser.parse(
                        ohloh_dict['created_at'])
                ohloh_age_months = abs(relativedelta.relativedelta(
                        ohloh_creation_datetime,
                        utc.localize(datetime.now())).months)
                ohloh_dict['age_months'] = ohloh_age_months

            else:
                request.session.flash('Error: Unable to find username on \
                    Ohloh.')

    ### Stack Exchange ###
    if usernames['stack_exchange']:
        stack_exchange_api = 'http://api.stackexchange.com/2.1'

        def get_se_json(path, **kwargs):
            if kwargs.get('site'):
                params = urllib.urlencode({'site': kwargs.get('site')})
                request_url = "{0}{1}?{2}".format(
                        stack_exchange_api, path, params)
            else:
                request_url = "{0}{1}".format(stack_exchange_api, path)
            api_request = urllib2.Request(
                    request_url,
                    headers={"Accept": "application/json"})
            try:
                api_z_response = urllib2.urlopen(api_request)
            except:
                raise
            from zlib import decompress, MAX_WBITS
            api_response = decompress(
                    api_z_response.read(), 16 + MAX_WBITS)
            return json.loads(api_response)

        try:
            se_accounts_json = get_se_json("/users/{0}/associated".format(
                    usernames['stack_exchange']))

            se_answers = 0  # Number of answers given on SE sites
            se_top_answers = 0  # Number of accepted answers on SE sites
            se_reputation = 0  # Total rep on all SE sites
            se_tags = set()  # All of the tags in all answered SE questions
            # Oldest acc. creation date, in Unix time:
            se_oldest_creation_unix = 9999999999
            for site in se_accounts_json['items']:
                # Answer count
                try:
                    se_answers += site['answer_count']
                except KeyError:
                    pass  # No answers from that site
                se_oldest_creation_unix = min(
                        site['creation_date'], se_oldest_creation_unix)
                # Top answer count
                site_param = site['site_name'].lower().replace(' ', '')
                # Special case for metastackoverflow... *sigh*
                if site_param == 'metastackoverflow':
                    site_param = 'meta'
                # TODO: Make this get ALL answers, not just one page worth
                se_answers_json = get_se_json("/users/{0}/answers".format(
                        site['user_id']), site=site_param)
                for answer in se_answers_json['items']:
                    if answer['is_accepted'] == True:
                        se_top_answers += 1
                    # Tags
                    se_question_json = get_se_json("/questions/{0}".format(
                            answer['question_id']), site=site_param)
                    se_tags.update(se_question_json['items'][0]['tags'])
                # Reputation
                se_reputation += site['reputation']

            # Get age, in months, of oldest SE account
            oldest_se_datetime = datetime.utcfromtimestamp(
                    se_oldest_creation_unix)
            se_age_months = abs(relativedelta.relativedelta(
                    utc.localize(oldest_se_datetime),
                    utc.localize(datetime.now())).months)

            stack_exchange_dict = {
                'answers': se_answers,
                'top_answers': se_top_answers,
                'age_months': se_age_months,
                'reputation': se_reputation,
                'tags_count': len(se_tags),
            }
        except BadStatusLine, urllib2.HTTPError:
            request.session.flash('Error: Communication with \
                    Stack Exchange API denied.')

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

    ### Stat calculation ###
    import stats

    stats_dict = stats.calculate_stats(
            github_dict,
            ohloh_dict,
            coderwall_dict,
            stack_exchange_dict)

    request.session.flash("Character sheet generated.")
    return {
            'username': username,
            'cwc': cwc,
            'coderwall_data': coderwall_dict,
            'github_data': github_dict,
            'ohloh_data': ohloh_dict,
            'stack_exchange_data': stack_exchange_dict,
            'fedora_data': fedora_dict,
            'stats': stats_dict,
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
