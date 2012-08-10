"""
This module contains the functions used to get data from various APIs.
"""

from datetime import datetime
from dateutil import parser, relativedelta
from httplib import BadStatusLine
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


def handle_stack_exchange(request, user_id):
    """
    Get data from Stack Exchange.
    """
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
                user_id))

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
        se_age_months = calculate_age_months(
                utc.localize(oldest_se_datetime),
                utc.localize(datetime.now()))

        return {
            'answers': se_answers,
            'top_answers': se_top_answers,
            'age_months': se_age_months,
            'reputation': se_reputation,
            'tags_count': len(se_tags),
        }
    except BadStatusLine, urllib2.HTTPError:
        request.session.flash('Error: Communication with \
                Stack Exchange API denied.')
        return None


def handle_fedora(request, username, password):
    from fedora import client
    try:
        fas = client.AccountSystem(
                username=username, password=password)
        user = fas.person_by_username(username)
        return {
            'affiliation': user.affiliation,
            'irc': user.ircnick,
            'status': user.status,
        }
    except NameError:
        request.session.flash('Error: Unable to connect to the Fedora \
            Account System.')
        return None
    except client.AuthError:
        request.session.flash('Error: Fedora Account System authorization \
            failed.')
        return None
