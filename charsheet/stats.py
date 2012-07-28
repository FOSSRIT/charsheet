"""
This module contains calculations used to generate stats for charsheet.
"""


### Attributes ###


def calculate_strength(lines=0, answers=0, badges=0):
    """
    Strength is determined by lines in repos,
    Stack Exchange questions answered, and Coderwall badges.
    """
    return (0.01 * (lines / 1000)) + (0.5 * answers) + (2 * badges)


def calculate_dexterity(languages=0, tags=0):
    """
    Dexterity is determined by language variety in repos
    and sum of tags on all answered Stack Exchange questions.
    """
    return (5 * languages) + (0.2 * tags)


def calculate_leadership(forks=0, top_answers=0):
    """
    Leadership is based on project forks and top answers on Stack Exchange.
    """
    return (0.1 * forks) + (2 * top_answers)


def calculate_wisdom(months=0):
    """
    Wisdom is equal to the age, in months, of the user's oldest linked
    account.
    """
    return months


def calculate_determination(projects=0):
    """
    Determination is determined (ha-ha) by the number of projects the
    user has worked on.
    """
    return projects


def calculate_popularity(followers=0, reputation=0):
    """
    Popularity is determined by number of followers and Stack Exchange
    reputation.
    """
    return followers * (reputation * 0.5)


### Skills ###


def calculate_language_skill(lines=0):
    """
    Equal to 1 skill point per 2000 lines of code.
    """
    return lines / 2000


### Overarching calculation ###


def calculate_stats(gh, oh, cw, se):
    """
    Takes GitHub, Stack Exchange, Coderwall, and Ohloh
    dictionaries and generates a stats dict.
    """

    stats = {}

    data = {
        'total_lines': 0,
        'cw_badges': 0,
        'se_answers': 0,
    }

    if gh:
        data['total_lines'] = gh['total_lines']

    if oh:
        pass

    if cw:
        data['cw_badges'] = cw['badges']

    if se:
        data['se_answers'] = se['answers']

    stats['strength'] = calculate_strength(
            data['total_lines'],
            data['se_answers'],
            data['cw_badges'])

    return stats
