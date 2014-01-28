from lovely.pyrest.rest import RestService, rpcmethod_route
from microblog.blogpost.model import BlogPost
from datetime import datetime
from ..model import session


@RestService('blogpost')
class BlogPostService(object):

    def __init__(self, request):
        self.request = request

    @rpcmethod_route()
    def list(self):
        """ Return all blogposts
        """
        with session() as sess:
            query = sess.query(BlogPost).order_by(BlogPost.created.desc())
            blogposts = query.all()
        result = []
        for post in blogposts:
            result.append({'id': post.id,
                           'created': post.created.isoformat(),
                           'text': post.text,
                           'creator': post.creator})
        return {"data": {"blogposts": result}}

    @rpcmethod_route(request_method="POST")
    def create(self, content):
        """ Create a blogpost with the given content
        """
        blogpost = BlogPost()
        blogpost.text = content
        blogpost.created = datetime.now()
        blogpost.creator = 'anonym'
        with session() as sess:
            sess.add(blogpost)
            sess.commit()
        return {"id": blogpost.id}


def includeme(config):
    config.add_route('blogpost', '/blogpost', static=True)
