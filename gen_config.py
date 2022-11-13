from pprint import pprint
from yaml import load, dump
from pathlib import Path
import glob
import os
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper


base_config = None
with open("base_config.yaml", "r") as f:
    base_config = load(f, Loader=Loader)

# list all the directory but not the files
dirs = [x for x in glob.glob("*") if os.path.isdir(x)]

concepts = []

# - instance_set:
#     path: 'example/data/instance'
#     prompt: 'sks 1girl'
#     combine_prompt_from_txt: false
#     prompt_combine_template: '{PROMPT}, {TXT_PROMPT}'
#   class_set:
#     path: 'example/data/class'
#     prompt: '1girl'
#     combine_prompt_from_txt: false
#     prompt_combine_template: '{PROMPT}, {TXT_PROMPT}'
#     auto_generate:
#       enabled: true
#       negative_prompt: 'lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry'
#       steps: 28
#       cfg_scale: 11
#       num_target: 100
#       batch_size: 1
def get_concept(path: str):
  # don't care about class set since I don't use DreamBooth
  abs_path = Path(path).absolute()
  concept = {
      "instance_set": {
          "path": str(abs_path),
          # don't have any additional prompt here. All we need is the txt
          "prompt": "", 
          "combine_prompt_from_txt": True,
          "prompt_combine_template": "{TXT_PROMPT}",
      },
      "class_set": {
        "path": "",
        "prompt": "",
        "combine_prompt_from_txt": False,
        "auto_generate": {
          "enabled": False,
        }
      }
  }
  return concept

# I expect concept to be a list of concept
concepts = map(get_concept, dirs)

base_config["data"]["concepts"] = list(concepts) 
dump(base_config, open("config.yaml", "w"), Dumper=Dumper)
