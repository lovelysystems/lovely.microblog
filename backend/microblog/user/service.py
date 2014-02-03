from pyramid import security
from sqlalchemy.orm.exc import NoResultFound
from lovely.pyrest.rest import RestService, rpcmethod_route, rpcmethod_view
from lovely.pyrest.validation import validate
from hashlib import sha1

from microblog.server import AuthACLFactory
from microblog.user.model import User
from ..model import DBSession, refresher

REGISTER_SCHEMA = {'type': 'object',
                   'properties': {'name': {'type': 'string'},
                                  'password': {'type': 'string'}}}


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
    @validate(REGISTER_SCHEMA)
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
