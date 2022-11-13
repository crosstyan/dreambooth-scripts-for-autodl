# Usage

Check the source code. Just simple wrapper for the original command line interface.

- `convert.ps1` convert the `ckpt` format to diffusers format
- `train.ps1` train will train the model. Edit this file to change parameters. See [DreamBooth training example](https://github.com/ShivamShrirao/diffusers/tree/main/examples/dreambooth) for details.
- `back.ps1` would convert the diffusers format back to `ckpt` format. the `ckpt` would be half precision and only takes *2.4G*.

and check the [SOURCE CODE](https://github.com/CCRcmcpe/diffusers/blob/main/examples/dreambooth/modules/args.py) of `train_dreambooth.py` for details.

I would copy and paste the description from the original colab for now.

## Features

See [`base_config.yaml`](base_config.yaml) 
and [`dreambooth.yaml`](https://github.com/CCRcmcpe/diffusers/blob/yaml-config/examples/dreambooth/configs/dreambooth.yaml)
for the full list of options.

### YAML Config

See [`base_config.yaml`](base_config.yaml). I'm using native training by default. I assume you know the difference between native and DreamBooth. If not, read [the FAQ](https://gist.github.com/crosstyan/f912612f4c26e298feec4a2924c41d99).

Use `--config` in [`train.ps1`](train.ps1) to specify the config file and use [`gen_config.py`](gen_config.py) to generate the config file, modify it if you like but it suits my needs.

### WandB

You can use [WandB](https://wandb.ai/) (Weight and Bias) to monitor your training process.

```bash
pip install wandb
wandb login
# input your wandb API token
```

You can view sample images from WandB now.

### Multiple Class/Concept

See [`gen_config.py`](gen_config.py)

### Aspect Ratio Bucket

See also [NovelAI/novelai-aspect-ratio-bucketing](https://github.com/NovelAI/novelai-aspect-ratio-bucketing/).

> BucketManager impls NovelAI Aspect Ratio Bucketing, which may greatly improve the quality of outputs according to [Novelai's blog](https://blog.novelai.net/novelai-improvements-on-stable-diffusion-e10d38db82ac)

### Train Text Encoder

`train_text_encoder` is weird. Check [the FAQ](https://gist.github.com/crosstyan/f912612f4c26e298feec4a2924c41d99) for details.

### With Prior Preservation

> DB without prior preservation loss and enable variable instance prompt (Read Prompt TXT) is fine tuning directly.
