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
    - A script to generate a `sphinx <http://sphinx-doc.org>`_ documentation
      for your backend

Setup using the template
------------------------

Install cookiecutter with `pip <https://pypi.python.org/pypi/pip>`_::

    sh$ pip install https://download.lovelysystems.com/public/cookiecutter-0.7.0-conditional.tar.gz

Create the microblog project::

    sh$ cookiecutter git@github.com:lovelysystems/cookiecutter-lovely-setup

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

There will be a folder called `microblog` (or your repo_name) which contains
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
    sh$ git add .
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

    sh$ curl -XGET localhost:9210/probe_status
    OK

The supervisord script starts two instances of the app (ports: 9210, 9211) and two
instances of crate (ports: 4200, 4201) in the background.
You have to cancel the app script first by pressing ^CTRL + C else supervisord can't
start the first app instance because the port is already in use::

    sh$ bin/supervisord
    sh$ bin/supervisorctl status
    app:app_9210                     RUNNING ...
    app2:app_9211                    RUNNING ...
    crate:crate_4200                 RUNNING ...
    crate2:crate_4201                RUNNING ...
    haproxy                          RUNNING ...

To stop an app or a crate instance run::

    sh$ bin/supervisorctl stop app:app_9210

To stop all app or crate instances run::

    sh$ bin/supervisorctl stop "crate:*"

During development you have to restart the app frequently. It's more convinient
to use the supervisor just for crate. The app script should be started in
foreground, so you can easily restart the app. A further advantage of running
the app in foreground is that you see the output of the app script.
This might help finding errors.
After starting supervisord run::

    sh$ bin/supervisortctl stop app
    sh$ bin/app

To restart the app stop the script by pressing ^CTRL + C and start it again::

    sh$ bin/app

HAProxy
-------

An `haproxy <http://haproxy.1wt.eu>`_ instance is also started by supervisord.
HAProxy is a reliable, high performance TCP/HTTP load balancer. It's configured
to listen on port 9100 and it load balances requests between the
app instances::

    sh$ curl -XGET localhost:9100/probe_status
    OK

HAProxy periodically checks the health state of the app servers by requesting
`/probe_status`. If an instance is not reachable anymore, haproxy won't pass
requests to it.

Topology
--------

The local topology of the individual services looks as follows:

.. uml::

    package "localhost" {
        [haproxy - 9100] as ha1
        [app - 9210] as ap1
        [crate - 4200] as cr1

        [app - 9211] as ap2
        [crate - 4201] as cr2

    }

    ha1 --> ap1
    ha1 --> ap2

    ap1 --> cr1
    ap1 --> cr2

    ap2 --> cr1
    ap2 --> cr2

For the next steps in this tutorial it's not necessary to always run the full
topology, but it doesn't hurt either. As mentioned
before we recommend to use the supervisor just for crate and to run an app
instance in foreground.

For the next steps we can stop an app instance and / or the haproxy::

    $sh bin/supervisorctl stop app:app_9211
    $sh bin/supervisorctl stop haproxy

You also can stop the second crate node::

    $sh bin/supervisorctl stop crate:crate_4201

So your topology looks like:

.. uml::

    package "localhost" {
        [app - 9210] as ap1
        [crate 4200] as cr1
    }

    ap1 --> cr1

For more informations about the topology see :doc:`scalability_reliability`.

.. note::

   If you run both app instances and you want to request the haproxy it's
   important to restart both app instances if you make some changes.

Non Sandboxed Development Setup
===============================

If you prefer not to use buildout you can install crate and lovely.pyrest
on your own following these instructions:

    - `Setup Lovely Pyrest <http://lovelysystems.github.io/lovely.pyrest/setup.html>`_
    - `Crate <https://github.com/crate/crate>`_
