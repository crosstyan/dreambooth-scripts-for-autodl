from pathlib import Path
import glob
import os
import pandas as pd
from pprint import pprint

# base_dir = "C:/Users/cross/Desktop/Grabber"
# base_dir = "C:\\Users\\cross\\Desktop\\Shion"
base_dir = "C:\\Users\\cross\\Desktop\\gyokai"
txts = os.path.join(base_dir, "*.txt")
texts = glob.glob(txts)

delete_suffix = [".jpg", ".png", ".gif", ".jpeg", ".bmp", ".webp"]


# a list of Path
def rename_filename(files: list[str]):
    for file in files:
        p = Path(file)
        s = p.stem
        for suffix in delete_suffix:
            s = s.replace(suffix, "")
        p.rename(p.with_name(s).with_suffix(p.suffix))

def correct_artists_name(txt: str) -> str:
  strange_artists = {
    "aaaa+aaaa (quad-a)": "aaaa",
    "hagi (ame hagi)": "hagi",
    "muk (monsieur)": "muk",
    "asou (asabu202)": "asou",
    "chou (meteorite3)": "chou",
    "shion (mirudakemann)": "shion",
  }
  # I assume you only get one artist
  for k, v in strange_artists.items():
    if k in txt:
      replaced = txt.replace(k, v)
      if replaced is not None:
        return replaced
  # can't find any strange artist
  return txt

# rename_filename(texts)
def read_authors(files: list[str]) -> dict[str, int]:
    result = {}
    for file in files:
        with open(file, "r") as f:
            l = f.readline()
            by = l.split("by")[-1]
            by = by.strip()
            result[by] = result.get(by, 0) + 1
    return result

def print_ranking(authors: dict[str, int]):
  df = pd.DataFrame(authors.items(), columns=["Author", "Count"])
  # filter out the author with less than 10 images
  d = df[df["Count"] > 5].sort_values("Count", ascending=False)
  print(d)

def do_correct(files: list[str]):
  for file in files:
    old = ""
    l = ""
    with open(file, "r") as f:
      old = f.readline()
    with open(file, "w") as f:
      l = correct_artists_name(old)
      f.write(l)


rename_filename(texts)
# do_correct(texts)
# authors = read_authors(texts)
# print_ranking(authors)
