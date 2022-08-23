from fastapi import APIRouter
from fastapi import UploadFile, File
from fastapi.responses import FileResponse, StreamingResponse
from SimSwap.test import test

# from config.db import conn
from typing import List
import datetime
import secrets
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATIC_DIR = os.path.join(BASE_DIR,'static/')
VIDEO_DIR = os.path.join(STATIC_DIR,'videos/')
SERVER_VIDEO_DIR = os.path.join('http://localhost:8000/','static/','videos/')
IMG_DIR = os.path.join(STATIC_DIR,'images/')
SERVER_IMG_DIR = os.path.join('http://localhost:8000/','static/','images/')

SRC_VIDEO_PATH = ''
SRC_IMG_PATH = ''


router = APIRouter()


@router.get('/videos/{file_name}')
def get_video(file_name:str):
    return FileResponse(''.join([VIDEO_DIR,file_name]))


@router.post('/upload-videos')
async def upload_board(in_files: List[UploadFile] = File(...)):
    global SRC_VIDEO_PATH, SRC_IMG_PATH
    print(in_files)
    file_urls=[]
    for file in in_files:
        # currentTime = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        saved_file_name = file.filename
        print(saved_file_name)
        file_location = os.path.join(VIDEO_DIR, saved_file_name)
        print('video', file_location)
        SRC_VIDEO_PATH = file_location
        with open(file_location, "wb+") as file_object:
            file_object.write(file.file.read())
        file_urls.append(SERVER_VIDEO_DIR + saved_file_name)
    result={'fileUrls' : file_urls}
    return result


@router.get('/images/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([IMG_DIR,file_name]))

@router.post('/swapping')
async def swapping(in_files: List[UploadFile] = File(...)): 
    global SRC_VIDEO_PATH, SRC_IMG_PATH
    print(in_files)
    file_urls=[]
    for file in in_files:
        # currentTime = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        saved_file_name = file.filename
        print(saved_file_name)
        temp = file.filename.split('.')
        output_file_name = temp[0] + '_output.' + temp[1]
        file_location = os.path.join(IMG_DIR, saved_file_name)
        output_location = os.path.join(IMG_DIR, output_file_name)
        SRC_IMG_PATH = file_location
        with open(file_location, "wb+") as file_object:
            file_object.write(file.file.read())
        file_urls.append(SERVER_VIDEO_DIR + output_file_name)
    
    # Swapping!!

    print('Video', SRC_VIDEO_PATH)
    print('Img', SRC_IMG_PATH)
    print('Output', output_location)
    

    test(SRC_VIDEO_PATH, SRC_IMG_PATH, output_location)

    result={'fileUrls' : file_urls}
    return result
