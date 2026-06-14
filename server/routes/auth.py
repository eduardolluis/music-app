import bcrypt
import uuid
from fastapi import Depends, HTTPException, APIRouter
from sqlalchemy.orm import Session
from models.user import User
from pydantic_schemas.user_create import UserCreate
from database import get_db

router = APIRouter()

@router.post("/signup")
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    # check if the user already exists in the db
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(
            status_code=400,
            detail="User with the same email already exists!"
        )

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

    return {
        "id": user_db.id,
        "name": user_db.name,
        "email": user_db.email
    }   