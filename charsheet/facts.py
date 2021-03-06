"""
This module contains functions for handling data from the Knowledge database
system.
"""

import operator


def average_value(data, stat):
    """
    Determine the average value of a stat among all users
    in the db.
    """
    # TODO: Check if passed stat is average-able
    if len(data) < 1:
        return 0

    values_sum = sum(data[username]['stats'][stat] for username in data)
    return values_sum / len(data)


def average_length(data, stat, location):
    if len(data) < 1:
        return 0

    length_sum = sum(len(data[username][location][stat]) for username in data)
    return length_sum / len(data)


def top_users(data, stat):
    """
    Returns top 10 users in a stat, sorted in desc order.
    """
    # TODO: Check if stat can be ranked
    # TODO: Hopefully use knowledge to pull sorted list soon
    scoreboard = sorted([(username, data[username]['stats'][stat])
        for username in data], key=operator.itemgetter(1), reverse=True)

    return scoreboard[:10]


def sheets_by_class(data):
    """
    Return dict() of total users per class name.
    """
    classes = dict()
    languages = dict()
    for user_data in data.values():
        class_name = user_data['stats'].get('class')
        if class_name:
            lang, class_ = class_name.split()
            classes[class_] = classes.get(class_, 0) + 1
            languages[lang] = languages.get(lang, 0) + 1
    return languages, classes
