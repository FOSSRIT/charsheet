"""
This module contains calculations used to generate stats for charsheet.
"""


def calculate_strength(lines=0, answers=0, badges=0):
    """
    Strength is determined by lines in repos,
    Stack Exchange questions answered, and Coderwall badges.
    """
    return (0.01 * (lines / 1000)) + (0.5 * answers) + (2 * badges)
