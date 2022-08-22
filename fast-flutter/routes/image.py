from fastapi import APIRouter
from fastapi import UploadFile, File
from fastapi.responses import FileResponse, StreamingResponse
from config.db import conn
from typing import List
import datetime
import secrets
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATIC_DIR = os.path.join(BASE_DIR,'static/')
IMG_DIR = os.path.join(STATIC_DIR,'images/')
SERVER_IMG_DIR = os.path.join('http://localhost:8000/','static/','images/')

router = APIRouter()

@router.get('/images/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([IMG_DIR,file_name]))
    # def iterfile():  # 
    #     some_file_path = ''.join([IMG_DIR,file_name])
    #     with open(some_file_path, mode="rb") as file_like:  # 
    #         yield from file_like  # 
    # return StreamingResponse(iterfile(), media_type="video/mp4")

@router.post('/upload-images')
async def upload_board(in_files: List[UploadFile] = File(...)):
    print(in_files)
    
    file_urls=[]
    for file in in_files:
        currentTime = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        print(file.filename)
        saved_file_name = ''.join([currentTime,secrets.token_hex(16)])+'.mp4'
        print(saved_file_name)
        file_location = os.path.join(IMG_DIR,saved_file_name)
        with open(file_location, "wb+") as file_object:
            file_object.write(file.file.read())
        file_urls.append(SERVER_IMG_DIR+saved_file_name)
    result={'fileUrls' : file_urls}
    return result
    # return FileResponse(file_location)




# @image.put('/{id}')
# def update_user(id: int, user: User):
#     return conn.execute(users.update().values(name=user.name, email=user.email, password=user.password).where(users.c.id == id))

# @image.delete('/{id}')
# def delete_user(id: int):
#     return conn.execute(users.delete().where(users.c.id == id))