Write-Host "Hello from windows server node"

#new-NetIPAddress -ifIndex $ifindex -IPAddress 192.168.3.10 -PrefixLength 24 -AddressFamily IPv4 -DefaultGateway 192.168.3.1

Write-Host "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Installing nuget provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

#Installing windows admin center
Invoke-WebRequest -Uri "https://aka.ms/WACDownload" -OutFile winadmin.msi

msiexec /i winadmin.msi /qn /L*v log.txt SME_PORT=4443 SSL_CERTIFICATE_OPTION=generate
New-NetFirewallRule -DisplayName 'WinServerAdmin' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('44300', '44301')
# Write-Host "Installing Docker EE provider"
# Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

# Write-Host "Installing Docker EE"
# Install-Package -Name Docker -ProviderName DockerMsftProvider -force

# Copy-Item daemon.json c:\programdata\docker\config\
# start-service docker
docker version



####  Install windows admin services
Invoke-WebRequest -Uri "https://aka.ms/WACDownload" -OutFile "winadm.msi"
msiexec /i winadmin.msi /qn /L*v log.txt SME_PORT=44300 SSL_CERTIFICATE_OPTION=generate




# #####  Setting up domain #################

# install-windowsfeature AD-Domain-Services

# ## Reboot

# Import-Module ADDSDeployment
# $pw = ConvertTo-SecureString -AsPlainText "vagrant" -force

# Install-ADDSForest `
# -CreateDnsDelegation:$false `
# -DatabasePath “C:\Windows\NTDS” `
# -DomainMode “WinThreshold” `
# -DomainName “kubernetes.local” `
# -DomainNetbiosName “kubernetes” `
# -ForestMode “WinThreshold” `
# -InstallDns:$true `
# -LogPath “C:\Windows\NTDS” `
# -NoRebootOnCompletion:$true `
# -SysvolPath “C:\Windows\SYSVOL” `
# -Force:$true `
# -SafeModeAdministratorPassword $pw

# ## Reboot


