from __future__ import unicode_literals
import datetime

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

from velruse import login_url

import data


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {
        'github_login_url': login_url(request, 'github'),
    }


@view_config(context='velruse.AuthenticationComplete')
def service_login_complete(request):
    context = request.context
    username = context.profile['accounts'][0]['username']
    oauth_token = context.credentials['oauthAccessToken']

    headers = remember(request, username)

    request.session['token'] = request.context.credentials['oauthAccessToken']
    request.session['username'] = username

    response = HTTPFound(location=request.route_url('home'),
                            headers=headers)

    return response


@view_config(context='velruse.AuthenticationDenied', renderer='json')
def service_login_denied(request):
    return {
        'result': 'denied',
    }


@view_config(route_name='stats', renderer='stats.mak')
def global_stats(request):
    return {'stats': data.global_stats()}


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
    INCOMPLETE openID attempt! This function is not the one that is used.
    I am keeping it here for a little bit for archival purposes. Will
    delete when I am sure doing so will not break anything.
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
    usernames = {
        'github': request.params.get('github'),
        'ohloh': request.params.get('ohloh'),
        'coderwall': request.params.get('coderwall'),
    }
    if not any(usernames.values()):
        request.session.flash("Error: No usable usernames given, failing.")
        return HTTPFound(location=request.route_url('home'))

    # build stats given known backends
    stats_dict = data.handle_all(request, usernames)

    username = [name for name in usernames.values() if name][0]
    data.inject_knowledge(username, stats_dict)
    return HTTPFound(location=request.route_url('charsheet', username=username))


@view_config(route_name='handle_search')
def handle_search(request):

    # Get handle from form and strip it of hanging whitespace
    handle = request.params['handle'].strip()

    if not handle:
        # No handle was entered, so go back to home view
        request.session.flash("Error: Please enter a username to search")
        return HTTPFound(location=request.route_url('home'))

    return HTTPFound(location=request.route_url('charsheet', username=handle))


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):
    """Render stats for a user."""
    username = request.matchdict.get('username')
    user = data.get_user(username)
    if user:
        request.session.flash("Character sheet generated.")
        return dict(stats=user)
    else:
        request.session.flash("Error: No user could be matched")
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
