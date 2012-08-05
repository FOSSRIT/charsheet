import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.rst')).read()
CHANGES = open(os.path.join(here, 'CHANGES.rst')).read()

requires = [
    'coderwall',
    'elementtree',
    'kitchen',
    'pyramid',
    'py-stackexchange',
    'SQLAlchemy',
    'transaction',
    'tw2.core',
    'tw2.forms',
    'tw2.dynforms',
    'tw2.sqla',
    'tw2.jqplugins.jqgrid',
    'pygithub3',
    'pyramid_tm',
    'pyramid_debugtoolbar',
    'pyramid_openid',
    'python-dateutil',
    'python-fedora',
    'pytz',
    'waitress',
    'zope.sqlalchemy',
    'mysql-python',
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
      keywords='web wsgi bfg pylons pyramid foss charsheet',
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
