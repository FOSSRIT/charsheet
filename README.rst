===========
Charsheet
===========

Charsheet is an open-source web application built on Pyramid
and currently in development.
It generates a FOSS developer "character sheet" based on
data from sites like GitHub, Ohloh, and Stack Exchange.

Authors
-------

-   David Gay (oddshocks)
-   Remy DeCausemaker (decause)

APIs Currently Utilized
-----------------------

-   GitHub
-   Coderwall
-   Ohloh
-   Stack Exchange
-   Fedora Accounts System

Hacking on Charsheet
--------------------

You should be able to start hacking on charsheet after
running these commands:

- cd <directory containing this file>

- $venv/bin/python setup.py develop

- $venv/bin/populate_charsheet development.ini

- $venv/bin/pserve development.ini

