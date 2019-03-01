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
    get-vm -Name $vmName | Stop-Vm
    Add-VMNetworkAdapter -VMName $vmName -switchname $switchName -Name "fixedip" -DeviceNaming On
    start-VM -Name $vmName

    #Wait for machine to come back up before configuring the NIC card
    # Write-Host "Waiting 10 seconds for the machine to boot again ... " (Get-Date  )
    # Start-Sleep -Seconds 10
    # Write-Host "Waited 10 seconds Proceeding ... " (Get-Date  )
}
else {
    Write-Host "$vmName already has the needed network adapters. Skipping this step."
}