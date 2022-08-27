import cv2
import torch
import sys
import os
sys.path.append(os.path.abspath(os.path.dirname(__file__)))
import fractions
import numpy as np
from PIL import Image
import torch.nn.functional as F
from torchvision import transforms
from models.models import create_model
from easy_options.test_options import TestOptions
from insightface_func.face_detect_crop_multi import Face_detect_crop
from util.videoswap import video_swap
from util.add_watermark import watermark_image

transformer = transforms.Compose([
        transforms.ToTensor(),
        #transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

transformer_Arcface = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

detransformer = transforms.Compose([
        transforms.Normalize([0, 0, 0], [1/0.229, 1/0.224, 1/0.225]),
        transforms.Normalize([-0.485, -0.456, -0.406], [1, 1, 1])
    ])


def swap_multi(src_video_path, src_image_path, dst_video_path):
    args = TestOptions().initialize()
    # print(list(args))
    # args = opt.initialize()
    # opt.parser.add_argument('-f')
    # opt = opt.parse()
    args.pic_a_path = src_image_path
    args.video_path = src_video_path
    args.output_path = dst_video_path
    args.temp_path = './SimSwap/tmp'
    args.Arc_path = './SimSwap/arcface_model/arcface_checkpoint.tar'
    args.isTrain = False
    args.use_mask = True    ## new feature up-to-date

    crop_size = args.crop_size

    torch.nn.Module.dump_patches = True
    model = create_model(args)
    model.eval()

    # 
    app = Face_detect_crop(name='antelope', root='./SimSwap/insightface_func/models')
    app.prepare(ctx_id= 0, det_thresh=0.6, det_size=(640,640))

    with torch.no_grad():
        # 이미지
        pic_a = args.pic_a_path
        # img_a = Image.open(pic_a).convert('RGB')
        img_a_whole = cv2.imread(pic_a)
        img_a_whole = cv2.resize(img_a_whole, dsize=(224, 224))
        # img_a_align_crop, _ = app.get(img_a_whole,crop_size)
        # img_a_align_crop_pil = Image.fromarray(cv2.cvtColor(img_a_align_crop[0],cv2.COLOR_BGR2RGB)) 
        # cv2.imwrite('C:/Users/omocomo/Desktop/temp.png', img_a_align_crop_pil)
        img_a = transformer_Arcface(img_a_whole)
        img_id = img_a.view(-1, img_a.shape[0], img_a.shape[1], img_a.shape[2])

        # convert numpy to tensor
        img_id = img_id.cuda()

        #create latent id
        img_id_downsample = F.interpolate(img_id, size=(112,112))
        latend_id = model.netArc(img_id_downsample)
        latend_id = latend_id.detach().to('cpu')
        latend_id = latend_id/np.linalg.norm(latend_id,axis=1,keepdims=True)
        latend_id = latend_id.to('cuda')

        video_swap(args.video_path, latend_id, model, app, args.output_path, temp_results_dir=args.temp_path, use_mask=args.use_mask)


if __name__ == '__main__':
    src_video_path = 'C:/Users/omocomo/Desktop/origin.mp4'
    src_image_path = 'C:/Users/omocomo/Desktop/suzi.png'
    dst_video_path = './SimSwap/output/output.mp4'
    swap_multi(src_video_path, src_image_path, dst_video_path)