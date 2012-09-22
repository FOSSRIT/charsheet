import unittest
import transaction

from pyramid import testing

from .models import DBSession


class TestCharsheet(unittest.TestCase):

    def setUp(self):
        self.config = testing.setUp()
        from sqlalchemy import create_engine
        engine = create_engine('sqlite://')
        from .models import (
            Base,
            )
        DBSession.configure(bind=engine)
        Base.metadata.create_all(engine)
        with transaction.manager:
            # add models here
            pass

    def tearDown(self):
        DBSession.remove()
        testing.tearDown()

    def test_basic(self):
        from .views import home_view
        request = testing.DummyRequest()
        info = home_view(request)
        self.assertEqual(info['project'], 'charsheet')
