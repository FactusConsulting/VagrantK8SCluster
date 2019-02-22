param(
    [int]
    $ipSegment
)

$inputFile = "scripts\01-netcfg.template.yaml"
$findstring = '$ip$'
$outputfile = "scripts\temp\$ipsegment-01-netcfg.yaml"
if (!(Test-Path "scripts\temp")) {New-Item -ItemType Directory -Path .\scripts\temp }

(Get-Content $inputFile) | ForEach-Object {$_.replace($findString, $ipSegment)} | Set-Content $outputFile -Force
(Get-Content $outputFile -Raw).Replace("`r`n","`n") | Set-Content $outputFile -Force
