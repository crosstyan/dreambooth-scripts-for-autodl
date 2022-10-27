$TRAINER = "repos/diffusers/examples/dreambooth/train_dreambooth.py"
$CONVERTER = "repos/diffusers/scripts/convert_original_stable_diffusion_to_diffusers.py"
$BACK_CONVERTER = "repos/diffusers/scripts/convert_diffusers_to_original_stable_diffusion.py"

# Download the model
# https://pub-2fdef7a2969f43289c42ac5ae3412fd4.r2.dev/animefull-pruned.tar
# https://pub-2fdef7a2969f43289c42ac5ae3412fd4.r2.dev/animevae.pt

# models/
# |-- animevae.pt
# |-- config.yaml // the config file comes with the model
# `-- model.ckpt
# See `convert.ps1` for more details

$AutoDLTmp = "/root/autodl-tmp"

# Prompt describing the subject, like subject's name.
$InstancePrompt = "a sketch of sks"
# Training set path (images of the subject).
$InstanceDir = "${AutoDLTmp}/content/instance"

# Training parameters.
# @param {type:"slider", min:64, max:2048, step:28}
$Resolution = 512 
# @param {type:"slider", min:1, max:10, step:1}
$TrainBatchSize = 1 

# Regularization set
# A more general prompt describing the subject, for generating regularization
# image set.
$ClassPrompt = "masterpiece, best quality, 1girl"
$ClassNegativePrompt = "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry" 
# Regularization set path.
$ClassDir = "${AutoDLTmp}/content/class-images"

# Previewing
# Prompt for saving samples.
$SaveSamplePrompt = "masterpiece, best quality, sks 1girl, looking at viewer" 
$SaveSampleNegative = "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry" 

# Model path
$ModelName = "animefull-pruned"
# I will dump to auto-tmp to save space of system disk
$ModelPath = "${AutoDLTmp}/${ModelName}"
$VaePath = "${ModelPath}/vae"
$OutPath = "${AutoDLTmp}/output"
mkdir -p $OutPath

accelerate launch $TRAINER `
  --instance_data_dir $InstanceDir `
  --instance_prompt $InstancePrompt `
  --pretrained_model_name_or_path $ModelPath `
  --pretrained_vae_name_or_path $VaePath `
  --output_dir $OutPath `
  --seed=1337 `
  --resolution=$Resolution `
  --train_batch_size=$TrainBatchSize `
  --learning_rate=5e-6 `
  --lr_scheduler="cosine_with_restarts" `
  --lr_warmup_steps=100 `
  --max_train_steps=2000 `
  --save_interval=500 `
  --with_prior_preservation --prior_loss_weight=1.0 `
  --class_data_dir $ClassDir `
  --class_prompt $ClassPrompt --class_negative_prompt $ClassNegativePrompt `
  --num_class_images=25 `
  --save_sample_prompt $SaveSamplePrompt --save_sample_negative_prompt $SaveSampleNegative `
  --n_save_sample=4 `
  --infer_batch_size=2 `
  --infer_steps=28 `
  --guidance_scale=11 `
  --gradient_accumulation_steps=1 `
  --gradient_checkpointing `
  --use_8bit_adam `
  --save_unet_half `
  --mixed_precision="fp16"

# TODO: write a script to inference images with parameters
# don't care about inference. I would do it some where else.
# see `back.ps1`
