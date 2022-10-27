# AutoDL DreamBooth Config Cheat Sheet

Code is adapted from this [the colab notebookA](https://colab.research.google.com/drive/1C1vVZ59S4kWfL7jIsczyLpmxbD4cOA-k). Thanks to the contribution from community.

## Diffusers

using conda/mamba with Python 3.10.6. 

First of all you have to install conda and mamba. I assume you have done that.

```bash
# See https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-python.html
mamba create -n diffusers python=3.10.6
```

I'm using [the diffusers fork of CCRcmcpe](https://github.com/CCRcmcpe/diffusers), which added [wandb](https://wandb.ai/site) support and a few improvements.

```bash
git clone https://github.com/CCRcmcpe/diffusers repos/diffusers
```

You repos folder should look like this:

```txt
./repos/
`-- diffusers
```

```bash
# install these packages
# switch to TUNA PiPy mirror if you get any problems
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

```bash
# https://github.com/C43H66N12O12S2/stable-diffusion-webui/releases/download/linux/xformers-0.0.14.dev0-cp310-cp310-linux_x86_64.whl
# won't work since AutoDL provided Ubuntu version is too old
# GLIBC_2.32 is required
# Maybe I could share a wheel file with you
git clone https://github.com/facebookresearch/xformers repos/xformers
cd repos/xformers
pip install -r requirements.txt
# I got a machine with 14 cores
# Is `MAKEFLAGS` really effective?
export MAKEFLAGS="-j14"
pip install -e .
```

```powershell
$env:MAKEFLAGS="-j14"
```

I'm not sure if `MAKEFLAGS` is effective since it still takes a long time to
compile. I mean a about an hour or less, not sure.

## PowerShell

See [Installing PowerShell on Ubuntu](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.2).

Why do I use PowerShell? Because I can't write correct bash scripts (Help wanted!) and too lazy to use python.

## Usage

check the source code.

## Troubleshooting

Error in `File "/root/miniconda3/envs/diffusers/lib/python3.10/site-packages/bitsandbytes/cuda_setup/paths.py", line 90` that `CUDASetup.get_instance` is a function. blah blah blah.

Somehow the `get_instance` function is not called. Add `()` to fix it.
Is the TUNA still caching the old version? This kind of bug should be fixed already.
