param(
  [switch] $alt=$false,
  [switch] $wandb=$true,
  [Parameter()]
  [string]$BatchSize = "4"
)

$Trainer = "repos/diffusers/examples/dreambooth/train_dreambooth.py"

# https://stackoverflow.com/questions/31879814/check-if-a-file-exists-or-not-in-windows-powershell
if ($alt) {
  Write-Host "Try to use alternative script"
  $Trainer = "repos/diffusers/examples/dreambooth/train_dreambooth_alt.py"
  $exist = Test-Path $Trainer -PathType Leaf
  if (!$exist) {
    Write-Host -ForegroundColor red "Alternative trainer not found. Run 'get_alt_script.ps1' to get it."
    exit 1
  }
} else {
  $exist = Test-Path $Trainer -PathType Leaf
  if (!$exist) {
    Write-Host -ForegroundColor red "Trainer not found. Have you run 'git submodule update --init --recursive'?"
    exit 1
  }
}

$WandBParam = if ($wandb) { "--wandb" } else { "" }

$AutoDLTmp = "/root/autodl-tmp"

# Training parameters.
# @param {type:"slider", min:64, max:2048, step:28}
$Resolution = 768 

$ConceptsPath = Join-Path (Invoke-Expression "Get-Location") "concept.json"

# Previewing
# Prompt for saving samples.
$SaveSamplePrompt = "sks 1girl standing looking at viewer, cowboy shot" 
$SaveSampleNegative = "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry" 

# TODO: detect if the model exists
# Remind the user to excecute `convert.ps1` if the model is not existing.

# Model path
$ModelName = "animefull-pruned"
# I will dump to auto-tmp to save space of system disk
$ModelPath = Join-Path $AutoDLTmp $ModelName
$VaePath = Join-Path $ModelPath "vae"
$OutPath = Join-Path $AutoDLTmp "output"
mkdir -p $OutPath

# https://stackoverflow.com/questions/2608144/how-to-split-long-commands-over-multiple-lines-in-powershell
# use this setting if you are using A5000 like me
accelerate launch $Trainer `
  --instance_data_dir $InstanceDir `
  --instance_prompt $InstancePrompt `
  --pretrained_model_name_or_path $ModelPath `
  --pretrained_vae_name_or_path $VaePath `
  --output_dir $OutPath `
  --seed=1337 `
  --resolution=$Resolution `
  --train_batch_size=$BatchSize `
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
  --concepts_list $ConceptsPath `
  --gradient_checkpointing `
  <# --use_8bit_adam if you are running alt script#> `
  --optimizer adamw_8bit `
  --save_unet_half `
  --mixed_precision="fp16" `
  --train_text_encoder `
  $WandBParam

# `gradient accumulation` will save VRAM but slow it down
# `train_text_encoder` would train text encoder
# increase the batch size if you still got spare VRAM

# TODO: write a script to inference images with parameters like json?
# don't care about inference. I would do it some where else.
# see `back.ps1`
