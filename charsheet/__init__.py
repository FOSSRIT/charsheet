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

    # configuration setup
    config = Configurator(
            settings=settings,
            session_factory=session_factory)

    # static view setup
    config.add_static_view('static', 'static', cache_max_age=3600)

    # routes setup
    config.add_route('home', '/')
    config.add_route('charsheet', '/charsheet')
    config.add_route('stats', '/stats')
    config.add_route('login', '/login')
    config.add_route('logout', '/logout')
    config.add_route('verify_openid', pattern="/dologin.html",
            view='pyramid_openid.verify_openid')
    config.scan()
    return config.make_wsgi_app()
