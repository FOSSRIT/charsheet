from pyramid.httpexceptions import (
    HTTPFound,
    HTTPNotFound,
    )
from pyramid.response import Response
from pyramid.view import view_config

import hashlib
import json
import operator
import random
import urllib
import urllib2

from pygithub3 import Github

import forms


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {
        'charsheet_form': forms.CharsheetForm,
    }


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):

    usernames = {
        'github': request.params['charsheetform:github'],
        'ohloh': request.params['charsheetform:ohloh'],
        'coderwall': request.params['charsheetform:coderwall'],
        'stack_exchange': request.params['charsheetform:stack_exchange'],
        'fedora': request.params['charsheetform:fedora'],
    }

    passwords = {
        'fedora': request.params['charsheetform:fedora_pass'],
    }

    username = 'Sugar Magnolia'
    for name in usernames:
        if usernames[name]:
            username = usernames[name]
            break

    # TODO: Put these dicts in a dict?
    coderwall_dict = None
    github_dict = None
    ohloh_dict = None
    stack_exchange_dict = None
    fedora_dict = None

    user_email = None

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
        gh = Github()
        try:

            github_api = "https://api.github.com"

            user = gh.users.get(usernames['github'])

            user_email = user.email
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

            # Get total lines in all repos
            total_lines = 0
            for language, lines in user_languages.items():
                total_lines += lines

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

        except NameError:
            request.session.flash('Error: Unable to find username on GitHub.')

    ### Ohloh ###
    if usernames['ohloh']:
        # Import ElementTree for XML parsing (Python 2.5+)
        import elementtree.ElementTree as ET

        # Ohloh requires an API key and the account email, and returns
        # account information in name: value pairs.

        ohloh_api_key = '1Bwg3nXZa0OAD87lw1B4JA'  # Remove before production
        #ohloh_email_hash = hashlib.md5(user_email)

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
                request.session.flash('Error: Unable to find Ohloh account \
                    with account name {0}.'.format(usernames['ohloh']))

    ### Stack Exchange ###
    if usernames['stack_exchange']:
        import stackexchange
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
