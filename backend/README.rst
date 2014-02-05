=============================
Lovely Microblog
=============================

How to build an iOS app with a scalable web backend

Requirements
============

The following packages need to be installed::

    brew install python27 libevent

Or with macports::

    sudo port install python27 libevent

Initial Setup for Development
=============================

Bootstrap with python 2.7::

    /path/to/python2.7 bootstrap.py

Run buildout::

    bin/buildout -N

Start Dev Setup
===============

All needed programs can be started under supervisor control.

Start supervisor::

  ./bin/supervisord

Check the status of the programs::

  ./bin/supervisorctl status

  The app is available at http://localhost:9210

For debugging the Pyramid app can be started in the foreground. Take care to
stop the apps in the supervisor controller, then run::

  ./bin/app
  
Setup crate database
--------------------

To initialize a empty crate database run the command

  $ bin/crate_setup

If the database has been setup already the script will raise an error but no
data will get destroyed.


Clean up crate database
-----------------------

To reset the crate database to it's initial state run the command

  $ bin/crate_cleanup

CAUTION: This command will delete all data!
  
  
Generating Documentation
========================

To generate the HTML documentation start this script::

  ./bin/sphinx-html
  
