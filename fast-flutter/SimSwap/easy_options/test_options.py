'''
Author: Naiyuan liu
Github: https://github.com/NNNNAI
Date: 2021-11-23 17:03:58
LastEditors: Naiyuan liu
LastEditTime: 2021-11-23 17:08:08
Description: 
'''
from .base_options import BaseOptions

class TestOptions(BaseOptions):
    def initialize(self):
        args = BaseOptions.initialize(self)
        args["ntest"] = float("inf")
        args["results_dir"] = './SimSwap/results/'
        args["aspect_ratio"] = 1.0
        args["phase"] = 'test'
        args["which_epoch"] = 'latest'
        args["how_many"] = 50
        args["cluster_path"] = 'features_clustered_010.npy'
        args["use_encoded_image"] = True
        args["export_onnx"] = ''
        args["engine"] = ''
        args["onnx"] = ''
        args["Arc_path"] = './SimSwap/models/BEST_checkpoint.tar'
        args["pic_a_path"] = './crop_224/gdg.jpg'
        args["pic_b_path"] = './crop_224/zrf.jpg'
        args["pic_specific_path"] = './crop_224/zrf.jpg'
        args["multisepcific_dir"] = './DATA/temp'
        args["video_path"] = './demo_file/How.mp4'
        args["temp_path"] = './SimSwap/temp_results'
        args["output_path"] = './output/'
        args["id_thres"] = 0.03
        args["no_simswaplogo"] = True
        args["use_mask"] = True
        args["crop_size"] = 224
        args["isTrain"] = False

        return args