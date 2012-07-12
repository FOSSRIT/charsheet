from pyramid.response import Response
from pyramid.view import view_config

from sqlalchemy.exc import DBAPIError

from .models import (
    DBSession,
    MyModel,
    )

import random


@view_config(route_name='home', renderer='templates/mytemplate.pt')
def my_view(request):
    try:
        one = DBSession.query(MyModel).filter(MyModel.name=='one').first()
    except DBAPIError:
        return Response(conn_err_msg, content_type='text/plain',
                status_int=500)
    return {'one': one, 'project': 'charsheet'}


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):
    username = request.matchdict['username']
    from coderwall import CoderWall

    cwc = CoderWall(username)
    stats = [
        ('274_beer', random.randint(0, 100)),
        ('241_flash', random.randint(0, 100)),
        ('313_ax', random.randint(0, 100)),
        ('022_fire', random.randint(0, 100)),
        ('012_heart', random.randint(0, 100)),
        ('308_bomb', random.randint(0, 100)),
        ('037_credit', random.randint(0, 100)),
    ]
    return {'username': username, 'cwc': cwc, 'stats': stats}


conn_err_msg = """\
Pyramid is having a problem using your SQL database.  The problem
might be caused by one of the following things:

1.  You may need to run the "initialize_charsheet_db" script
    to initialize your database tables.  Check your virtual
    environment's "bin" directory for this script and try to run it.

2.  Your database server may not be running.  Check that the
    database server referred to by the "sqlalchemy.url" setting in
    your "development.ini" file is running.

After you fix the problem, please restart the Pyramid application to
try it again.
"""
