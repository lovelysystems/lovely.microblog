import os
import re

here = os.path.dirname(__file__)
project_root = os.path.dirname(here)

extensions = []


# load lovely.pyrest sphinx extension to autogenerate
# service documentation
extensions.append('lovely.pyrest.sphinx')



# inject the VERSION constant used below
# This can be used because the build script updates the version number before
# building the RPM.
versionf_content = open("../microblog/__init__.py").read()
version_rex = r'^__version__ = [\'"]([^\'"]*)[\'"]$'
m = re.search(version_rex, versionf_content, re.M)
if m:
    VERSION = m.group(1)
else:
    raise RuntimeError('Unable to find version string')



pyramid_conf = os.path.join(project_root, 'etc', 'development.ini')


# The suffix of source filenames.
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

nitpicky = True

# load doctest extension to be able to setup testdata in the documentation that
# is hidden in the generated html (by using .. doctest:: :hide:)
extensions.append('sphinx.ext.doctest')

# General information about the project.
project = u'How to build an iOS app with a scalable web backend'
copyright = u'2014, Lovely Systems'

version = release = VERSION
exclude_patterns = ['microblog.egg-info', 'parts', 'checkouts']

html_theme = 'pyramid'