<#
Setting the Windows VM secondary network card to use the VagrantNatSwitch after booting up.
#>
param(
    $vmName
)

Write-Verbose "Hello from $env:COMPUTERNAME"
Write-Verbose "Param VMName = $vmName" -Verbose
$switchName = "VagrantNatSwitch"
GET-VM -Name $vmName | GET-VMNetworkAdapter -Name fixedip  |  Connect-VMNetworkAdapter -SwitchName $switchName