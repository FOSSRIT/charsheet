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
    values_sum = sum(data['users'][username]['stats'][stat] for username in data['users'])
    return values_sum / len(data['users'])


def top_users(data, stat):
    """
    Returns top 10 users in a stat, sorted in desc order.
    """
    # TODO: Check if stat can be ranked
    # TODO: Hopefully use knowledge to pull sorted list soon
    scoreboard = sorted([(username, data['users'][username]['stats'][stat])
        for username in data['users']], key=operator.itemgetter(1), reverse=True)

    return scoreboard[:10]
