# AutoDL DreamBooth Config Cheat Sheet

Code is adapted from this [the colab notebook](https://colab.research.google.com/drive/1C1vVZ59S4kWfL7jIsczyLpmxbD4cOA-k). Thanks to the contribution from community.

```bash
git submodule update --init --recursive
```

## Diffusers

using conda/mamba with Python 3.10.6. 

First of all you have to install conda and mamba. I assume you have done that.

```bash
# See https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-python.html
mamba create -n diffusers python=3.10.6
conda init bash
# if you have installed powershell
conda init powershell
conda activate diffusers
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

LLVM10 is required as well

```bash
# https://packages.ubuntu.com/focal/llvm-10-dev
apt install llvm-10-dev
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

[prebuilt wheel](https://github.com/crosstyan/dreambooth-scripts-for-autodl/releases/tag/v0.0.14) build with

```txt
Cuda compilation tools, release 11.3, V11.3.109
RTX A5000
Python: 3.10.6
OS: Ubuntu 20.04.4 LTS x86_64 
Kernel: 5.4.0-100-generic 
```

```bash
# https://github.com/C43H66N12O12S2/stable-diffusion-webui/releases/download/linux/xformers-0.0.14.dev0-cp310-cp310-linux_x86_64.whl
# won't work since AutoDL provided Ubuntu version is too old
# GLIBC_2.32 is required
git clone https://github.com/facebookresearch/xformers repos/xformers
cd repos/xformers
pip install -r requirements.txt
# I got a machine with 14 cores
# Is `MAKEFLAGS` really effective?
export MAKEFLAGS="-j14"
# use `pip wheel .` to create a whl file
pip install .
```

```powershell
$env:MAKEFLAGS="-j14"
```

I'm not sure if `MAKEFLAGS` is effective since it still takes a long time to
compile and still only one core be used. I mean a about an hour or less, not sure.

## PowerShell

See [Installing PowerShell on Ubuntu](https://learn.microsoft.com/en-us/powershell/scripting/install/install-ubuntu?view=powershell-7.2).

Why do I use PowerShell? Because I can't write correct bash scripts (Help wanted!) and too lazy to use python.

## Usage

Check the source code. Just simple wrapper for the original command line interface.

- `convert.ps1` convert the `ckpt` format to diffusers format
- `train.ps1` train will train the model. Edit this file to change parameters. See [DreamBooth training example](https://github.com/ShivamShrirao/diffusers/tree/main/examples/dreambooth) for details.
- `back.ps1` would convert the diffusers format back to `ckpt` format. the `ckpt` would be half precision and only takes *2.4G*.

## TODOs

- [ ] Provide a Jupyter interface directly
- [ ] Intergrate AUTOMATIC WebUI (I'm afraid there's no enough space)

## Troubleshooting

Error in `File "/root/miniconda3/envs/diffusers/lib/python3.10/site-packages/bitsandbytes/cuda_setup/paths.py", line 90` that `CUDASetup.get_instance` is a function. 

Somehow the `get_instance` function is not called. Add `()` to fix it.
Is the TUNA still caching the old version? [This kind of bug should be fixed already](https://github.com/TimDettmers/bitsandbytes/blob/29e239e4d12b1c5b8ada4f03b90930735ddcb5b9/bitsandbytes/cuda_setup/paths.py#L90). ([commit](https://github.com/TimDettmers/bitsandbytes/commit/c584482f1f13e073dac714815f2d439fd66699d1))
