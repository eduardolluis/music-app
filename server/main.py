from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI();

class Test(BaseModel):
    name: str
    age: int

@app.post('/')
async def test(t: Test):
    print(t.name)
    return 'hello'