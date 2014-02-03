from sqlalchemy import Column, String
from microblog.model import Base, genuuid


class User(Base):

    __tablename__ = 'users'

    id = Column(String, default=genuuid, primary_key=True)
    name = Column('name', String, nullable=False)
    password = Column('password', String, nullable=False)
