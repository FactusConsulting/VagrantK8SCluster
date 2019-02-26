param(
    [int]
    $ipSegment
)

Write-Host "create-netplananyyamlfile called with ipsegment: $ipSegment"

$inputFile = "01-netcfg.template.yaml"
$findstring = '$ip$'
$outputfile = "$ipsegment-01-netcfg.yaml"

(Get-Content $inputFile) | ForEach-Object {$_.replace($findString, $ipSegment)} | Set-Content $outputFile -Force
(Get-Content $outputFile -Raw).Replace("`r`n","`n") | Set-Content $outputFile -Force