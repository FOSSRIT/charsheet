===========
Charsheet
===========

Charsheet is an open-source web application built on Pyramid
and currently in development.
It generates a FOSS developer "character sheet" based on
data from sites like GitHub, Ohloh, and Stack Exchange.

Charsheet was developed in conjunction with the 2012 RIT
undergraduate research symposium, where I was part of a team
researching gamification of FOSS development. The content we
generated can be found at https://github.com/FOSSRIT/surf-2012.

I plan to continue hacking on this app throughout the coming
days. If I can get off from work for BarCampRoc, I will be
presenting on this app there.

Contributors
------------

-   David Gay (oddshocks)
-   Remy DeCausemaker (decause)
-   Nate Case (qalthos)
-   Ralph Bean (threebean)

APIs Currently Utilized
-----------------------

-   GitHub
-   Coderwall
-   Ohloh
-   Stack Exchange (disabled)
-   Fedora Accounts System (disabled)

History
-------

Charsheet was previously developed in the FOSSRIT/surf-2012 repo on GitHub.
You can still visit this repo to see old issues.

Hacking on Charsheet
--------------------

You should be able to start hacking on charsheet after
running these commands:

- cd <directory containing this file>

- $venv/bin/python setup.py develop

- add Github consumer key and secret to secrets.ini.example

- mv secrets.ini.example secrets.ini

- $venv/bin/pserve development.ini
