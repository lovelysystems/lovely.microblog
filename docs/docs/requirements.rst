============
Requirements
============

Python 2.7
==========

A working python 2.7 installation is required. We recommend not to use
the builtin OSX python.
Instead you should use `homebrew <http://brew.sh>`_ to install python::

    brew install python27

If you prefer using `macports <http://http://www.macports.org>`_ run::

    sudo port install python27

Java 7
======

Java 7 is needed for crate:

    `Java SE Development Kit 7 Downloads <http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html>`_

Installation problems
---------------------

If you have any problems with the installation try to
set the environment variable JAVA_HOME in your shell rc file (~/.bashrc or
~/.zshrc)::

    export JAVA_HOME=`/usr/libexec/java_home`

Source the shell rc file and check the java version::

    $ source ~/.bashrc
    or
    $ source ~/.zshrc

    $ java -version

