$TRAINER = "repos/diffusers/examples/dreambooth/train_dreambooth.py"
$CONVERTER = "repos/diffusers/scripts/convert_original_stable_diffusion_to_diffusers.py"
$BACK_CONVERTER = "repos/diffusers/scripts/convert_diffusers_to_original_stable_diffusion.py"

# Download the model
# https://pub-2fdef7a2969f43289c42ac5ae3412fd4.r2.dev/animefull-pruned.tar
# https://pub-2fdef7a2969f43289c42ac5ae3412fd4.r2.dev/animevae.pt
# tar -cf animefull-pruned.tar

# models/
# |-- animevae.pt
# |-- config.yaml // the config file comes with the model
# `-- model.ckpt

$ModelDir = "models"
$CheckpointPath = Join-Path $ModelDir "model.ckpt"
$VaePath = Join-Path $ModelDir "animevae.pt"
$ConfPath = Join-Path $ModelDir "config.yaml"
$ModelName = "animefull-pruned"
# dump to auto-tmp to save space of system disk
$AutoDLTmp = "/root/autodl-tmp"
$DumpPath = Join-Path $AutoDLTmp $ModelName

python $CONVERTER --checkpoint_path $CheckpointPath `
                  --original_config_file $ConfPath `
                  --vae_path $VaePath `
                  --dump_path $DumpPath `
                  --scheduler_type ddim

Write-Host "Conversion done"
