param(
    [int]
    $ipSegment
)

#### below should be moved to a windows specific script, only called from windows vagrant guests.
#### Script the same for linux boxes, in a shell script
####  IP address and computername must be parameterized

#Set ip address on NIC through "PowerShell Direct"

#First enter into session on the machine
# $userName = "vagrant"
# $password = ConvertTo-SecureString -AsPlainText "vagrant" -Force
# $credentials = new-object -typename System.Management.Automation.PSCredential -argumentlist $userName, $password
# Enter-PSSession -VMName vagrantk8s_wn1 -Credential $credentials

# Parameter help description

# Parameter help description

Write-Host "Hello from $env:COMPUTERNAME"
Write-Host "Hello from create-hypervguestnetwork.ps1 with parameter ipSegment: $ipSegment"


#find the name and ifindex of the new switch
$newNetAdapter = Get-NetAdapterAdvancedProperty -DisplayName "Hyper-V Network Adapter Name" | Where-Object DisplayValue -like "fixedIp"
$newAdapterName = $newNetAdapter.name

#Set the IP address, gateway and dns address on the new guest network card (only for windows servers)
Get-NetAdapter -Name $newAdapterName | Remove-NetIPAddress  -Confirm:$false
Get-NetAdapter -Name $newAdapterName | New-NetIPAddress -IPAddress 192.168.10.$ipSegment -PrefixLength 24 -DefaultGateway 192.168.10.1
$ifindex = (Get-NetAdapter -Name $newAdapterName).ifIndex
Set-DnsClientServerAddress -InterfaceIndex $ifindex -ServerAddresses ("1.0.0.1", "192.168.1.26")

# Exit-PSSession