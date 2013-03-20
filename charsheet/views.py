from __future__ import unicode_literals

from pyramid.httpexceptions import (
    HTTPFound,
    HTTPNotFound,
    )
from pyramid.response import Response
from pyramid.view import view_config
from pyramid.security import (
    authenticated_userid,
    remember,
    forget,
)

from sqlalchemy import create_engine

import datetime
import forms

import data


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {
        'charsheet_form': forms.CharsheetForm,
    }


@view_config(route_name='stats', renderer='stats.mak')
def global_stats(request):


    return {
        'stats': data.global_stats(),
    }


@view_config(route_name='login', renderer='login.mak')
def login(request):
    login_url = request.resource_url(request.context, 'login')
    referrer = request.url
    if referrer == login_url:
        referrer = '/'  # never use the login form as came_from
    came_from = request.params.get('came_from', referrer)
    request.session['came_from'] = came_from
    return dict(
        openid_url=request.registry.settings['openid.provider'],
        url='http://' + request.registry.settings['charsheet.base_url'] \
                + '/dologin.html',
        came_from=came_from,
        )


@view_config(route_name='logout')
def logout(request):
    headers = forget(request)
    return HTTPFound(location=request.resource_url(request.context),
            headers=headers)


def openid_success(context, request, *args, **kwargs):
    """
    Incomplete OpenID attempt.
    """
    identity = request.params['openid.identity']
    email = request.params['openid.sreg.email']
    if not identity.startswith(request.registry.settings['openid.provider']):
        request.session.flash(
            'Error: Invalid OpenID provider. You can only use {0}.'.format(
                request.registry.settings['openid.provider']))
        return HTTPFound(location=request.application_url + '/login')
    #username = identity.split('/')[-1]  # Not sure what this is for
    headers = remember(request, email)
    came_from = request.session['came_from']
    del(request.session['came_from'])
    response = HTTPFound(location=came_from)
    response.headerlist.extend(headers)
    return response


@view_config(route_name='submit')
def fetch_data(request):
    try:
        usernames = {
            'github': request.params['charsheetform:github'],
            'ohloh': request.params['charsheetform:ohloh'],
            'coderwall': request.params['charsheetform:coderwall'],
        }

        username = '???'  # Set default username
        # Cycle through usernames available, use first one that exists
        for name in usernames:
            if usernames[name]:
                username = usernames[name]
                break
    except KeyError:
        return HTTPFound(location=request.route_url('home'))

    stats_dict = data.handle_all(request, usernames)

    if username != '???':
        data.inject_knowledge(username, stats_dict)
        return HTTPFound(location=request.route_url('charsheet', username=username))
    return HTTPFound(location=request.route_url('home'))


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):
    """Render stats for a user."""
    username = request.matchdict.get('username')
    user = data.get_user(username)
    if user:
        request.session.flash("Character sheet generated.")
        return dict(stats=user)
    else:
        return HTTPFound(location=request.route_url('home'))


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
