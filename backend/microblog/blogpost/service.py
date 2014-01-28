from lovely.pyrest.rest import RestService, rpcmethod_route
from microblog.blogpost.model import BlogPost
from datetime import datetime
from ..model import DBSession, refresher


@RestService('blogposts')
class BlogPostService(object):

    def __init__(self, request):
        self.request = request

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


def includeme(config):
    # Add the blogposts route
    config.add_route('blogposts', '/blogposts', static=True)
