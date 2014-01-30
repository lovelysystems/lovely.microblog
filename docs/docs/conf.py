import os
import re

here = os.path.dirname(__file__)
project_root = os.path.dirname(here)

extensions = []

VERSION = "0.0.0"

# The suffix of source filenames.
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

nitpicky = True

# load doctest extension to be able to setup testdata in the documentation that
# is hidden in the generated html (by using .. doctest:: :hide:)
extensions.append('sphinx.ext.doctest')

# General information about the project.
project = u'How to create high scalable web-backends for ios developers'
copyright = u'2014, Lovely Systems'

version = release = VERSION
exclude_patterns = ['docs.egg-info', 'parts', 'checkouts']

html_theme = 'pyramid'
