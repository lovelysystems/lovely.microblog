==============
Authentication
==============

Our application currently allows anyone with access to the server to view and create blogposts.
We'll change that to allow only registered users to create blogposts.

So we need a service to create new users, and we have to implement access control.

As in `Create Blogposts` we will:

    - create a database table
    - create a SQL Alchemy model
    - implement a user service
    - restrict the "create blogpost" endpoint to registered users

Table users
===========

We want to create a very basic user table with these columns::

    - id: primary key
    - name: username
    - password: the users password

Open the file `<project-dir>/etc/crate_setup.sql` and add the following SQL
statement::

    create table users (id string primary key, name string, password string)

Add the following line to the `create_cleanup.sql` file::

    drop table users

Ensure that crate is running and then run crate_setup::

    $sh bin/crate_setup

.. note::

   You might get an error message because the `blogpost` table is already created. This
   error can be ignored.

SQL Alchemy User Model
======================

Create a new `user` module similar to the `blogpost` module
we created before::

    $sh mkdir user
    $sh touch user/__init__.py

Create the file `user/model.py` with the following contents::

    from sqlalchemy import Column, String
    from microblog.model import Base, genuuid
    
    
    class User(Base):
    
        __tablename__ = 'users'
    
        id = Column(String, default=genuuid, primary_key=True)
        name = Column('name', String, nullable=False)
        password = Column('password', String, nullable=False)

Also move the `genuuid` function from `microblog/blogpost/model.py` to
`microblog/model.py` and change the import at the top of
`microblog/blogpost/model.py` to::

    from microblog.model import Base, genuuid

Enabling Authentication Policy
==============================

By default, Pyramid does not enable any authentication policy. All views are accessible
by anonymous users. In order to begin protecting views from execution
based on security settings, you need to enable an authentication policy.

To do that we have to change the instantiation of the Configurator
in `microblog.server.app_factory`::

    from pyramid.authentication import AuthTktAuthenticationPolicy
    ...
    def app_factory(global_config, **settings):
        config = Configurator(settings=settings,
                              autocommit=True,
                              authentication_policy=AuthTktAuthenticationPolicy('your-secret-token'))

Also create an AuthACLFactory in the `service.py`::

    from pyramid import security
    ...
    class AuthACLFactory(object):
    
        @property
        def __acl__(self):
            user = security.authenticated_userid(self.request)
            if user is not None:
                return [(security.Allow, security.Everyone, security.Authenticated)]
            return []
    
        def __init__(self, request):
            self.request = request

The factory checks if the user is logged in and adds the permissions
`Allow, Everyone and Authenticated` to the current context.

For details about authentication and authorization in pyramid see:
`Pyramid security <http://docs.pylonsproject.org/projects/pyramid/en/latest/narr/security.html>`_.

The user service
================

Create the file `user/service.py` with the following contents::

    from pyramid import security
    from sqlalchemy.orm.exc import NoResultFound
    from lovely.pyrest.rest import RestService, rpcmethod_route, rpcmethod_view
    from hashlib import sha1
    
    from microblog.server import AuthACLFactory
    from microblog.user.model import User
    from ..model import DBSession, refresher
    

    @RestService('users')
    class UserService(object):
    
        def __init__(self, request):
            self.request = request
    
        @rpcmethod_route()
        @rpcmethod_view(permission=security.Authenticated)
        def list(self):
            """ List all registered users """
            query = DBSession.query(User).order_by(User.name)
            users = query.all()
            result = []
            for user in users:
                result.append({"name": user.name})
            return {"data": {"users": result}}
    
        @rpcmethod_route(route_suffix="/register", request_method="POST")
        @refresher
        def register(self, name, password):
            """ Register a new user """
            user = User()
            user.name = name
            user.password = self.hash_password(password)
            DBSession.add(user)
            return {"status": "success"}
    
        @rpcmethod_route(route_suffix="/login", request_method="POST")
        def login(self, name, password):
            """ Login the given user """
            hashed_pwd = self.hash_password(password)
            query = DBSession.query(User).filter(User.name == name,
                                                 User.password == hashed_pwd)
            status = 'failed'
            try:
                user = query.one()
                headers = security.remember(self.request, user.name)
                self.request.response.headerlist.extend(headers)
                status = 'success'
            except NoResultFound:
                self.request.response.status = 401
            finally:
                return {"status": status}
    
        def hash_password(self, password):
            if isinstance(password, unicode):
                password_8bit = password.encode('UTF-8')
            else:
                password_8bit = password
            hashed = sha1('salt' + password_8bit).hexdigest()
            if not isinstance(hashed, unicode):
                hashed = hashed.decode('UTF-8')
            return hashed
    
    
    def includeme(config):
        config.add_route('users', '/users', static=True, factory=AuthACLFactory)

