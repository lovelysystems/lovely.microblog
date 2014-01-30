============
Start Coding
============

As mentioned before we want to build a small microblogging application, where
you can create blogposts, follow other users and read their blogposts.

The microblog Application
=========================

The project directory contains a folder named `microblog`.
This is the interesting part of the project::

    sh$ ls -l microblog
    __init__.py
    green.py
    model.py
    server.py

`green.py` contains a server_factory which starts the app using the
gevent WSGIServer.

`model.py` contains two helper methods for refreshing crate, we'll catch that later.

`server.py` contains an empty `app_factory` and setup code for crate.

The BlogPost Service
====================

As first step we create a new REST-Service for reading and creating blogposts. So create a `blogpost` module inside the microblog module::

    $sh mkdir blogpost
    $sh touch blogpost/__init__.py

.. note::

   It's not necessary to create a module for the blogpost. If you want you can
   put the service inside the server.py or every other module.
   (We would not recommend to do that, it's like putting all the Code of an ios
   app into the `AppDelegate`)

Inside the `blogpost` module, create a file named `service.py`. The contents
of the file should look like::

    from lovely.pyrest.rest import RestService, rpcmethod_route
    
    
    @RestService('blogposts')
    class BlogPostService(object):
    
        def __init__(self, request):
            self.request = request
    
        @rpcmethod_route(request_method="GET")
        def list(self):
            """ Return all blogposts """
            return {}
    
    
    def includeme(config):
        config.add_route('blogposts', '/blogposts', static=True)

includeme
---------

The includeme function declares the `blogposts` route. It defines that the
BlogPostService should be called if someone requests `/blogposts`.
The first parameter `blogposts` is just an identifier.
The second parameter is the relative url path.

BlogPostService
---------------

The `BlogPostService` class is the implementation of our rest service. 
It needs an `__init__` method which takes a request object.

RestService decorator
---------------------

The `RestService('blogposts')` decorator is necessary for the application to mark the class as a REST service.
The argument is the route identifier. If someone requests the `/blogposts`
uri, the request is routed to the BlogPostService because it has the same
identifier as the blogposts route.

List function
-------------

The `list` function is a very basic function which returns an empty dictionary.
The `rpcmethod_route` decorator defines that this method should be used
if a GET request is performed on the service.

.. note::

    If the `request_method` argument is not passed, `GET` is used as default
    HTTP Method. So you could ommit it, in this case.

Include the Service
===================

Now open the `server.py` file and include and scan the created module, so the
`app_factory` method looks like::

    def app_factory(global_config, **settings):
        """Setup the main application for paste
    
        This must be setup as the paste.app_factory in the egg entry-points.
        """
        config = Configurator(settings=settings, autocommit=True)
        config.include('microblog.blogpost.service')
        config.scan('microblog.blogpost')
        crate_init(config)
    
        return config.make_wsgi_app()

config.include
--------------

`config.include(microblog.blogpost.service)` imports the created service.py
and executes the `includeme` function. Alternatively you could declare the route
directly in the `app_factory`. Then you should ommit the `includeme` function in
the service.py.

config.scan
-----------

`config.scan(microblog.blogpost)` tells the application to import
`microblog.blogpost` and to register the RestService internally.

Run the application
===================

After restarting the app, you can request the blogpost service using your browser
or curl::

    $sh curl http://localhost:9210/blogposts
    {}

The response body contains the empty dictionary, which is returned by the
`list` function.
