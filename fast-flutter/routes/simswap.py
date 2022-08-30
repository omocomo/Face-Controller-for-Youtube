from fastapi import APIRouter
from fastapi import UploadFile, File
from fastapi.responses import FileResponse
from SimSwap.use_test_video_swap_multi import swap_multi
from SimSwap.use_test_video_mosaic import mosaic
from SimSwap.use_test_video_swap_multispecific import multispecific
from shutil import copyfile

# from config.db import conn
from typing import List
import datetime
import secrets
import os
from glob import glob

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR,'DATA/')

VIDEO_DIR = os.path.join(DATA_DIR,'videos/')
SERVER_VIDEO_DIR = os.path.join('http://localhost:8000/','DATA/','videos/')
IMG_DIR = os.path.join(DATA_DIR,'images/')
SERVER_IMG_DIR = os.path.join('http://localhost:8000/','DATA/','images/')
OUTPUT_DIR = os.path.join(DATA_DIR,'outputs/')
SERVER_OUTPUT_DIR = os.path.join('http://localhost:8000/','DATA/','outputs/')
GIVEN_IMG_DIR = os.path.join(DATA_DIR,'given/')
SERVER_GIVEN_IMG_DIR = os.path.join('http://localhost:8000/','DATA/','given/')
TEMP_DIR = os.path.join(DATA_DIR,'temp/')
# SERVER_TEMP_DIR = os.path.join('http://localhost:8000/','DATA/','temp/')

# 전역변수
SRC_VIDEO_PATH = ''
SRC_IMG_PATH = ''
OUTPUT_VIDEO_NAME = ''
OUTPUT_VIDEO_PATH = ''


# VIDEO_DIR = os.path.join(STATIC_DIR,'videos/')
# SERVER_VIDEO_DIR = os.path.join('http://localhost:8000/','static/','videos/')
# IMG_DIR = os.path.join(STATIC_DIR,'images/')
# SERVER_IMG_DIR = os.path.join('http://localhost:8000/','static/','images/')

# SRC_VIDEO_PATH = ''
# SRC_IMG_PATH = ''
# OUTPUT_VIDEO_PATH = ''
# output_file_name = ''


router = APIRouter()

@router.get('/DATA/videos/{file_name}')
def get_video(file_name:str):
    return FileResponse(''.join([VIDEO_DIR, file_name]))

@router.post('/upload_video')
async def upload_video(in_files: List[UploadFile] = File(...)):
    global SRC_VIDEO_PATH, OUTPUT_VIDEO_PATH, OUTPUT_VIDEO_NAME
    video = in_files[0]
    saved_file_name = video.filename
    OUTPUT_VIDEO_NAME = video.filename
    SRC_VIDEO_PATH = os.path.join(VIDEO_DIR, saved_file_name)
    OUTPUT_VIDEO_PATH = os.path.join(OUTPUT_DIR, saved_file_name)
    with open(SRC_VIDEO_PATH, "wb+") as file_object:
        file_object.write(video.file.read())
    video_url = SERVER_VIDEO_DIR + saved_file_name
    result = {'videoUrl' : video_url}
    return result


@router.get('/DATA/images/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([IMG_DIR, file_name]))

@router.post('/upload_image')
async def upload_image(in_files: List[UploadFile] = File(...)): 
    global SRC_IMG_PATH
    image = in_files[0]
    saved_file_name = image.filename
    SRC_IMG_PATH = os.path.join(IMG_DIR, saved_file_name)
    with open(SRC_IMG_PATH, "wb+") as file_object:
        file_object.write(image.file.read())
    img_url = SERVER_IMG_DIR + saved_file_name
    result = {'imgUrl' : img_url}
    return result

@router.get('/DATA/given/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([GIVEN_IMG_DIR, file_name]))

@router.get('/given_image')
def given_image():
    given_img_list = glob(GIVEN_IMG_DIR+'*.png')
    given_img_list += glob(GIVEN_IMG_DIR+'*.jpg')
    given_img_list += glob(GIVEN_IMG_DIR+'*.jpeg')
    # 서버 경로로 변경
    given_img_list = [img_path.split('\\')[-1] for img_path in given_img_list]
    result = {'imgList' : given_img_list}
    return result

@router.post('/select_given_image/{select_given_image}')
def given_image(select_given_image:str):
    global SRC_IMG_PATH
    # saved_file_name = image.filename
    SRC_IMG_PATH = os.path.join(GIVEN_IMG_DIR, select_given_image)
    print(select_given_image)
    print(SRC_IMG_PATH)
    return 

@router.get('/DATA/outputs/{file_name}')
def get_image(file_name:str):
    return FileResponse(''.join([OUTPUT_DIR, file_name]))

@router.post('/multi_swapping')
async def swapping(): 
    # global SRC_VIDEO_PATH, SRC_IMG_PATH, OUTPUT_VIDEO_PATH, OUTPUT_VIDEO_NAME
   
    print('Video', SRC_VIDEO_PATH)
    print('Img', SRC_IMG_PATH)
    print('Output', OUTPUT_VIDEO_PATH)
    
    swap_multi(SRC_VIDEO_PATH, SRC_IMG_PATH, OUTPUT_VIDEO_PATH)

    output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputUrl' : output_url}
    return result

def delete_all_files(filePath):
    if os.path.exists(filePath):
        for file in os.scandir(filePath):
            os.remove(file.path)
        return 'Remove All File'
    else:
        return 'Directory Not Found'

@router.post('/upload_images')
async def upload_images(in_files: List[UploadFile] = File(...)):
    print(delete_all_files(TEMP_DIR))
    print(in_files)
    for i, file in enumerate(in_files):
        files = file.file.read()
        saved_file_name = file.filename 
        file_location1 = os.path.join(IMG_DIR, saved_file_name)
        with open(file_location1, "wb+") as file_object:
            file_object.write(files)
        saved_src_file_name = 'SRC_' + str(i+1).zfill(2) + '.jpg'
        file_location2 = os.path.join(TEMP_DIR, saved_src_file_name)
        with open(file_location2, "wb+") as file_object:
            file_object.write(files)
        saved_dst_file_name = 'DST_' + str(i+1).zfill(2) + '.jpg'
        file_location3 = os.path.join(TEMP_DIR, saved_dst_file_name)
        with open(file_location3, "wb+") as file_object:
            file_object.write(files)
    return 

@router.post('/get_mosaic')
async def get_mosaic(): 
    mosaic(SRC_VIDEO_PATH)
    output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputUrl' : output_url}
    return result


@router.post('/get_specific_swapping')
async def get_specific_swapping(src_images: List[str], dst_images: List[str]): 
    print(delete_all_files(TEMP_DIR))

    for i, (src_name, dst_name) in enumerate(zip(src_images, dst_images)):
        # SRC 이미지 저장
        src_path = os.path.join(IMG_DIR, src_name)
        dst_path = os.path.join(TEMP_DIR, 'SRC_' + str(i+1).zfill(2) + '.jpg')
        copyfile(src_path, dst_path)

        # DST 이미지 저장
        src_path = os.path.join(GIVEN_IMG_DIR, dst_name)
        dst_path = os.path.join(TEMP_DIR, 'DST_' + str(i+1).zfill(2) + '.jpg')
        copyfile(src_path, dst_path)

    multispecific(SRC_VIDEO_PATH, OUTPUT_VIDEO_PATH)

    output_url = SERVER_OUTPUT_DIR + OUTPUT_VIDEO_NAME
    result = {'outputUrl' : output_url}
    return result