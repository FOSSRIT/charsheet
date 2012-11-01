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

from kitchen.text.converters import to_unicode
from sqlalchemy import create_engine
from knowledge.model import Fact, Entity, DBSession, init_model, metadata

import datetime
import forms

from facts import average_value, top_users


@view_config(route_name='home', renderer='home.mak')
def home_view(request):
    return {
        'charsheet_form': forms.CharsheetForm,
    }


@view_config(route_name='stats', renderer='stats.mak')
def global_stats(request):

    try:
        engine = create_engine('sqlite:///knowledge.db')
        init_model(engine)
        metadata.create_all(engine)

        data = {
            'users': dict(),
        }

        knowledge = DBSession
        knowledge_query = knowledge.query(Entity).all()
        for entity in knowledge_query:
            data['users'][entity.name] = dict()
            for fact in entity.facts.values():
                data['users'][entity.name][fact.key] = fact.value

        stats = {
            'avg_foo': average_value(data, 'foo'),
            'avg_dexterity': average_value(data, 'dexterity'),
            'avg_strength': average_value(data, 'strength'),
            'avg_wisdom': average_value(data, 'wisdom'),
            'avg_leadership': average_value(data, 'leadership'),
            'avg_determination': average_value(data, 'determination'),
            'avg_popularity': average_value(data, 'popularity'),
            'avg_num_languages': average_value(data, 'num_languages'),
            'avg_badges': average_value(data, 'badges'),
            'top_foo': top_users(data, 'foo'),
        }

    except:  # TODO: Make this more specific.
        data = None
        stats = None

    return {
        'stats': stats,
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
        }

        username = '???'  # Set default username
        # Cycle through usernames available, use first one that exists
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

    ### Gravatar ###
    if github_dict:
        if github_dict['email']:
            gravatar_url = data.get_gravatar_url(github_dict['email'])
    else:
        gravatar_url = None

    ### Stat calculation ###
    import stats

    stats_dict = stats.calculate_stats(
            github_dict,
            ohloh_dict,
            coderwall_dict)

    # Completion percent
    linked_services = 0
    total_services = 3
    if github_dict:
        linked_services += 1
    if ohloh_dict:
        linked_services += 1
    if coderwall_dict:
        linked_services += 1
    percent_complete = float(linked_services) / float(total_services)

    ### Knowledgedb integration ###

    engine = create_engine('sqlite:///knowledge.db')
    init_model(engine)
    metadata.create_all(engine)

    def inject_knowledge():
        knowledge = DBSession
        # for each stats dict, add a fact to an Entity that is
        # named the username
        character = Entity(u'%s' % username)
        character[u'name'] = (u'%s' % username)
        for key, value in stats_dict.items():
            character[key] = value
            #character[key] = to_unicode(value)
        knowledge.add(character)
        knowledge.commit()

    def the_facts():
        # Get the Knowledge Session
        knowledge = DBSession
        # Make the base Query, all Entities
        knowledge_query = knowledge.query(Entity).all()
        # Print out each Entity, and the values of each of their facts
        for entities in knowledge_query:
            from pprint import pprint
            pprint(entities)
            pprint(entities.facts.values())

    inject_knowledge()
    the_facts()
    """
    Issue pyramid badges using tahrir_db_api
    (with fact entity as a backend???)
    If user visits /charsheet/username, check the knowledge.db for
    'current_stats' fact. If the user has 'current_stats' in the knowledge.db,
    save their
    old stats as 'old_stats" or create a new fact called u'current_stats'
    that has an updated version #git commit the version???
    """

    request.session.flash("Character sheet generated.")
    return {
            'timestamp': datetime.datetime.now().strftime("%Y.%m.%d %H:%M"),
            'username': username,
            'usernames': usernames,
            'avatar_url': gravatar_url,
            'coderwall_data': coderwall_dict,
            'github_data': github_dict,
            'ohloh_data': ohloh_dict,
            'stats': stats_dict,
            'percent_complete': percent_complete,
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
