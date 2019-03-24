param(
    [int]
    $ipSegment
)

Write-Verbose "Hello from $env:COMPUTERNAME"
Write-Verbose "Hello from create-hypervguestnetwork.ps1 with parameter ipSegment: $ipSegment"
#find the name and ifindex of the new switch
$newNetAdapter = Get-NetAdapterAdvancedProperty -DisplayName "Hyper-V Network Adapter Name" | Where-Object DisplayValue -like "fixedIp"
$newAdapterName = $newNetAdapter.Name
if ((get-netadapter -Name $newAdapterName | Get-NetIPAddress).IPAddress -notlike "192.168.1.$ipsegment") {
    Write-Verbose "About to set IP on new netadapter on guest for ip segment $ipSegment"
    Get-NetAdapter -Name $newAdapterName | New-NetIPAddress -IPAddress 192.168.10.$ipSegment -PrefixLength 24 -DefaultGateway 192.168.10.1
    Write-Verbose "New IP address and default gateway is set: $(Get-NetIPAddress)"
    $ifindex = (Get-NetAdapter -Name $newAdapterName).ifIndex
    Write-Verbose "Found ifindex for adapter: $ifindex"
    Set-DnsClientServerAddress -InterfaceIndex $ifindex -ServerAddresses ("1.0.0.1", "192.168.1.26")
    Write-Verbose "DNS servers set"
    Set-NetIPInterface -InterfaceIndex $ifindex -InterfaceMetric 5
    Write-Verbose "Interface metric set to 5"
}
Write-Verbose "About to rename Ethernet 2 netadapter to 'vEthernet (Ethernet)'"
Rename-NetAdapter -Name "Ethernet 2" -NewName "vEthernet (Ethernet)" #Else the shitty MS script wont work
Write-Verbose "Ethernet adapter renamed"

#For testing purposes - enable ICMP echo requests:
#IPv4
Write-Verbose "Opening ICMP echo requests for IPv4"
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol="icmpv4:8,any" dir=in action=allow
#IPv6
Write-Verbose "Opening ICMP echo requests for IPv6"
netsh advfirewall firewall add rule name="ICMP Allow incoming V6 echo request" protocol="icmpv6:8,any" dir=in action=allow


