from models.base import Base
from sqlalchemy import Column, String, Text, LargeBinary
class User(Base):
    __tablename__ = "users"

    id = Column(Text, primary_key=True, index=True)
    name = Column(String(100))
    email = Column(String(100), unique=True, index=True)
    password = Column(LargeBinary)
