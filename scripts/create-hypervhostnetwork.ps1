param(
    $vmName
)

Write-Host "Hello from $env:COMPUTERNAME"
Write-Host "create-hypervhostnetwork.ps1 called with parameter: $vmName"
Write-Host "Creating new NAT Hyper-V network on your host, if it does not already exist"

$switchName = "VagrantNatSwitch"

$natswitch = Get-VMSwitch | Where-Object -Property Name -like "*$switchName*"
if ($null -eq $natswitch) {
    Write-Output "No Hyper-v switch VagrantNatSwitch is found"
    New-VMSwitch -SwitchName $switchName -SwitchType Internal
    $adapter = Get-NetAdapter | Where-Object -Property InterfaceAlias -like "*$switchName*"
    New-NetIPAddress -IPAddress 192.168.10.1 -PrefixLength 24 -InterfaceIndex $adapter.ifIndex
    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses ("1.0.0.1", "192.168.1.26")
    Write-Output "New Hyper-v Vagrant nat switch $switchName is created"
}
else {
    Write-Output "Hyper-v switch $switchName already exists - continuing"
}

$natnetworks = Get-NetNat | Where-Object -Property Name -like "*VagrantNatNetwork*"
if ($null -eq $natnetworks) {
    Write-Output "No netnat is found"
    New-NetNat -Name "VagrantNatNetwork" -InternalIPInterfaceAddressPrefix 192.168.10.0/24
    Write-Output "New vagrant NAT network has been created"
}
else {
    Write-Output "Vagrant NAT network already exists - continuing"
}

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