# I can't write comment and parse path in json. So I wrote this script to generate the json file.

$MultBaseDir = Join-Path (Invoke-Expression "Get-Location") "multiple_concept"
$OutJson = Join-Path (Invoke-Expression "Get-Location") "concept.json"

# use 
# https://novelai.net/tokenizer
# to find if your word is unique token
# remember to choose CLIP
# https://github.com/CCRcmcpe/diffusers/blob/c792f11c3fd7e3b271ff14a27478a4597dd73cdb/examples/dreambooth/train_dreambooth.py#L583

$negative = "lowres, bad anatomy, bad hands, text, error, missing fingers, extra digit, fewer digits, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry"

# https://stackoverflow.com/questions/25880122/how-do-i-use-join-path-to-combine-more-than-two-strings-into-a-file-path
$mika = @{
  instance_prompt = "sks woman";
  class_prompt = "woman";
  class_negative_prompt = $negative;
  instance_data_dir = [IO.Path]::Combine($MultBaseDir,"mika","inst");
  class_data_dir = [IO.Path]::Combine($MultBaseDir,"mika","class");
}

$sketch = @{
  instance_prompt = "sks sketch";
  class_prompt = "sketch";
  class_negative_prompt = $negative;
  instance_data_dir = [IO.Path]::Combine($MultBaseDir,"sketch","inst");
  class_data_dir = [IO.Path]::Combine($MultBaseDir,"sketch","class");
}

# $concepts = $mika, $sketch
# $concepts = @($mika, $sketch)
# wrap it with @() to make it an array
$concepts = @($mika)

$res = ConvertTo-Json $concepts
Out-File -FilePath $OutJson -InputObject $res
Write-Host "Concept Lists is written to $OutJson" 
