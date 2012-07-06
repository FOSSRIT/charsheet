""" Run like:  $ python coder-shell.py

First you need to:  $ pip install coderwall requests fabulous
"""

from coderwall import CoderWall
import fabulous.image
import fabulous.text
import os
import requests
import sys
import tempfile

message = "\nType in a Coderwall username to view badges!\n\n> "

username = raw_input(message)

try:
    user = CoderWall(username)
except NameError:
    print "User {} does not exist.".format(username)
    sys.exit(0)

print(user.name)
for badge in user.badges:
    url = badge.image_uri
    response = requests.get(url)

    fd, filename = tempfile.mkstemp(suffix='.png')

    with open(filename, 'w') as f:
        f.write(response.raw.data)

    fab = fabulous.image.Image(filename)
    os.remove(filename)

    print(fab)
    print(fabulous.text.Text(badge.name))
    print(badge.description)

