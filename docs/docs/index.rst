=====================================================
How to Create high scalable web backends for iOS-Devs
=====================================================

In this tutorial, we will walk through the creation of a tiny iOs application with
a high scalable webbackend using:

   - `Crate <https://crate.io>`_ An SQL and Doc-oriented databse
   - `Lovely Pyrest <http://lovelysystems.github.io/lovely.pyrest/index.html>`_ A Web-Framework on top of `pyramid <http://www.pylonsproject.org/projects/pyramid/about>`_

In this tutorial we will build
a tiny blogging application, where registered users can create posts which can
be read by anyone.

Contents:
---------

.. toctree::
   :maxdepth: 2
   :titlesonly:

   requirements.rst
   setup.rst
   start_coding.rst
   create_blogposts.rst
   frontend_blogposts.rst
   frontend_create_post.rst
   be_authentication.rst
   frontend_login.rst


Getting the Source Code from Github
-----------------------------------

If you want the sources of the app we create in this tutorial, clone the
`lovely.microblog` repository.

Cloning the source code installs a copy of the repository on your computer.
It always requires that you have git installed.

    git clone git@github.com:lovelysystems/lovely.microblog.git

The repsority contains three directories:

    /backend
    /docs
    /frontend

The `/backend` directory contains all the source code for the backend
application and a README file. Follow the instructions in README to setup the app.

The `/frontend` directory contains the final iOS app and the xcode workspace::

    open frontend-ios/microblog/microblog.xcworkspace
