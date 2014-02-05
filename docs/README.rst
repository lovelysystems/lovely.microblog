=============================
Lovely Microblog Documentation
=============================

How to create high scalable web-backends for ios developers

Initial Setup for Development
=============================

Bootstrap with python 2.7::

    /path/to/python2.7 bootstrap.py

Run buildout::

    bin/buildout -N

Generating Documentation
========================

Before generating the new documentation make sure the `gh-pages` submodule is up-to-date::

    git submodule init

    git submodule update

To generate the new documentation run::

    ./bin/sphinx-html

The documentation is located in the `gh-pages` directory which points to the
`gh-pages` submodule.

Publish documentation
---------------------

To publish the documentation commit the changed files in the `gh-pages`
submodule::

    cd gh-pages

    git add <changed-files>

    git commit -m "updated documentation"

    git push origin gh-pages
