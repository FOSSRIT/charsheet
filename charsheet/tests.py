import unittest
import transaction

from pyramid import testing

from .models import DBSession

"""
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

    def basic_test(self):
        from .views import charsheet
        request = testing.DummyRequest()
        info = charsheet(request)
        self.assertEqual(info['one'].name, 'one')
        self.assertEqual(info['project'], 'charsheet')
"""
