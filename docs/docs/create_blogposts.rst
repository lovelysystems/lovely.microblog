================
Create Blogposts
================

As a next step we want to create and list blogposts.

Table blogpost
==============

We want the `blogpost` table to have these columns::

    - id: primary key
    - text: content of the post
    - created: current timestamp, so we can order the posts chronological
    - creator: name of the creator

Open the file `<project-dir>/etc/crate_setup.sql` and add the following sql
statement::

    create table blogpost (
        id string primary key,
        created timestamp,
        text string,
        creator string
    );

Add the following line to the `create_cleanup.sql` file::

    drop table blogpost

Ensure that crate is started::

    bin/supervisorctl start "crate:*"

Run::

    $sh bin/crate_setup
    +-----------------------+-----------+-----------+---------+
    | server_url            | node_name | connected | message |
    +-----------------------+-----------+-----------+---------+
    | http://127.0.0.1:4200 | Scorpio   | TRUE      | OK      |
    +-----------------------+-----------+-----------+---------+
    CONNECT OK
    CREATE OK (0.083 sec)

If you want to reset crate run::

    $sh bin/crate_cleanup
    +-----------------------+-----------+-----------+---------+
    | server_url            | node_name | connected | message |
    +-----------------------+-----------+-----------+---------+
    | http://127.0.0.1:4200 | Scorpio   | TRUE      | OK      |
    +-----------------------+-----------+-----------+---------+
    CONNECT OK
    DROP OK (0.014 sec)

    $sh bin/crate_setup
    +-----------------------+-----------+-----------+---------+
    | server_url            | node_name | connected | message |
    +-----------------------+-----------+-----------+---------+
    | http://127.0.0.1:4200 | Scorpio   | TRUE      | OK      |
    +-----------------------+-----------+-----------+---------+
    CONNECT OK
    CREATE OK (0.083 sec)

You can open the following url with your browser to
access the crate admin interface and inspect the created table::

    $sh open http://localhost:4200/admin

BlogPost SQL Alchemy Model
==========================

`SQLAlchemy <http://www.sqlalchemy.org>`_ is a python SQL toolkit and Object Relational
Mapper.
Let's create a `BlogPost` model which is the python representation of the already
created `blogpost` table.
Add a new file named `model.py` into the `blogpost` module with the following
contents::

    from sqlalchemy import Column, String, DateTime
    from microblog.model import Base
    import uuid
    
    
    def genuuid():
        return str(uuid.uuid4())
    
    
    class BlogPost(Base):
    
        __tablename__ = 'blogpost'
    
        id = Column(String, default=genuuid, primary_key=True)
        text = Column('text', String, nullable=False)
        creator = Column('creator', String, nullable=False)
        created = Column('created', DateTime, nullable=False)

The `BlogPost` class must inherit `Base` which is declared in `microblog.model`.
For details see
`Declare a Mapping <http://docs.sqlalchemy.org/en/rel_0_9/orm/tutorial.html#declare-a-mapping>`_

Read Blogposts
==============

Modify the `list` method of the service, so it returns all the blogpost entries::

    @rpcmethod_route(request_method="GET")
    def list(self):
        """ Return all blogposts
        """
        query = DBSession.query(BlogPost).order_by(BlogPost.created.desc())
        blogposts = query.all()
        result = []
        for post in blogposts:
            result.append({'id': post.id,
                           'created': post.created.isoformat(),
                           'text': post.text,
                           'creator': post.creator})
        return {"data": {"blogposts": result}}

You have to add the following imports::

    from microblog.model import DBSession
    from microblog.blogpost.model import BlogPost

Query
-----

With the first statement we build the query to fetch all `blogpost` entries ordered by creation date.
`query.all()` returns the query result as list.

Result
------

After querying the blog posts we build a result list, which contains all the
data of the fetched blog posts.

Run the application
-------------------

Restart the app and send a request to the `blogpost` service again::

    $sh curl http://localhost:9210/blogposts
    {"data": {"blogposts": []}}

Create BlogPosts
================

For creating a blog post add a `create` method to the `BlogPost` service::

    @rpcmethod_route(request_method="POST")
    @refresher
    def create(self, text):
        """ Create a blogpost with the given text
        """
        blogpost = BlogPost()
        blogpost.text = text
        blogpost.created = datetime.now()
        blogpost.creator = 'anonym'
        DBSession.add(blogpost)
        DBSession.flush()
        return {"id": blogpost.id}

And add those imports::

    from datetime import datetime
    from microblog.model import DBSession, refresher

Decorators
----------

The create method has two decorators. As in the list method the
`rpcmethod_route` decorator declares that the create method will be used
if a POST request is performed on the service.

If a new model is created and a query is performed immediately
afterwards, the new model will not appear in the query result. This is
because crate stores the model in an internal transaction buffer which
is not used for queries. The `refresher` decorator declares that crate
will be refreshed after executing the method. So all operations
since the last refresh get performed and the model will appear in the
query results.

.. note::

   Crate automatically refreshes all indices periodically, but if you modify
   or create any data we recommend to add the `refresher` decorator.
   Else you may get outdated data if you query the modified data before the next
   refresh is scheduled.
   If you want to query the created data within the same method you can
   refresh crate with the `refresh_indices` function, declared in `microblog.model`

Method Header
-------------

The method takes a `text` parameter. If you perform a request you have multiple
ways to pass this parameter.

Form-Data::

   curl -XPOST localhost:9210/blogposts -d "text=Hello Form data" 

GET-Parameter::

   curl -XPOST localhost:9210/blogposts?text="Hello GET Parameter"

JSON-Body:: 

    curl -XPOST localhost:9210/blogposts -d '{"text":"Hello Json"}' -H "Content-Type: application/json"

Method Body
-----------

In the method body we create a new `BlogPost`. Then we assign the passed text
and set datetime.now as the `created` value.
Because we don't have any user handling yet, we temporary use `anonym` as
creator name.

If a new model instance, like the `Blogpost`, is created it is not automatically
assigned to the database.
This must be done using the DBSession.add method::

    DBSession.add(blogpost)

After this the `Blogpost` object is not stored in the database, but is recognized by
SQLAlchemy as an object which needs to be stored.

To store the model a flush operation must be performed on the DBSession.
A flush will perform all pending database operations, with the result that the
objects are written to the database::

    DBSession.flush()

Usually there is no need to do this manually because SQLAlchemy and the
transaction manager keeps track of this.
However, the id of a model is only created when the model is written to the
database. We perform the flush manually in order to be able to return the
id of the created model.

Test the application
====================

Finally, you have a working API where you can add and read blog posts::

    $sh curl -XPOST localhost:9210/blogposts -d '{"text":"This is my First Blogpost"}' -H "Content-Type: application/json"
    {"id": "..."}

    $sh curl localhost:9210/blogposts
    {
        "data": {
            "blogposts": [
                {
                    "created": "...",
                    "creator": "anonym",
                    "id": "...",
                    "text": "This is my First Blogpost"
                }
            ]
        }
    }
