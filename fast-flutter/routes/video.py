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
VIDEO_DIR = os.path.join(STATIC_DIR,'videos/')
SERVER_IMG_DIR = os.path.join('http://localhost:8000/','static/','videos/')

router = APIRouter()

@router.get('/videos/{file_name}')
def get_video(file_name:str):
    return FileResponse(''.join([VIDEO_DIR,file_name]))


@router.post('/upload-videos')
async def upload_board(in_files: List[UploadFile] = File(...)):
    print(in_files)
    file_urls=[]
    for file in in_files:
        # currentTime = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        saved_file_name = file.filename
        print(saved_file_name)
        file_location = os.path.join(VIDEO_DIR, saved_file_name)
        with open(file_location, "wb+") as file_object:
            file_object.write(file.file.read())
        file_urls.append(SERVER_IMG_DIR + saved_file_name)
    result={'fileUrls' : file_urls}
    return result




# @image.put('/{id}')
# def update_user(id: int, user: User):
#     return conn.execute(users.update().values(name=user.name, email=user.email, password=user.password).where(users.c.id == id))

# @image.delete('/{id}')
# def delete_user(id: int):
#     return conn.execute(users.delete().where(users.c.id == id))