The list method
---------------

In the list method in the blogposts service we fetch all users and
build a result list which contains the usernames.

Sometimes it's required to pass arguments to the view. For this case use the
decorator `rpcmethod_view`.
Because we don't want strangers to see the user list we use the `rpcmethod_view`
decorator to pass the required permission to the view.

It's also possible to restrict access to the whole service::

    @RestService('users', permission=security.Authenticated)

We shouldn't do that, because register and login must be accessible for any
user.

The register method
-------------------

Like we did in the blogposts service we create a new user here and add it to the
DBSession. We don't have to flush the DBSession manually because this time
we don't want to return the users id in the response.

We pass the parameter `route_suffix` to the `rpcmmethod_route` decorator so the
register uri is `/users/register`.

The login method
----------------

The `login` method tries to query a user with the given name and the hashed password.
If such an user exists `security.remember` is called and the return header
that contains the authentication cookie is added to the response header.

If the user is not found we change the response status code to 401 UNAUTHORIZED
and return an error status.

includeme
---------

As in the blogpost service we define the route in the `includeme` function.
We also pass the `AuthACLFactory` we created earlier, to determine the users
permission.

Test the app
============

Scan and include the new modules within the `app_factory`::

    ...
    config.include('microblog.user.service')
    ...
    config.scan('microblog.user')

After restarting the app try to request the users list::

    $sh curl -XGET localhost:9210/users
    <html>
     <head>
      <title>403 Forbidden</title>
     </head>
     <body>
      <h1>403 Forbidden</h1>
      Access was denied to this resource.<br/><br/>
    Unauthorized: UserService failed permission check
    
    
     </body>
    </html>

So register a new user::

    curl -XPOST localhost:9210/users/register -d '{"name": "lovely", "password": "1234"}' -H "Content-Type: application/json"
    {"status": "success"}

Login::

    curl -XPOST localhost:9210/users/login -d '{"name": "lovely", "password": "1234"}' -H "Content-Type: application/json" -vv
    ...
    < Set-Cookie: auth_tkt="<authentication_token>"; Path=/; Domain=.localhost
    ...
    {"status": "success"} 

Copy the authentication token and fetch the user list as authenticated user::

    curl -XGET localhost:9210/users -H 'Cookie: auth_tkt="<authentication_token>"'
    {"data": {"users": [{"name": "lovely"}]}}

Restrict Creating Blogposts
===========================

To restrict the `create` method of the blogpost service just add this decorator::

    @rpcmethod_view(permission=security.Authenticated)

It's also necessary to pass the factory when adding the route::

    config.add_route('blogposts', '/blogposts', static=True, factory=AuthACLFactory)

Because only authenticated users are allowed to create a new post we can adapt
the `create` method so the correct username gets assigned to creator::

    user = security.authenticated_userid(self.request)
    blogpost.creator = user

====================
Test the application
====================

Restart the app and create a new post::

    $sh curl -XPOST localhost:9210/blogposts -H 'Cookie: auth_tkt="<token>"' -d '{"text": "authenticated post"}' -H "Content-Type: application/json"

    $sh curl -XGET localhost:9210/blogposts
    {
        "data": {
            "blogposts": [
                {
                    "created": "...",
                    "creator": "lovely",
                    "id": "...",
                    "text": "authenticated post"
                }
            ]
        }
    }
