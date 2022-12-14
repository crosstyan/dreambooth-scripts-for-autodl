param(
    # the original use_checkpoint
    [Parameter(Mandatory = $true)]
    [string]$id,
    [Parameter(Mandatory = $true)]
    [string]$step,
    [Parameter()]
    [string]$outputDir = "output"
)

$BackConverter = "repos/diffusers/scripts/convert_diffusers_to_original_stable_diffusion.py"

$exist = Test-Path $BackConverter -PathType Leaf
if (!$exist) {
    Write-Host -ForegroundColor red "Trainer not found. Have you run 'git submodule update --init --recursive'?"
    exit 1
}

$AutoDLTmp = "/root/autodl-tmp"
$OutPath = Join-Path $AutoDLTmp $outputDir
# input
# change this directly if you did not use the default ouput dir
# remove params
$ModelPath = Join-Path $OutPath $id $step
# output
$CheckpointPath = Join-Path $ModelPath "model.ckpt"

# unet_half could reduce the size of the model
python $BackConverter  --model_path $ModelPath `
    --checkpoint_path $CheckpointPath `
    --unet_half

Write-Host "Back conversion done"
