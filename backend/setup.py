import os
import re
import ConfigParser
from setuptools import setup, find_packages

versionf_content = open("microblog/__init__.py").read()
version_rex = r'^__version__ = [\'"]([^\'"]*)[\'"]$'
m = re.search(version_rex, versionf_content, re.M)
if m:
    version = m.group(1)
else:
    raise RuntimeError('Unable to find version string')


def get_versions():
    """picks the versions from version.cfg and returns them as dict"""
    versions_cfg = os.path.join(os.path.dirname(__file__), 'versions.cfg')
    config = ConfigParser.ConfigParser()
    config.optionxform = str
    config.readfp(open(versions_cfg))
    return dict(config.items('versions'))


def nailed_requires(requirements, pat=re.compile(r'^(.+)(\[.+\])?$')):
    """returns the requirements list with nailed versions"""
    versions = get_versions()
    res = []
    for req in requirements:
        if '[' in req:
            name = req.split('[', 1)[0]
        else:
            name = req
        if name in versions:
            res.append('%s==%s' % (req, versions[name]))
        else:
            res.append(req)
    return res


def read(path):
    return open(os.path.join(os.path.dirname(__file__), path)).read()


here = os.path.abspath(os.path.dirname(__file__))
readme = open(os.path.join(here, 'README.rst')).read()

requires = [
    'crate [sqlalchemy]',
    'gevent',
    'pyramid',
    'validictory',
    'lovely.pyrest',
]

setup(name='microblog',
      version=version,
      description='Creating high scalable web-backends for iOS-Devs',
      long_description=readme,
      classifiers=[
          "Programming Language :: Python",
      ],
      author='lovely systems',
      author_email='office@lovelysystems.com',
      url='https://github.com/lovelysystems/lovely.microblog',
      keywords='pyramid rest framework',
      license='apache license 2.0',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      install_requires=requires,
      test_suite="microblog",
      entry_points={
          'paste.app_factory': [
              'main=microblog.server:app_factory',
          ],
          'paste.server_factory': [
              'server=microblog.green:server_factory',
          ],
          'console_scripts': [
              'app=pyramid.scripts.pserve:main',
          ],
          },
      )
