param(
    $vmName
)

Write-Host "Hello from $env:COMPUTERNAME"
$switchName = "VagrantNatSwitch"

#Add new NIC card to Hyper-v Machine
Write-Output "Adding new network adapter to the vagrant guest"
$existingFixedIpAdapter = Get-VMnetworkadapter -vmname $vmName | where-object -property Name -Like "fixedip"
if ($null -eq $existingFixedIpAdapter) {
    Write-Host "No existing NAT network adapter found for VM $vmName. Adding one"
    get-vm -Name $vmName | Stop-Vm -TurnOff
    Add-VMNetworkAdapter -VMName $vmName -switchname $switchName -Name "fixedip" -DeviceNaming On
    start-VM -Name $vmName

    #Wait for machine to come back up before configuring the NIC card
    Start-Sleep -Seconds 10
}
else {
    Write-Host "$vmName already has the needed network adapters. Skipping this step."
}