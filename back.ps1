param(
    # the original use_checkpoint
    [Parameter(Mandatory=$true)]
    [string]$step
 )

$BackConverter = "repos/diffusers/scripts/convert_diffusers_to_original_stable_diffusion.py"

$AutoDLTmp = "/root/autodl-tmp"
$OutPath = "$AutoDLTmp/output" # no slash at the end
# input
$ModelPath = Join-Path $OutPath $step
# output
$CheckpointPath = Join-Path $ModelPath "model.ckpt"

# unet_half could reduce the size of the model
python $BackConverter  --model_path $ModelPath `
                        --checkpoint_path $CheckpointPath `
                        --unet_half

Write-Host "Back conversion done"
