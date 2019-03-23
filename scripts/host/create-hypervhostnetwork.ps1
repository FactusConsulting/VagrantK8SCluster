
Write-Verbose "Hello from $env:COMPUTERNAME"
Write-Verbose "create-hypervhostnetwork.ps1 called"

############  Default switch has to be massaged: #############
Write-Verbose "Testing if the Default Switch exists"
$defaultAdapter = Get-Netadapter | Where-Object -Property Name -like "*Default Switch*"
if ($null -eq $defaultAdapter) {
    Write-Error "No Hyper-v switch 'Default Switch' is found. Restart the computer `
    to recreate the default switch and try again."
}
else { Write-Verbose "Default switch already exists" }

Write-Verbose "Default Switch found. Enabling and disabling the Hyper-v switch to ensure it is functional"
$defaultAdapter | Disable-NetAdapter -Confirm:$false
$defaultAdapter | Enable-NetAdapter
Get-NetAdapterBinding -Name "vEthernet (Default Switch)" -DisplayName "File and Printer Sharing for Microsoft Networks" | Disable-NetAdapterBinding
Get-NetAdapterBinding -Name "vEthernet (Default Switch)" -DisplayName "File and Printer Sharing for Microsoft Networks" | Enable-NetAdapterBinding
Write-Verbose "Setting connection profile to private for Default switch"
Write-Verbose "Default switch config complete."

############  SMB 3.0 is needed for shares: #############
Write-Verbose "Checking for SMB 3.0 enabled"
$smb = Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like "SmbDirect"}
if ($null -eq $smb) {
    Write-Verbose "SMB 3.0 not found. Installing it"
    Enable-WindowsOptionalFeature -Online -FeatureName SmbDirect
    Write-Verbose "SMB 3.0 is now enabled"
}
else { Write-Verbose "SMB3.0 is already enabled - continuing"}


############  Hyper-v VagrantNatSwitch: #############
Write-Verbose "Creating new NAT Hyper-V network on your host, if it does not already exist"
$switchName = "VagrantNatSwitch"
$natSwitch = Get-VMSwitch | Where-Object -Property Name -like "*$switchName*"
if ($null -eq $natSwitch) {
    Write-Verbose "No Hyper-v switch VagrantNatSwitch is found. Creating one."
    New-VMSwitch -SwitchName $switchName -SwitchType Internal
    $adapter = Get-NetAdapter | Where-Object -Property InterfaceAlias -like "*$switchName*"
    New-NetIPAddress -IPAddress 192.168.10.1 -PrefixLength 24 -InterfaceIndex $adapter.ifIndex -DefaultGateway 192.168.10.1 -AddressFamily IPv4
    Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses ("1.0.0.1", "192.168.1.26")
    Get-NetConnectionProfile -InterfaceIndex $adapter.ifIndex | Set-NetConnectionProfile -NetworkCategory Private
    Write-Verbose "New Hyper-v Vagrant nat switch $switchName is created"
}
else {
    Write-Verbose "Hyper-v switch $switchName already exists - continuing"
}
Get-NetAdapterBinding -Name "vEthernet (VagrantNatSwitch)" -DisplayName "File and Printer Sharing for Microsoft Networks" | Disable-NetAdapterBinding
Get-NetAdapterBinding -Name "vEthernet (VagrantNatSwitch)" -DisplayName "File and Printer Sharing for Microsoft Networks" | Enable-NetAdapterBinding
Set-NetConnectionProfile -NetworkCategory Private -InterfaceIndex $defaultAdapter.ifIndex

############  Vagrant Nat network: #############
Write-Verbose "Looking for the VagrantNatNetwork on this machine"
$natnetworks = Get-NetNat | Where-Object -Property Name -like "*VagrantNatNetwork*"
if ($null -eq $natnetworks) {
    Write-Verbose "No netnat is found. Creating the VagrantNatNetwork"
    New-NetNat -Name "VagrantNatNetwork" -InternalIPInterfaceAddressPrefix 192.168.10.0/24
    Write-Verbose "New vagrant NAT network has been created"
}
else {
    Write-Verbose "Vagrant NAT network already exists - continuing"
}
