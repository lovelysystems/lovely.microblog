==========================================================
How To Create Highly Scalable Web Backends for iOS Devices
==========================================================

In this tutorial, we will walk through the creation of a tiny iOs application with a highly scalable web backend using: 


   - `Crate <https://crate.io>`_ An SQL and doc-oriented database
   - `Lovely Pyrest <http://lovelysystems.github.io/lovely.pyrest/index.html>`_ A web framework on top of `pyramid <http://www.pylonsproject.org/projects/pyramid/about>`_

We will build a tiny blogging application where registered users can create posts which can be read by anyone.

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
You should have git installed to do this::

    git clone git@github.com:lovelysystems/lovely.microblog.git

The repository contains three directories:

    /backend
    /docs
    /frontend

The `/backend` directory contains all the sources for the backend
application and a README file. Follow the instructions in README to setup the app.

The `/frontend` directory contains sources of the iOS app and the xcode
workspace::

    open frontend-ios/microblog/microblog.xcworkspace
