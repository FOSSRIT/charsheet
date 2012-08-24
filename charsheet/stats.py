"""
This module contains calculations used to generate stats for charsheet.
"""


### Attributes ###


def calculate_strength(lines=0, badges=0):
    """
    Strength is determined by lines in repos
    and Coderwall badges.
    """
    return float((lines / 100000) + (2 * badges))


def calculate_dexterity(languages=0):
    """
    Dexterity is determined by language variety in repos.
    """
    return float(5 * languages)


def calculate_leadership(forks=0, top_answers=0):
    """
    Leadership is based on repos forked on GitHub.
    """
    return float(1 * forks)


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


def calculate_language_skill(lines=0):
    """
    Equal to 1 skill point per 2000 lines of code.
    """
    return float(lines / 2000.0)


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
    }

    data = {
        'total_lines': 0,
        'cw_badges': 0,
        'repos': 0,
        'age_months': 0,
        'forks': 0,
        'followers': 0,
        'languages': 0,
    }

    if gh:
        data['total_lines'] += gh['total_lines']
        data['repos'] += gh['public_repos']
        data['age_months'] = max(data['age_months'], gh['age_months'])
        data['forks'] = gh['forks']
        data['followers'] = gh['followers']
        data['languages'] = gh['num_languages']
        data['languages_dict'] = gh['languages_lines']  # language: lines

    if oh:
        data['age_months'] = max(data['age_months'], oh['age_months'])

    if cw:
        data['cw_badges'] = cw['badges']

    stats['strength'] = calculate_strength(
            lines=data['total_lines'],
            badges=data['cw_badges'])

    stats['dexterity'] = calculate_dexterity(
            languages=data['languages'])

    stats['wisdom'] = calculate_wisdom(
            months=data['age_months'])

    stats['leadership'] = calculate_leadership(
            forks=data['forks'])

    stats['determination'] = calculate_determination(
            projects=data['repos'])

    stats['popularity'] = calculate_popularity(
            followers=data['followers'])

    # Skills
    if data.get('languages_dict'):
        for language in data['languages_dict']:
            stats['skills'][language.lower()] = calculate_language_skill(
                    lines=data['languages_dict'][language])

    # Foo
    stats['foo'] = calculate_foo(stats)

    return stats
