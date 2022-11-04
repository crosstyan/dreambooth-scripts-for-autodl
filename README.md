# AutoDL DreamBooth Config Cheat Sheet

Code is adapted from this [the colab notebook](https://colab.research.google.com/drive/1C1vVZ59S4kWfL7jIsczyLpmxbD4cOA-k). Thanks to the contribution from community.

Add alternative `train_dreambooth.py` from [this colab notebook](https://colab.research.google.com/drive/17yM4mlPVOFdJE_81oWBz5mXH9cxvhmz8#scrollTo=aLWXPZqjsZVV). use `get_alt_script.ps1` to download it.

Choose PyTorch 1.11.0 Python 3.8 (Ubuntu 20.04) as base image.

```bash
cd ~
git clone https://github.com/crosstyan/dreambooth-scripts-for-autodl dreambooth
cd dreambooth
git submodule update --init --recursive
# TODO write an init script to help configure the envrionment
# for now you have to do it manually
```

## Diffusers

### Conda Environment Configuration

using conda/mamba with Python 3.10.6. 

First of all you have to install conda and mamba. I assume you have done that.

```bash
# See https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-python.html
mamba create -n diffusers python=3.10.6
# if you have installed powershell
```

If you're NOT using my scripts you can choose to configure bash

```bash
conda init bash
conda activate diffusers
# or use your favourite text editor
# or sed, whatever
# see also https://stackoverflow.com/questions/17701989/how-do-i-append-text-to-a-file
vim ~/.bashrc
# echo "conda activate diffusers" >> ~/.bashrc
# add `conda activate diffusers` to the end of file
```

#### PowerShell

If you're using my script you have to install PowerShell.
See [Installing PowerShell on Ubuntu](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.2).

```bash
# after installing PowerShell
conda init powershell
conda activate diffusers
vim ~/.config/powershell/profile.ps1
# add `conda activate diffusers` to the end of file
```

> Why do I use PowerShell? Because I can't write correct bash scripts (Help wanted!) and too lazy to use python.

### Clone the Repo

I'm using [the diffusers fork of CCRcmcpe](https://github.com/CCRcmcpe/diffusers), which added [wandb](https://wandb.ai/site) support and a few improvements.

```bash
git clone https://github.com/CCRcmcpe/diffusers repos/diffusers
```

LLVM10 is required as well

```bash
# https://packages.ubuntu.com/focal/llvm-10-dev
apt install llvm-10-dev
```

```bash
# install these packages
# switch to TUNA PiPy mirror if you get any error
# https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
pip install -U pip
pip install wandb
pip install -U --pre triton
pip install accelerate==0.12.0 transformers ftfy bitsandbytes gradio
pip install omegaconf einops pytorch_lightning
pip install transformers
cd repos/diffusers
pip install .
```

## xformers

[xformers](https://github.com/facebookresearch/xformers) is totally OPTIONAL. You can skip this part if you feel like doing it. It just speed up the training process, which is trivial if you have a beefy machine like A5000. If you mess up anything about xformers, just uninstall it.

```
pip uninstall xformers
```

[prebuilt wheel](https://github.com/crosstyan/dreambooth-scripts-for-autodl/releases/tag/v0.0.14) build with

```txt
Cuda compilation tools, release 11.3, V11.3.109
RTX A5000
Python: 3.10.6
OS: Ubuntu 20.04.4 LTS x86_64 
Kernel: 5.4.0-100-generic 
```

```bash
wget https://github.com/crosstyan/dreambooth-scripts-for-autodl/releases/download/v0.0.14/xformers-0.0.14.dev0-cp310-cp310-linux_x86_64.whl
pip install xformers-0.0.14.dev0-cp310-cp310-linux_x86_64.whl
```

### Compile from source

Here's how you build it from source.

```bash
# https://github.com/C43H66N12O12S2/stable-diffusion-webui/releases/download/linux/xformers-0.0.14.dev0-cp310-cp310-linux_x86_64.whl
# won't work since AutoDL provided Ubuntu version is too old
# GLIBC_2.32 is required
git clone https://github.com/facebookresearch/xformers repos/xformers
cd repos/xformers
# install ninja to speedup building.
pip install ninja
# or maybe
# apt install ninja-build build-essential
pip install -r requirements.txt
# use `pip wheel .` to create a whl file
pip install .
```

~~I'm not sure if `MAKEFLAGS` is effective since it still takes a long time to~~
~~compile and still only one core be used. I mean a about an hour or less, not sure.~~

Using ninja could speed the building process up. ([source](https://github.com/facebookresearch/xformers/issues/481))

## DeepDanbooru

OPTIONAL! Useful if you want to add tags to your images.

[KichangKim/DeepDanbooru](https://github.com/KichangKim/DeepDanbooru)

```bash
pip install -r repos/DeepDanbooru/requirements.txt
pip install basicsr
pip install -U numpy # I have to do this
pip install repos/DeepDanbooru
```

## Usage

See [Usage](Usage.md)

## TODOs

- [ ] Provide a Jupyter interface directly
- [ ] Intergrate AUTOMATIC WebUI (I'm afraid there's no enough space)

## Troubleshooting

Error in `File "/root/miniconda3/envs/diffusers/lib/python3.10/site-packages/bitsandbytes/cuda_setup/paths.py", line 90` that `CUDASetup.get_instance` is a function. 

Somehow the `get_instance` function is not called. Add `()` to fix it.
Is the TUNA still caching the old version? [This kind of bug should be fixed already](https://github.com/TimDettmers/bitsandbytes/blob/29e239e4d12b1c5b8ada4f03b90930735ddcb5b9/bitsandbytes/cuda_setup/paths.py#L90). ([commit](https://github.com/TimDettmers/bitsandbytes/commit/c584482f1f13e073dac714815f2d439fd66699d1))
