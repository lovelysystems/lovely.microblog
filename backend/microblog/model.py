from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from zope.sqlalchemy import ZopeTransactionExtension
from functools import wraps
import uuid

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))
Base = declarative_base()


def genuuid():
    return str(uuid.uuid4())


def refresh_indices():
    """Refresh all indices"""
    DBSession.flush()
    cf = Base.metadata.bind.raw_connection()
    http_client = cf.connection.client
    return http_client._request('POST', '/_refresh')


def refresher(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        result = f(*args, **kwargs)
        refresh_indices()
        return result
    return wrapper
