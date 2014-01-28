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
