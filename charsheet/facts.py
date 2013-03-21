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
    values = int()
    values_sum = float()
    for username in data['users']:
        values_sum += float(data['users'][username]['stats'][stat])
        values += 1
    # Return average value rounded to two decimal places
    return round(values_sum / float(values), 2)


def top_users(data, stat):
    """
    Returns top 10 users in a stat, sorted in desc order.
    """
    # TODO: Check if stat can be ranked
    # TODO: Hopefully use knowledge to pull sorted list soon
    scoreboard = dict()

    for username in data['users']:
        scoreboard[username] = round(data['users'][username]['stats'][stat], 2)

    # sort users by stat value
    scoreboard_sorted = sorted(scoreboard.iteritems(),
        key=operator.itemgetter(1), reverse=True)

    return scoreboard_sorted[:10]
