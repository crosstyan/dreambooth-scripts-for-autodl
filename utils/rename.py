# rename to md5
import os 
import glob
import shutil
from pathlib import Path
import hashlib


p = "C:\\Users\\cross\\Desktop\\dataset\\mt\\akima_sketch"
picture_suffix = ("jpg", "png", "gif", "jpeg", "bmp", "webp")
txt_suffix = "txt"

files_grabbed = glob.glob(os.path.join(p, "*"), recursive=True)
print("found {} files".format(len(files_grabbed)))
files_with_ext = [ f for f in files_grabbed if f.endswith(picture_suffix) ]
print("found {} files with picture extensions".format(len(files_with_ext)))
file_with_txt = [ f for f in files_grabbed if f.endswith(txt_suffix) ]

for f in files_with_ext:
    p = Path(f)
    h = None
    old_name = p.stem
    with open(f, "rb") as f:
        h = hashlib.md5(f.read()).hexdigest()
    if h is not None:
      p.rename(p.with_name(h).with_suffix(p.suffix))
      for txt in file_with_txt:
          t = Path(txt)
          if t.stem == old_name:
              t.rename(t.with_name(h).with_suffix(t.suffix))
              break
