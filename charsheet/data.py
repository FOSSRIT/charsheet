"""
This module contains the functions used to get data from various APIs.
"""

from datetime import datetime
from dateutil import parser, relativedelta
import hashlib
import operator
import json
import pytz
import re
import urllib


from knowledge.model import Fact, Entity, DBSession, init_model, metadata, create_engine
engine = create_engine('sqlite:///knowledge.db')
init_model(engine)
metadata.create_all(engine)

from requests import HTTPError

from facts import average_value, top_users
import stats

from requests import HTTPError

utc = pytz.UTC  # For datetime handling


def handle_all(request, usernames):
    """Handle looking at all of the backends."""

    data = dict(
        usernames=usernames,
        timestamp=datetime.now().strftime("%Y.%m.%d %H:%M"),
    )

    for backend, username in usernames.items():
        data[backend] = globals()['handle_' + backend](request, username)

    if data['github'].get('email'):
        data['gravatar'] = get_gravatar_url(data['github']['email'])

    data['stats'] =  stats.calculate_stats(
        gh=data['github'],
        oh=data['ohloh'],
        cw=data['coderwall']
    )

    return data


def handle_coderwall(request, username):
    """Get data from CoderWall."""
    data = {
        'endorsements': 0,
        'badges': [],
    }
    if not username:
        return data

    from coderwall import CoderWall
    try:
        cwc = CoderWall(username)
        data['endorsements'] = cwc.endorsements
        data['badges'] = [dict(name=badge.name,
                               description=badge.description,
                               image_uri=badge.image_uri)
                          for badge in cwc.badges]
        return data
    except NameError:
        request.session.flash('Error: Unable to find username on Coderwall.')
        return data


def handle_github(request, username):
    """
    Get data from GitHub.
    """
    from pygithub3 import Github, exceptions
    github_api = "https://api.github.com"
    token = request.session['token']
    gh = Github(token=token)
    data = {
        'age_months': 0,
        'bio': '',
        'blog': '',
        'company': '',
        'email': '',
        'followers': 0,
        'forks': 0,
        'hireable': False,
        'recent_events': [],
        'language_by_repos': [],
        'location': '',
        'name': '',
        'public_repos': [],
     }
    if not username:
        return data
    try:
        user = gh.users.get(user=username)

        # Handle organizations, because everything breaks if one is
        # passed in, including but not limited to user.bio and
        # user.hireable.
        if user.type == 'Organization':
            request.session.flash(
                'Error: Charsheet does not yet support \
                        GitHub organizations.')
            return data

        # Get user repos
        for page in gh.repos.list(user=username, type='public'):
            # Results are paginated.
            for repo in page:
                data['public_repos'].append(repo)

        # Get lines written per language and number of times
        # language is used. Also get number of forks of user's original
        # repos.
        user_languages = {}
        for repo in data['public_repos']:
            repo_languages = gh.repos.list_languages(
                user=repo.owner.login, repo=repo.name)
            data['forks'] += repo.forks
            for language in repo_languages:
                if language in user_languages.keys():
                    user_languages[language] += 1
                else:
                    user_languages[language] = 1

        # Sort languages by lines of code in repos
        data['languages_by_repos'] = sorted(user_languages,
            key=lambda lang: user_languages[lang], reverse=True)

        # Get age of account, in months
        data['age_months'] = calculate_age_months(
                user.created_at, user.created_at.now())

        # Get recent user activity
        recent_events = list()
        result = gh.events.users.list_performed_public(user=username)
        for page in result:
            for event in page:
                recent_events.append(event)
        data['recent_events'] = recent_events[:25]

        # Blog/URL handling
        try:
            data['blog'] = user.blog.split('://')[-1]
        except AttributeError:
            data['blog'] = "?"

        for tag in ['bio', 'company', 'email', 'hireable', 'location', 'name',
                    'followers']:
            try:
                data[tag] = getattr(user, tag)
            except AttributeError:
                data[tag] = '?'

        return data

    except exceptions.NotFound:
        request.session.flash('Error: Unable to find username on GitHub.')
        return data
    except HTTPError:
        request.session.flash('Error: GitHub denied our request!')
        return data


