from pyramid.httpexceptions import (
    HTTPFound,
    HTTPNotFound,
    )
from pyramid.response import Response
from pyramid.view import view_config

import hashlib
import random
import urllib

from pygithub3 import Github


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {}


@view_config(route_name='error', renderer='error.mak')
def error_view(request):
    return {
        'error_message': request.params.get('error_message', 'Some error.'),
    }


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):
    username = request.matchdict['username']
    user_email = None

    ### Coderwall ###
    from coderwall import CoderWall

    try:
        cwc = CoderWall(username)
        coderwall_dict = {
            'endorsements': cwc.endorsements,
        }
    except NameError:
        print "INVALID CODERWALL USERNAME"
        query = dict(error_message="Username not found on Coderwall")
        raise HTTPFound(location=request.route_url('error', _query=query))

    ### GitHub ###
    gh = Github()
    try:
        user = gh.users.get(username)
        user_email = user.email
        # Get lines written per language and number of times language is used
        user_repos = []
        user_languages = {}  # Structured as language: lines
        for page in gh.repos.list(user=username):  # Results are paginated.
            for repo in page:
                user_repos.append(repo)
        for repo in user_repos:
            repo_languages = gh.repos.list_languages(
                user=username, repo=repo.name)
            for language in repo_languages:
                if language in user_languages.keys():
                    user_languages[language] += repo_languages[language]
                else:
                    user_languages[language] = repo_languages[language]

        total_lines = 0
        for language, lines in user_languages.items():
            total_lines += lines

        github_dict = {
            'avatar_url': user.avatar_url,
            'bio': user.bio,
            'blog': user.blog,
            'company': user.company,
            'email': user.email,
            'languages': user_languages,
            'location': user.location,
            'name': user.name,
            'public_repos': user.public_repos,
            'repos': gh.repos.list(username).all(),
            'total_lines': total_lines,
            }
    except:
        print "UNABLE TO CONNECT TO GITHUB WITH GIVEN USERNAME"
        query = dict(error_message="Username not found on GitHub")
        raise HTTPFound(location=request.route_url('error', _query=query))

    ### Ohloh ###

    # Import ElementTree for XML parsing (Python 2.5+)
    import elementtree.ElementTree as ET

    # Ohloh requires an API key and the account email, and returns
    # account information in name: value pairs.

    ohloh_api_key = '1Bwg3nXZa0OAD87lw1B4JA'  # Remove before production
    ohloh_email_hash = hashlib.md5(user_email)

    params = urllib.urlencode({'api_key': ohloh_api_key, 'v': 1})
    url = "http://www.ohloh.net/accounts/{0}.xml?{1}".format(
        ohloh_email_hash.hexdigest(), params)
    ohloh_response = urllib.urlopen(url)

    # Parse response into XML object
    ohloh_data = ET.parse(ohloh_response)

    # Check if Ohloh returned an error
    element = ohloh_data.getroot()
    error = element.find("error")
    if error:
        # There was an error. No Ohloh data for us. :(
        query = dict(error_message=ET.tostring(error))
        raise HTTPFound(location=request.route_url('error', _query=query))
    else:
        ohloh_dict = {
            'id': element.find("result/account/id").text,
        }
        for node in element.find("result/account/kudo_score"):
            ohloh_dict[node.tag] = node.text

    return {
            'username': username,
            'cwc': cwc,
            'coderwall_data': coderwall_dict,
            'github_data': github_dict,
            'ohloh_data': ohloh_dict,
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
