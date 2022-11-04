# Usage

Check the source code. Just simple wrapper for the original command line interface.

- `convert.ps1` convert the `ckpt` format to diffusers format
- `train.ps1` train will train the model. Edit this file to change parameters. See [DreamBooth training example](https://github.com/ShivamShrirao/diffusers/tree/main/examples/dreambooth) for details.
- `back.ps1` would convert the diffusers format back to `ckpt` format. the `ckpt` would be half precision and only takes *2.4G*.

and check the [SOURCE CODE](https://github.com/CCRcmcpe/diffusers/blob/main/examples/dreambooth/train_dreambooth.py) of `train_dreambooth.py` for details.

I would copy and paste the description from the original colab for now.

## Features

### WandB

You can use [WandB](https://wandb.ai/) (Weight and Bias) to monitor your training process.

```bash
pip install wandb
wandb login
# input your wandb API token
```

### Multiple Class/Concept

See [`gen_concept.ps1`](gen_concept.ps1).

You can put multiple subject/class/concept in a json file like this

```json
[
  {
    "instance_prompt": "sks woman",
    "instance_data_dir": "/Users/crosstyan/Code/dreambooth/multiple_concept/mika/inst",
    "class_prompt": "woman",
    "class_negative_prompt": "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry",
    "class_data_dir": "/Users/crosstyan/Code/dreambooth/multiple_concept/mika/class"
  },
  {
    "instance_prompt": "sks sketch",
    "instance_data_dir": "/Users/crosstyan/Code/dreambooth/multiple_concept/sketch/inst",
    "class_prompt": "sketch",
    "class_negative_prompt": "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry",
    "class_data_dir": "/Users/crosstyan/Code/dreambooth/multiple_concept/sketch/class"
  }
]
```

### Multiple Optimizer

Only in RcINS fork.

`--optimizer` argument. You could choose from `"adamw", "adamw_8bit", "adamw_ds", "sgdm", "sgdm_8bit"`.

### Aspect Ratio Bucket

Only support in alternative script. See also [NovelAI/novelai-aspect-ratio-bucketing](https://github.com/NovelAI/novelai-aspect-ratio-bucketing/).

`--use_aspect_ratio_bucket` 

> BucketManager impls NovelAI Aspect Ratio Bucketing, which may greatly improve the quality of outputs according to [Novelai's blog](https://blog.novelai.net/novelai-improvements-on-stable-diffusion-e10d38db82ac)

Maybe use with `prior preservation loss`? I'm not sure if it's necessary.

### Read Prompt TXT

Only support in alternative script.

`--read_prompt_txt`

Append extra prompt from txt. Just like how you train embeddings/hypernetworks in AUTOMATIC1111 WebUI.

### Train Text Encoder

`train_text_encoder` is necessary for multi-class training. It would train a text encoder.

### With Prior Preservation

Don't use class image for training (I guess)

> DB 关掉 prior preservation loss 加 variable instance prompt (Read Prompt TXT) 感觉相当于直接 finetune 了


## FAQ

> How do I continue training from a checkpoint?

Change `$ModelPath = Join-Path $AutoDLTmp $ModelName` to where you saved the checkpoint. Maybe you need to change `$OutPath` as well since it would overwrite the old checkpoint.
