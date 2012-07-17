from pyramid.config import Configurator
from pyramid.session import UnencryptedCookieSessionFactoryConfig
from sqlalchemy import engine_from_config

from .models import DBSession


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)
    # session factory
    session_factory = UnencryptedCookieSessionFactoryConfig('supasecret')
    # configuration setup
    config = Configurator(settings=settings, session_factory=session_factory)
    config.include('pyramid_debugtoolbar')
    # static view setup
    config.add_static_view('static', 'static', cache_max_age=3600)
    # routes setup
    config.add_route('home', '/')
    config.add_route('error', '/error')
    config.add_route('charsheet', '/charsheet/{username}')
    config.scan()
    return config.make_wsgi_app()
