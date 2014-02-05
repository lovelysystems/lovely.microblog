============================
Setup Your First Application
============================

Let's start creating the backend application. In this tutorial we will build
a tiny blogging application, where registered users can create posts which can
be read by anyone.

Sandboxed Development Setup
===========================

We prefer to use a sandboxed development setup, using
`buildout <http://www.buildout.org/en/latest/>`_. Buildout is a Python-based build
system for creating, assembling and deploying applications.

Project Template
----------------

We provide a `cookiecutter <https://github.com/audreyr/cookiecutter>`_ project
template which contains a working buildout configuration including:

    - Basic setup for an application using lovely.pyrest
    - scripts to setup and teardown the crate database
    - A configured `supervisord <http://supervisord.org>`_ to control the crate
      and app processes for development
    - A script to generate a `sphinx <http://sphinx-doc.org>`_>`_ documentation
      for your backend

Setup using the template
------------------------

Install cookiecutter::

    sh$ pip install https://download.lovelysystems.com/public/cookiecutter-0.7.0-conditional.tar.gz

Create the microblog project::

    sh$ cookiecutter https://github.com/lovelysystems/cookiecutter-lovely-setup

Cookiecutter wants some input. Except for the `repo_name` you can leave the fields
blank and just press Enter to use the defaults. Of course you may
change the `company_name`, `email` etc. ::

    Cloning into 'cookiecutter-lovely-setup'...
    remote: Counting objects: 42, done.
    remote: Compressing objects: 100% (32/32), done.
    remote: Total 42 (delta 7), reused 39 (delta 4)
    Unpacking objects: 100% (42/42), done.
    Checking connectivity... done
    company_name (default is "Lovely Systems")?
    email (default is "office@lovelysystems.com")?
    github_username (default is "lovelysystems")?
    project_name (default is "Lovely Boilerplate")? Lovely Microblog
    repo_name (default is "boilerplate")? microblog
    project_short_description (default is "Python Boilerplate contains all the boilerplate you need to create a Python package.")? Yet another microblog
    release_date (default is "2014-01-24")? y
    year (default is "2014")? y
    version (default is "0.0.0")? y
    py_package (default is "yes")? y
    buildout (default is "yes")? y
    pyrest (default is "yes")? y
    crate (default is "yes")? y
    supervisor (default is "yes")? y
    sphinx (default is "yes")? y

There should be a folder called `microblog` (or your repo_name) which contains
several files::

    sh$ ls microblog
    CHANGES.rst
    README.rst
    bootstrap.py
    buildout.cfg
    crate.cfg
    docs
    etc
    log
    microblog
    setup.py
    var
    versions.cfg

You now have successfully created the development environment!
If you are using git you could initialize a repo with something like this::

    sh$ cd microblog
    sh$ git init
    sh$ git add
    sh$ git commit -m "Initial commit"

Bootstrap and buildout
----------------------

After creating or checking out the project the first time you have to bootstrap
the app::

    sh$ python2.7 bootstrap.py
    Creating directory '/Users/philipp/sandbox/test/microblog/bin'.
    Creating directory '/Users/philipp/sandbox/test/microblog/parts'.
    Creating directory '/Users/philipp/sandbox/test/microblog/develop-eggs'.
    Generated script '/Users/philipp/sandbox/test/microblog/bin/buildout'
    
The created `bin` directory contains a buildout script::

    sh$ bin/buildout -N

If nothing went wrong, the `bin` directory contains all the scripts you need to start developing::

    sh$ ls -l bin
    app
    buildout
    crash
    crate_cleanup
    crate_setup
    py
    sphinx-html
    supervisorctl
    supervisord

The app script starts the app in foreground::

    sh$ bin/app

So you can make some requests::

    sh$ curl -XGET localhost:9210
    <html>
        ...
        <title>404 Not Found</title>
    ...

The supervisord script starts the app and crate in background::

    sh$ bin/supervisord
    sh$ bin/supervisorctl status
    app                              RUNNING ...
    crate                            RUNNING ...

To stop the app or crate run::

    sh$ bin/supervisorctl stop app

Non Sandboxed Development Setup
===============================

If you prefer not to use buildout you can install crate and lovely.pyrest
on your own following these instructions::

    - `Setup Lovely Pyrest <http://lovelysystems.github.io/lovely.pyrest/setup.html>`_
    - `Crate <https://github.com/crate/crate>`_
