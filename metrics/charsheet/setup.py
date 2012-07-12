import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.txt')).read()
CHANGES = open(os.path.join(here, 'CHANGES.txt')).read()

requires = [
    'coderwall',
    'elementtree',
    'pyramid',
    'SQLAlchemy',
    'transaction',
    'pygithub3',
    'pyramid_tm',
    'pyramid_debugtoolbar',
    'waitress',
    'zope.sqlalchemy',
    ]

setup(name='charsheet',
      version='0.0',
      description='charsheet',
      long_description=README + '\n\n' + CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pylons",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='',
      author_email='',
      url='',
      keywords='web wsgi bfg pylons pyramid',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      test_suite='charsheet',
      install_requires=requires,
      entry_points="""\
      [paste.app_factory]
      main = charsheet:main
      [console_scripts]
      initialize_charsheet_db = charsheet.scripts.initializedb:main
      """,
      )
