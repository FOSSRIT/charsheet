from pyramid.response import Response
from pyramid.view import view_config

import hashlib
import random
import urllib

from pygithub3 import Github


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {}


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):
    username = request.matchdict['username']

    ### Coderwall ###
    from coderwall import CoderWall

    cwc = CoderWall(username)
    stats = [
        ('274_beer', random.randint(0, 100)),
        ('241_flash', random.randint(0, 100)),
        ('313_ax', random.randint(0, 100)),
        ('022_fire', random.randint(0, 100)),
        ('012_heart', random.randint(0, 100)),
        ('308_bomb', random.randint(0, 100)),
        ('037_credit', random.randint(0, 100)),
    ]

    if username == 'ralphbean':
        stats = [(stats[0][0], 100) for i in range(len(stats))]

    coderwall_dict = {
        'endorsements': cwc.endorsements,
    }

    ### GitHub ###
    gh = Github()
    user = gh.users.get(username)
    user_email = user.email
    github_dict = {
        'avatar_url': user.avatar_url,
        'bio': user.bio,
        'blog': user.blog,
        'company': user.company,
        'email': user.email,
        'location': user.location,
        'name': user.name,
        'public_repos': user.public_repos,
        'repos': gh.repos.list(username).all(),
        }

    ### Ohloh ###

    # Import ElementTree for XML parsing (Python 2.5+)
    import elementtree.ElementTree as ET

    # Ohloh requires an API key and the account email, and returns
    # account information in name: value pairs.

    ohloh_api_key = '1Bwg3nXZa0OAD87lw1B4JA'
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
        error_message = ET.tostring(error)  # TODO: Make use of this
        # There was an error. No Ohloh data for us. :(
        ohloh_dict = None
    else:
        ohloh_dict = {
            'id': element.find("result/account/id").text,
        }
        for node in element.find("result/account/kudo_score"):
            ohloh_dict[node.tag] = node.text

    return {
            'username': username,
            'cwc': cwc,
            'stats': stats,
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
