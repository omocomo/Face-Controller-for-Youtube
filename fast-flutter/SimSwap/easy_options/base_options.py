import easydict
import os
from util import util
import torch

class BaseOptions():
    # def __init__(self):
        # self.parser = argparse.ArgumentParser()
        # self.initialized = False

    def initialize(self):
        # experiment specifics
        args = easydict.EasyDict({
            # experiment specifics
            "name": 'people',
            "gpu_ids": '0',
            "checkpoints_dir": './SimSwap/checkpoints',
            "model": 'pix2pixHD',
            "norm": 'batch',
            "use_dropout": True,
            "data_type": 32,
            "verbose": False,
            "fp16": False,
            "local_rank": 0,
            "isTrain": True,
            # input/output sizes 
            "batchSize": 8,
            "loadSize": 1024,
            "fineSize": 512,
            "label_nc": 0,
            "input_nc": 3,
            "output_nc": 3,
            # for setting inputs
            "dataroot": './SimSwap/datasets/cityscapes/',
            "resize_or_crop": 'scale_width',
            "serial_batches": True,
            "no_flip": True,
            "nThreads": 2,
            "max_dataset_size": float("inf"),
            # for displays
            "display_winsize": 512,
            "tf_log": True,
            # for generator 
            "netG": 'global',
            "latent_size": 512,
            "ngf": 64,
            "n_downsample_global": 3,
            "n_blocks_global": 6,
            "n_blocks_local": 3,
            "n_local_enhancers": 1,
            "niter_fix_global": 0,
            # for instance-wise features
            "no_instance": True,
            "instance_feat": True,
            "label_feat": True,
            "feat_num": 3,
            "load_features": True,
            "n_downsample_E": 4,
            "nef": 16,
            "n_clusters": 10,
            "image_size": 224,
            "norm_G": 'spectralspadesyncbatch3x3',
            "semantic_nc": 3
        })

        return args

    def parse(self, save=True):
        # if not self.initialized:
        #     self.initialize()
        # self.opt = self.parser.parse_args()
        # self.opt.isTrain = self.isTrain   # train or test

        # str_ids = self.opt.gpu_ids.split(',')
        # self.opt.gpu_ids = []
        # for str_id in str_ids:
        #     id = int(str_id)
        #     if id >= 0:
        #         self.opt.gpu_ids.append(id)
        
        # # set gpu ids
        # if len(self.opt.gpu_ids) > 0:
        #     torch.cuda.set_device(self.opt.gpu_ids[0])

        # args = vars(self.opt)

        print('------------ Options -------------')
        for k, v in sorted(args.items()):
            print('%s: %s' % (str(k), str(v)))
        print('-------------- End ----------------')

        # save to the disk
        # if self.opt.isTrain:
        #     expr_dir = os.path.join(self.opt.checkpoints_dir, self.opt.name)
        #     util.mkdirs(expr_dir)
        #     if save and not self.opt.continue_train:
        #         file_name = os.path.join(expr_dir, 'opt.txt')
        #         with open(file_name, 'wt') as opt_file:
        #             opt_file.write('------------ Options -------------\n')
        #             for k, v in sorted(args.items()):
        #                 opt_file.write('%s: %s\n' % (str(k), str(v)))
        #             opt_file.write('-------------- End ----------------\n')
        return args
