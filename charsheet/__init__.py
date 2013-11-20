import os

from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from pyramid.config import Configurator
from pyramid.session import UnencryptedCookieSessionFactoryConfig
from sqlalchemy import engine_from_config

from .models import DBSession


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)

    # session, authentication, and authorization
    authn_policy = AuthTktAuthenticationPolicy(secret='supasecret')
    authz_policy = ACLAuthorizationPolicy()
    session_factory = UnencryptedCookieSessionFactoryConfig(
            settings['session.secret'])

    # load secret stuff from secret.ini (not provided in repo)
    try:
        if os.environ.get('OPENSHIFT_DATA_DIR'):
            path = os.environ['OPENSHIFT_DATA_DIR']
        else:
            path = '.'
        from paste.deploy.loadwsgi import appconfig
        secret_config = appconfig('config:secret.ini',
                'charsheet', relative_to=path)
    except IOError:
        print 'Failed to load secret.ini'
        return 0
    settings.update({
        'velruse.github.consumer_key':
                secret_config['velruse.github.consumer_key'],
        'velruse.github.consumer_secret':
                secret_config['velruse.github.consumer_secret'],
    })

    # configuration setup
    config = Configurator(
            settings=settings,
            session_factory=session_factory)

    # use Mako templates
    config.include('pyramid_mako')

    # static view setup
    config.add_static_view('static', 'static', cache_max_age=3600)

    # velruse
    config.include('velruse.providers.github')
    config.add_github_login(
            settings['velruse.github.consumer_key'],
            settings['velruse.github.consumer_secret'])

    # routes setup
    config.add_route('home', '/')
    config.add_route('submit', '/submit')
    config.add_route('handle_search', '/handle_search')
    config.add_route('charsheet', '/charsheet/{username}')
    config.add_route('stats', '/stats')
    config.add_route('login', '/login')
    config.add_route('logout', '/logout')
    config.add_route('verify_openid', pattern="/dologin.html")
    config.add_view(view='pyramid_openid.verify_openid',
                      route_name='verify_openid')
    # TODO: make this service-agnostic
    config.scan()
    return config.make_wsgi_app()
