import os
import re
import ConfigParser

from setuptools import setup, find_packages


execfile(os.path.join(os.path.dirname(__file__), 'microblog/__init__.py'))

versionf_content = open("microblog/__init__.py").read()
version_rex = r'^__version__ = [\'"]([^\'"]*)[\'"]$'
m = re.search(version_rex, versionf_content, re.M)
if m:
    VERSION = m.group(1)
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

requires = [
    'crate [sqlalchemy]',
    'gevent',
    'pyramid',
    'pyramid_jinja2',
    'pyramid_mailer',
    'validictory',
    'python-dateutil',
    'lovely.pyrest',
    'pyramid_tm',
    'zope.sqlalchemy',
]

setup(name='microblog',
      version=VERSION,
      author='Lovely Systems',
      author_email='office@lovelysystems.com',
      packages=find_packages(),
      include_package_data=True,
      extras_require=dict(
      ),
      zip_safe=False,
      install_requires=requires,
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