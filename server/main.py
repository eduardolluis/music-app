from fastapi import FastAPI, Depends
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, String, Text, LargeBinary
from sqlalchemy.orm import sessionmaker, declarative_base, Session
import uuid
import bcrypt

app = FastAPI()

DATABASE_URL = "postgresql://postgres@localhost:5432/fluttermusicapp"

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()


class UserCreate(BaseModel):
    username: str
    email: str
    password: str


class User(Base):
    __tablename__ = "users"

    id = Column(Text, primary_key=True, index=True)
    name = Column(String(100))
    email = Column(String(100), unique=True, index=True)
    password = Column(LargeBinary)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post("/signup")
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    # check if the user already exists in the db
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(status_code=400, detail="User with the same email already exists!")
        return {"message": "User with the same email already exists!"}

    hashed_password = bcrypt.hashpw(
        user.password.encode("utf-8"),
        bcrypt.gensalt()
    )

    user_db = User(
        id=str(uuid.uuid4()),
        email=user.email,
        name=user.username,
        password=hashed_password
    )

    # add user to the db
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db


Base.metadata.create_all(bind=engine)