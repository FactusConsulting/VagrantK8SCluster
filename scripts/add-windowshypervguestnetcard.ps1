param(
    [int]
    $ipSegment
)


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