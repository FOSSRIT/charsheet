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


import forms


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {
        'charsheet_form': forms.CharsheetForm,
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


@view_config(route_name='charsheet', renderer='chartemplate.mak')
def charsheet_view(request):

    try:
        usernames = {
            'github': request.params['charsheetform:github'],
            'ohloh': request.params['charsheetform:ohloh'],
            'coderwall': request.params['charsheetform:coderwall'],
            'stack_exchange': request.params['charsheetform:stack_exchange'],
            'fedora': request.params['charsheetform:fedora'],
        }

        master_field = request.params['charsheetform:master']
        if master_field:
            usernames['github'] = master_field
            usernames['ohloh'] = master_field
            usernames['coderwall'] = master_field

        passwords = {
            'fedora': request.params['charsheetform:fedora_pass'],
        }

        username = 'Sugar Magnolia'
        for name in usernames:
            if usernames[name]:
                username = usernames[name]
                break
    except KeyError:
        return HTTPFound(location=request.route_url('home'))

    # TODO: Put these dicts in a dict?
    coderwall_dict = None
    github_dict = None
    ohloh_dict = None
    stack_exchange_dict = None
    fedora_dict = None

    import data

    ### Coderwall ###
    if usernames['coderwall']:
        coderwall_dict = data.handle_coderwall(
                request, usernames['coderwall'])

    ### GitHub ###
    if usernames['github']:
        github_dict = data.handle_github(
                request, usernames['github'])

    ### Ohloh ###
    if usernames['ohloh']:
        ohloh_dict = data.handle_ohloh(
                request, usernames['ohloh'])

    ### Stack Exchange ###
    if usernames['stack_exchange']:
        stack_exchange_dict = data.handle_stack_exchange(
                request, usernames['stack_exchange'])

    ### Fedora Account System ###
    if usernames['fedora']:
        fedora_dict = data.handle_fedora(
                request,
                usernames['fedora'],
                passwords['fedora'])

    ### Stat calculation ###
    import stats

    stats_dict = stats.calculate_stats(
            github_dict,
            ohloh_dict,
            coderwall_dict,
            stack_exchange_dict)

    request.session.flash("Character sheet generated.")
    return {
            'username': username,
            'coderwall_data': coderwall_dict,
            'github_data': github_dict,
            'ohloh_data': ohloh_dict,
            'stack_exchange_data': stack_exchange_dict,
            'fedora_data': fedora_dict,
            'stats': stats_dict,
           }

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