def handle_ohloh(request, username):
    data = {
        'age_months': 0,
        'id': None,
        'kudo_rank': 0,
        'languages': [],
        'lines': 0,
        'position': 0,
    }
    if not username:
        return data

    # Import ElementTree for XML parsing (Python 2.5+)
    import elementtree.ElementTree as ET

    # Ohloh requires an API key and the account email, and returns
    # account information in name: value pairs.

    ohloh_api_key = '1Bwg3nXZa0OAD87lw1B4JA'  # Remove before production

    params = urllib.urlencode({'api_key': ohloh_api_key, 'v': 1})
    url = "http://www.ohloh.net/accounts/{0}.xml?{1}".format(
        username, params)
    ohloh_response = urllib.urlopen(url)

    # Parse response into XML object
    ohloh_data = ET.parse(ohloh_response)

    # Check if Ohloh returned an error
    element = ohloh_data.getroot()
    error = element.find("error")
    if error:
        request.session.flash('Error: Unable to connect to Ohloh.')
        return data
    else:
        if element.find("result/account") != None:
            # If there's no error and we've got the account, let's get
            # some data.
            data['id'] = element.find("result/account/id").text
            for node in element.find("result/account/kudo_score"):
                data[node.tag] = node.text

            # Get age of account, in months
            ohloh_created_at = element.find("result/account/created_at").text
            ohloh_age_months = calculate_age_months(
                    parser.parse(ohloh_created_at),
                    utc.localize(datetime.now()))
            data['age_months'] = ohloh_age_months

            # Obtain account language data
            ohloh_languages = []  # User languages
            for language in element.find("result/account/languages"):
                lang_name = language.find("name").text
                lang_lines = int(re.sub(',', '',
                        language.find("total_lines_changed").text))
                lang_exp = int(re.sub(',', '',
                        language.find("experience_months").text))
                lang_commits = int(re.sub(',', '',
                        language.find("total_commits").text))
                ohloh_languages.append(dict(
                        name=lang_name,
                        lines=lang_lines,
                        exp=lang_exp,
                        commits=lang_commits))
            data['lines'] = \
                    sum([lang['lines'] for lang in ohloh_languages])
            # Sort languages by lines
            data['languages_by_lines'] = sorted(ohloh_languages,
                    key=lambda lang: lang['lines'], reverse=True)

            return data
        else:
            request.session.flash('Error: Unable to find username on \
                Ohloh.')
            return data


def get_gravatar_url(email):
    # Gravatar
    gravatar_url = 'http://www.gravatar.com/avatar/'
    gravatar_size = 60  # in pixels
    gravatar_url += hashlib.md5(email.lower()).hexdigest() + "?"
    gravatar_url += urllib.urlencode({'s': str(gravatar_size)})
    return gravatar_url


def inject_knowledge(username, data_dict):
    character = Entity.by_name(username)
    if not character:
        character = Entity(username)
        character[u'name'] = username

    for key, value in data_dict.items():
        if isinstance(value, str):
            value = value.decode('utf8')
        character[key] = value
    DBSession.add(character)
    DBSession.commit()
    return character


def global_stats():
    data = {
        'users': dict(),
    }

    users = DBSession.query(Entity).all()

    for user in users:
        data['users'][user.name] = dict()
        for fact in user.facts.values():
            data['users'][user.name][fact.key] = fact.value

    stats = {
        'avg_foo': average_value(data, 'foo'),
        'avg_dexterity': average_value(data, 'dexterity'),
        'avg_strength': average_value(data, 'strength'),
        'avg_wisdom': average_value(data, 'wisdom'),
        'avg_leadership': average_value(data, 'leadership'),
        'avg_determination': average_value(data, 'determination'),
        'avg_popularity': average_value(data, 'popularity'),
        'avg_num_languages': average_value(data, 'num_languages'),
        'avg_badges': average_value(data, 'badges'),
        'top_foo': top_users(data, 'foo'),
        'sheets_generated': len(users),
        'sheets_unique': len(data['users']),
    }

    return stats


def get_user(username):
    return Entity.by_name(username)


def calculate_age_months(dt1, dt2):
    """
    Pass this function two tz-aware datetimes and get
    the difference in months and fractions of a month!
    """
    age_delta = relativedelta.relativedelta(dt1, dt2)
    # The below works well enough to get an approximate decimal.
    fraction_of_month = float(age_delta.days) / 31
    return abs((age_delta.years * 12) + age_delta.months + fraction_of_month)
