"""
This module contains the functions used to get data from various APIs.
"""

from datetime import datetime
from dateutil import parser, relativedelta
import hashlib
import operator
import json
import pytz
import urllib
import urllib2

utc = pytz.UTC  # For datetime handling


def calculate_age_months(dt1, dt2):
    """
    Pass this function two tz-aware datetimes and get
    the difference in months and fractions of a month!
    """
    age_delta = relativedelta.relativedelta(dt1, dt2)
    # The below works well enough to get an approximate decimal.
    fraction_of_month = float(age_delta.days) / 31
    return abs((age_delta.years * 12) + age_delta.months + fraction_of_month)


def get_gravatar_url(email):
    # Gravatar
    gravatar_url = 'http://www.gravatar.com/avatar/'
    gravatar_size = 60  # in pixels
    gravatar_url += hashlib.md5(email.lower()).hexdigest() + "?"
    gravatar_url += urllib.urlencode({'s': str(gravatar_size)})
    return gravatar_url


def handle_coderwall(request, username):
    """
    Get data from CoderWall.
    """
    from coderwall import CoderWall

    try:
        cwc = CoderWall(username)
        return {
            'endorsements': cwc.endorsements,
            'badges': len(cwc.badges),
            'cwc': cwc,
        }
    except NameError:
        request.session.flash(
            'Error: Unable to find username on Coderwall.')
        return None


def handle_github(request, username):
    """
    Get data from GitHub.
    """
    from pygithub3 import Github, exceptions
    gh = Github()
    github_api = "https://api.github.com"
    try:
        user = gh.users.get(username)

        # Handle organizations, because everything breaks if one is
        # passed in, including but not limited to user.bio and
        # user.hireable.
        if user.type == 'Organization':
            request.session.flash(
                'Error: Charsheet does not yet support \
                        GitHub organizations.')
            return None

        # Get user repos
        user_repos = []
        user_languages = {}  # Structured as language: lines
        for page in gh.repos.list(user=username):
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
        gh_age_months = calculate_age_months(
                user.created_at, user.created_at.now())

        # Get recent user activity
        api_request = urllib2.Request("{0}/users/{1}/events/public".format(
            github_api, username))
        api_response = urllib2.urlopen(api_request)
        events_json = json.load(api_response)

        recent_events = events_json[:25]

        # Blog/URL handling
        if user.blog:
            if user.blog.startswith('http://'):
                gh_blog_url = user.blog[7:]
            elif user.blog.startswith('https://'):
                gh_blog_url = user.blog[8:]
            else:
                gh_blog_url = user.blog
        else:
            gh_blog_url = None

        return {
            'age_months': gh_age_months,
            'bio': user.bio,
            'blog': gh_blog_url,
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
            'repos': gh.repos.list(username).all(),
            'total_lines': total_lines,
            'total_lines_formatted': total_lines_formatted,
            }

    except exceptions.NotFound:
        request.session.flash('Error: Unable to find username on GitHub.')
        return None


def handle_ohloh(request, username):
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
        return None
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
            ohloh_age_months = calculate_age_months(
                    ohloh_creation_datetime,
                    utc.localize(datetime.now()))
            ohloh_dict['age_months'] = ohloh_age_months

            # Obtain account language data
            ohloh_language_elements = []
            for language in element.find("result/account/languages"):
                ohloh_language_elements.append(language)

            return ohloh_dict
        else:
            request.session.flash('Error: Unable to find username on \
                Ohloh.')
            return None
