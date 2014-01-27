from contextlib import contextmanager
from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from functools import wraps

DBSession = scoped_session(sessionmaker(expire_on_commit=False))
Base = declarative_base()


def refresh_indices():
    """Refresh all indices"""
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


@contextmanager
def session():
    session = DBSession()
    try:
        yield session
    except:
        session.rollback()
        raise
    finally:
        session.close()