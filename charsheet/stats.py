"""
This module contains calculations used to generate stats for charsheet.
"""

### Attributes ###


def calculate_strength(lines=0, badges=0):
    """
    Strength is determined by lines written (Ohloh)
    and Coderwall badges.
    """
    return float(lines) / float(100000) + 2.0 * float(badges)


def calculate_dexterity(languages=0):
    """
    Dexterity is determined by language variety on Ohloh.
    """
    return float(5) * float(languages)


def calculate_leadership(forks=0, top_answers=0):
    """
    Leadership is based on repos forked on GitHub.
    """
    return float(1) * float(forks)


def calculate_wisdom(months=0):
    """
    Wisdom is equal to the age, in months and fractions of a month,
    of the user's oldest linked account.
    """
    return float(months)


def calculate_determination(projects=0):
    """
    Determination is determined (ha-ha) by the number of projects the
    user has worked on.
    """
    return float(projects)


def calculate_popularity(followers=0):
    """
    Popularity is determined by number of GitHub followers.
    """
    return float(followers)


### Skills ###


def calculate_language_skill(lines=0, exp=0, commits=0):
    """
    2000 lines of code = 1 skill point
    1 month of exp = 2 skill points
    20 commits = 1 skill point
    """
    # Remove commas from value strings and convert them to floats
    lines = float(lines)
    exp = float(exp)
    commits = float(commits)
    return (float(lines) / 2000.0) + (float(exp) * 2.0) + \
            (float(commits) / 20.0)


### Overarching calculation ###

def calculate_foo(stats):
    stats_to_average = [
            stats['strength'],
            stats['dexterity'],
            stats['wisdom'],
            stats['leadership'],
            stats['determination'],
            stats['popularity']
            ]
    return sum(stats_to_average) / float(len(stats_to_average))


def calculate_stats(gh, oh, cw):
    """
    Takes GitHub, Coderwall, and Ohloh
    dictionaries and generates a stats dict.
    """

    stats = {
        'foo': 0,
        'strength': 0,
        'dexterity': 0,
        'wisdom': 0,
        'leadership': 0,
        'determination': 0,
        'popularity': 0,
        'skills': {
            'c': 0,
            'c++': 0,
            'java': 0,
            'html': 0,
            'xml': 0,
            'python': 0,
            'php': 0,
            'javascript': 0,
            'perl': 0,
            'shell': 0,
            'objective-c': 0,
            'ruby': 0,
            'haskell': 0,
            'lua': 0,
            'assembly': 0,
            'commonlisp': 0,
            'scala': 0,
            'visualbasic': 0,
            'arduino': 0,
            'erlang': 0,
            'go': 0,
            'coffeescript': 0,
            'emacslisp': 0,
            'viml': 0,
        },
        'badges': 0,
    }

    data = {
        'total_lines': 0,
        'cw_badges': 0,
        'repos': 0,
        'age_months': 0,
        'forks': 0,
        'followers': 0,
        'languages': 0,
        'ohloh_languages': {},
    }

    if gh:
        data['repos'] += gh['public_repos']
        data['age_months'] = max(data['age_months'], gh['age_months'])
        data['forks'] = gh['forks']
        data['followers'] = gh['followers']
        data['languages_dict'] = gh['languages_lines']  # language: lines

    if oh:
        data['age_months'] = max(data['age_months'], oh['age_months'])
        data['ohloh_languages'] = oh['languages']
        data['total_lines'] = oh['lines']
        data['languages'] = oh['num_languages']

    if cw:
        data['cw_badges'] = cw['badges']

    stats['strength'] = calculate_strength(
            lines=data['total_lines'],
            badges=data['cw_badges'])

    stats['dexterity'] = calculate_dexterity(
            languages=len(data['ohloh_languages']))

    stats['wisdom'] = calculate_wisdom(
            months=data['age_months'])

    stats['leadership'] = calculate_leadership(
            forks=data['forks'])

    stats['determination'] = calculate_determination(
            projects=data['repos'])

    stats['popularity'] = calculate_popularity(
            followers=data['followers'])

    # Add age in months to the stats dict, just so that we can
    # use the age of the oldest account in the mako template for the
    # purpose of displaying the Wisdom formula in the tooltip.
    stats['age_months'] = data['age_months']

    # Also store these for reference... probs should restructure
    # all of this soon.
    stats['lines'] = data['total_lines']
    stats['num_languages'] = data['languages']

    # Skills
    if data.get('ohloh_languages'):
        for language in data['ohloh_languages']:
            stats['skills'][language['name'].lower()] = \
                    calculate_language_skill(
                        lines=language['lines'],
                        exp=language['exp'],
                        commits=language['commits'])

    # Foo
    stats['foo'] = calculate_foo(stats)

    return stats

    # Other stuff
    if cw:
        stats['badges'] = cw['badges']
