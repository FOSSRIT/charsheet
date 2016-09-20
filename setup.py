import os

from setuptools import setup, find_packages

here = os.path.abspath(os.path.dirname(__file__))
README = open(os.path.join(here, 'README.rst')).read()
CHANGES = open(os.path.join(here, 'CHANGES.rst')).read()

requires = [
    'coderwall',
    'knowledge>=0.3',
    'pyramid',
    'pyramid_mako',
    'SQLAlchemy',
    'transaction',
    'pygithub',
    'pyramid_tm',
    'pyramid_debugtoolbar',
    'pyramid_openid',
    'python-dateutil',
    'pytz',
    'requests',
    'waitress',
    'zope.sqlalchemy',
    'velruse',
]

if os.environ.get("OPENSHIFT_APP_NAME"):
    requires.append("gevent")
    requires.append('mysql-python == 1.2.3')

setup(name='charsheet',
      version='1.0',
      description='charsheet',
      long_description=README + '\n\n' + CHANGES,
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pylons",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='David Gay',
      author_email='oddshocks@gmail.com',
      url='http://github.com/FOSSRIT/charsheet',
      keywords='web wsgi bfg pylons pyramid foss charsheet',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      tests_require=[
          'zope.interface',
          'nose',
          'coverage',
      ],
      test_suite='charsheet',
      install_requires=requires,
      entry_points="""\
      [paste.app_factory]
      main = charsheet:main
      [console_scripts]
      initialize_charsheet_db = charsheet.scripts.initializedb:main
      """,
      )
