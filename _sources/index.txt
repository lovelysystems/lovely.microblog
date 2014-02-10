=============================================================
How To Create Highly Scalable Web Backends for app Developers
=============================================================

In this document we want to show app developers how they can build highly
scalable web backends to realize their app ideas.
There are many tutorials about building backends which will fit your needs
at the beginning.
But if your app succeeds the amount of users will grow -- and also your server
load will. With the higher load the response time of your backend will increase
dramatically. At this point you want to add some additional machines to
increase the power of your cluster. But that's not that easy if your datastorage
is based on a single conventional relational database like mysql.

In this tutorial we will walk through the creation of a tiny iOS application
with a highly scalable web backend using:

   - `Crate <https://crate.io>`_ An SQL and doc-oriented database
   - `Lovely Pyrest <http://lovelysystems.github.io/lovely.pyrest/index.html>`_ A web framework on top of `pyramid <http://www.pylonsproject.org/projects/pyramid/about>`_

We will build a tiny blogging application where registered users can create
posts which can be read by anyone.

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
   scalability_reliability.rst

.. note::

    The target audience of this tutorial are iOS Developers which require a
    backend for an app. Therefore it's based on OSX. Because the backend is
    based on `Lovely Pyrest` it runs on all popular UNIX-like systems
    such as Linux and FreeBSD. Setup and installation instructions may
    differ.

Getting the Source Code from Github
-----------------------------------

If you want the sources of the app we create in this tutorial, clone the
`lovely.microblog` repository.

Cloning the source code installs a copy of the repository on your computer.
You must have git installed to do this::

    git clone git@github.com:lovelysystems/lovely.microblog.git

The repository contains three directories:

|    /backend
|    /docs
|    /frontend

The `/backend` directory contains all the sources for the backend
application and a README file. Follow the instructions in README to setup the app.

The `/frontend` directory contains sources of the iOS app and the xcode
workspace::

    open frontend-ios/microblog/microblog.xcworkspace
