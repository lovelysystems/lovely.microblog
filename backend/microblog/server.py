from pyramid.config import Configurator
from pyramid.settings import aslist, asbool

from sqlalchemy import create_engine


from .model import DBSession, Base


def app_factory(global_config, **settings):
    """Setup the main application for paste

    This must be setup as the paste.app_factory in the egg entry-points.
    """
    config = Configurator(settings=settings, autocommit=True)
    crate_init(config)

    return config.make_wsgi_app()



def crate_init(config):
    settings = config.get_settings()
    engine = create_engine(
        'crate://',
        connect_args={
            'servers': aslist(settings['crate.hosts'])
        },
        echo=asbool(settings.get('crate.echo', 'False')),
        pool_size=int(settings.get('sql.pool_size', 5)),
        max_overflow=int(settings.get('sql.max_overflow', 5))
    )
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
