<#
Setting the Windows VM secondary network card to use the VagrantNatSwitch after booting up.
#>

param(
    $vmName
)

Write-Host "Hello from $env:COMPUTERNAME"
$switchName = "VagrantNatSwitch"

GET-VM -Name $vmName | GET-VMNetworkAdapter -Name fixedip  |  Connect-VMNetworkAdapter -SwitchName $switchName