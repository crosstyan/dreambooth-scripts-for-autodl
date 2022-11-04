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

You can view sample images from WandB now.

### Multiple Class/Concept

See [`gen_concept.ps1`](gen_concept.ps1).

You can put multiple subject/class/concept in a json file like this

For example: You want to train two concept. Illustration from mika and some random sketch.

You have to choose a unique token first, you can test if the token you found is unique by [NovelAI Tokenizer](https://novelai.net/tokenizer). I choose `sks` and `sqn` here, which have token id `[48136]` and `[41209]`.

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
    "instance_prompt": "sqn sketch",
    "instance_data_dir": "/Users/crosstyan/Code/dreambooth/multiple_concept/sketch/inst",
    "class_prompt": "sketch",
    "class_negative_prompt": "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry",
    "class_data_dir": "/Users/crosstyan/Code/dreambooth/multiple_concept/sketch/class"
  }
]
```

### Multiple Optimizer

`--optimizer` argument. You could choose from `"adamw", "adamw_8bit", "adamw_ds", "sgdm", "sgdm_8bit"`.

### Aspect Ratio Bucket

~~Only support in alternative script.~~ See also [NovelAI/novelai-aspect-ratio-bucketing](https://github.com/NovelAI/novelai-aspect-ratio-bucketing/).

`--use_aspect_ratio_bucket` 

> BucketManager impls NovelAI Aspect Ratio Bucketing, which may greatly improve the quality of outputs according to [Novelai's blog](https://blog.novelai.net/novelai-improvements-on-stable-diffusion-e10d38db82ac)

### Read Prompt TXT

~~Only support in alternative script.~~ [commit](https://github.com/CCRcmcpe/diffusers/commit/91dc2ad80a35839ab1aa017224d5953712b3ae02)

`--read_prompt_txt`

Append extra prompt from txt. Just like how you train embeddings/hypernetworks in AUTOMATIC1111 WebUI.

### Train Text Encoder

`train_text_encoder` is necessary for multi-class training I think. Not sure.

### With Prior Preservation

Don't use class image for training (I guess)

> DB 关掉 prior preservation loss 加 variable instance prompt (Read Prompt TXT) 感觉相当于直接 finetune 了


## FAQ

> How do I continue training from a checkpoint?

Change `$ModelPath = Join-Path $AutoDLTmp $ModelName` to where you saved the checkpoint. Maybe you need to change `$OutPath` as well since it would overwrite the old checkpoint.
