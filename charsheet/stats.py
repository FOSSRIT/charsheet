"""
This module contains calculations used to generate stats for charsheet.
"""


### Attributes ###


def calculate_strength(lines=0, answers=0, badges=0):
    """
    Strength is determined by lines in repos, questions answered on
    Stack Exchange, and Coderwall badges.
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
    return (0.1 * forks) + (2.0 * top_answers)


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
    return followers + (0.5 * reputation)


### Skills ###


def calculate_language_skill(lines=0):
    """
    Equal to 1 skill point per 2000 lines of code.
    """
    return lines / 2000.0


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
        'se_top_answers': 0,
        'se_reputation': 0,
        'repos': 0,
        'age_months': 0,
        'forks': 0,
        'followers': 0,
        'tags': 0,
        'languages': 0,
    }

    if gh:
        data['total_lines'] += gh['total_lines']
        data['repos'] += gh['public_repos']
        data['age_months'] = max(data['age_months'], gh['age_months'])
        data['forks'] = gh['forks']
        data['followers'] = gh['followers']
        data['languages'] = gh['num_languages']

    if oh:
        data['age_months'] = max(data['age_months'], oh['age_months'])

    if cw:
        data['cw_badges'] = cw['badges']

    if se:
        data['se_answers'] = se['answers']
        data['age_months'] = max(data['age_months'], se['age_months'])
        data['se_top_answers'] = se['top_answers']
        data['tags'] = se['tags_count']
        data['se_reputation'] = se['reputation']

    stats['strength'] = calculate_strength(
            lines=data['total_lines'],
            answers=data['se_answers'],
            badges=data['cw_badges'])

    stats['dexterity'] = calculate_dexterity(
            languages=data['languages'],
            tags=data['tags'])

    stats['wisdom'] = calculate_wisdom(
            months=data['age_months'])

    stats['leadership'] = calculate_leadership(
            forks=data['forks'],
            top_answers=data['se_top_answers'])

    stats['determination'] = calculate_determination(
            projects=data['repos'])

    stats['popularity'] = calculate_popularity(
            followers=data['followers'],
            reputation=data['se_reputation'])

    return stats
