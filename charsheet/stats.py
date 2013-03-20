"""
This module contains calculations used to generate stats for charsheet.
"""
from __future__ import unicode_literals

import struct

### Utilities ###


def calculate_color(level):
    """
    Determine hex color from cold to warm based on skill level.
    Will be replaced once statefulness is introduced.
    """
    pass


### Attributes ###


def calculate_strength(lines=0, badges=0):
    """
    Strength is determined by lines written (Ohloh)
    and Coderwall badges.
    """
    return float(lines) / 100000. + 2.0 * len(badges)


def calculate_dexterity(languages=0):
    """
    Dexterity is determined by language variety on Ohloh.
    """
    return 5. * float(languages)


def calculate_leadership(forks=0, top_answers=0):
    """
    Leadership is based on repos forked on GitHub.
    """
    return 1. * float(forks)


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
    return len(projects)


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
        'age_months': 0
    }

    # Completion percent
    linked_services = 0
    total_services = 3

    if gh:
        linked_services += 1
        stats['age_months'] = max(stats['age_months'], gh['age_months'])

    if oh:
        linked_services += 1
        stats['age_months'] = max(stats['age_months'], oh['age_months'])

    if cw:
        linked_services += 1

    stats['percent_complete'] = float(linked_services) / float(total_services)

    stats['strength'] = calculate_strength(
            lines=oh['lines'],
            badges=cw['badges'])

    stats['dexterity'] = calculate_dexterity(
            languages=len(oh['languages']))

    stats['wisdom'] = calculate_wisdom(
            months=stats['age_months'])

    stats['leadership'] = calculate_leadership(
            forks=gh['forks'])

    stats['determination'] = calculate_determination(
            projects=gh['public_repos'])

    stats['popularity'] = calculate_popularity(
            followers=gh['followers'])

    # Also store these for reference... probs should restructure
    # all of this soon.
    stats['num_languages'] = len(oh['languages'])

    # Skills
    if oh:
        for language in oh['languages']:
            stats['skills'][language['name'].lower()] = \
                    calculate_language_skill(
                        lines=language['lines'],
                        exp=language['exp'],
                        commits=language['commits'])

    # Foo
    stats['foo'] = calculate_foo(stats)

    return stats
