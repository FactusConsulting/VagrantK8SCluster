Write-Host "Hello from windows server node"

#new-NetIPAddress -ifIndex $ifindex -IPAddress 192.168.3.10 -PrefixLength 24 -AddressFamily IPv4 -DefaultGateway 192.168.3.1

Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Installing nuget provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Write-Host "Installing Docker EE provider"
# Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

# Write-Host "Installing Docker EE"
# Install-Package -Name Docker -ProviderName DockerMsftProvider -force

# Copy-Item daemon.json c:\programdata\docker\config\
# start-service docker
docker version
