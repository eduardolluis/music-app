import uuid
import bcrypt
from fastapi import Depends, HTTPException, APIRouter
from sqlalchemy.orm import Session
from models.user import User
from pydantic_schemas.user_create import UserCreate
from pydantic_schemas.user_login import UserLogin
from database import get_db

router = APIRouter()

@router.post("/signup", status_code= 201    )
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    # check if the user already exists in the db
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(status_code=400,detail="User with the same email already exists!")

    hashpw = bcrypt.hashpw(user.password.encode("utf-8"), bcrypt.gensalt())

    user_db = User(id=str(uuid.uuid4()),  email=user.email, name=user.username, password=hashpw)

    # add user to the db
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    #check if a user with same email exists in the db
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(status_code=400, detail="User with this email does not exist!")

    #password matching or not
    is_match = bcrypt.checkpw(user.password.encode("utf-8"), user_db.password)
    if not is_match:
        raise HTTPException(status_code=400, detail="Incorrect password!")
    
    return user_db
