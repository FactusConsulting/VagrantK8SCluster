Write-Verbose "Hello from windows server node"

get-netadapter
Get-NetIPConfiguration

Write-Verbose "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Verbose "Installing nuget provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Write-Verbose "Installing Docker EE provider"
# Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
# Write-Verbose "Installing Docker EE"
# Install-Package -Name Docker -ProviderName DockerMsftProvider -force
# Copy-Item daemon.json c:\programdata\docker\config\
# start-service docker
docker version

# Write-Verbose "We are pulling the Nanoserver image, this might take a few minutes"
# docker pull mcr.microsoft.com/windows/nanoserver:1809
# docker tag mcr.microsoft.com/windows/nanoserver:1809 microsoft/nanoserver:latest

mkdir c:\k
Copy-Item c:\vagrant\kubeconfig c:\k\config
[Environment]::SetEnvironmentVariable("KUBECONFIG", "c:\k\config", "Machine")


<#
Download
kubectl
Kubelet
kubeproxy
#>

New-Item -Path c:\temp -ItemType Directory
Set-Location c:\temp

Write-Verbose "Downloading Kubelet etc..."
$url = "https://dl.k8s.io/v1.14.0-beta.2/kubernetes-node-windows-amd64.tar.gz"
$output = "c:\temp\kubenode.gz"
(New-Object System.Net.WebClient).DownloadFile($url, $output)

tar -xzvf c:/temp/kubenode.gz -C c:/temp
Move-Item "c:/temp/kubernetes/node/bin/*.exe" c:/k/


# ####  Install windows admin services
# Invoke-WebRequest -Uri "https://aka.ms/WACDownload" -OutFile "winadm.msi"
# msiexec /i winadmin.msi /qn /L*v log.txt SME_PORT=44300 SSL_CERTIFICATE_OPTION=generate
# New-NetFirewallRule -DisplayName 'WinServerAdmin' -Profile @('Domain', 'Private') -Direction Inbound -Action Allow -Protocol TCP -LocalPort @('44300', '44301')

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


## Flannel network setup
Set-Location c:\k
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Verbose "Downloading start.ps1 to c:\k ... ready for running command manually on server"
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/flannel/start.ps1 -o c:\k\start.ps1
###Run this manually #.\start.ps1 -ManagementIP 192.168.10.31 -NetworkMode overlay -ClusterCIDR 10.244.0.0/16 -ServiceCIDR 10.96.0.0/12 -KubeDnsServiceIP 10.96.0.10 -InterfaceName Ethernet -LogDir c:\k -KubeletFeatureGates "WinOverlay=true"



$url = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2019/02/windows10.0-kb4482887-x64_826158e9ebfcabe08b425bf2cb160cd5bc1401da.msu"
$output = "c:\temp\kb4482887-x64.msu"
Write-Verbose "Downloading and installing the KB4482887 for Windows"
(New-Object System.Net.WebClient).DownloadFile($url, $output)
wusa c:\temp\kb4482887-x64.msu /quiet /norestart
