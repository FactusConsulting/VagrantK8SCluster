Write-Verbose "Hello from windows server node"
# Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol -NoRestart

Write-Verbose "Installing Chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) | Write-Verbose

Write-Verbose "Installing nuget provider"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Write-Verbose
docker version | Write-Verbose

# Write-Verbose "We are pulling the Nanoserver image, this might take a few minutes"
# docker pull mcr.microsoft.com/windows/nanoserver:1809
# docker tag mcr.microsoft.com/windows/nanoserver:1809 microsoft/nanoserver:latest

mkdir c:\k  | Write-Verbose
Copy-Item c:\vagrant\kubeconfig c:\k\config  | Write-Verbose
[Environment]::SetEnvironmentVariable("KUBECONFIG", "c:\k\config", "Machine")   | Write-Verbose


<#
Download
kubectl
Kubelet
kubeproxy
#>

New-Item -Path c:\temp -ItemType Directory | Write-Verbose
Set-Location c:\temp    | Write-Verbose

Write-Verbose "Downloading Kubelet etc..."
$url = "https://dl.k8s.io/v1.14.0-rc.1/kubernetes-node-windows-amd64.tar.gz"
#https://dl.k8s.io/v1.14.0-beta.2/kubernetes-node-windows-amd64.tar.gz
#https://dl.k8s.io/v1.14.0-rc.1/kubernetes-node-windows-amd64.tar.gz
$output = "c:\temp\kubenode.gz"
(New-Object System.Net.WebClient).DownloadFile($url, $output)

tar -xzvf c:/temp/kubenode.gz -C c:/temp   | Write-Verbose
Move-Item "c:/temp/kubernetes/node/bin/*.exe" c:/k/    | Write-Verbose

########  Updating Server ##########
# $url = "http://download.windowsupdate.com/c/msdownload/update/software/updt/2019/02/windows10.0-kb4482887-x64_826158e9ebfcabe08b425bf2cb160cd5bc1401da.msu"
# $output = "c:\temp\kb4482887-x64.msu"
# Write-Verbose "Downloading and installing the KB4482887 for Windows"
# (New-Object System.Net.WebClient).DownloadFile($url, $output)
# wusa c:\temp\kb4482887-x64.msu /quiet /norestart

Write-Verbose "Installing windows update powershell module" -Verbose
Install-Module PSWindowsUpdate -Confirm:$false -Force
Write-Verbose "Running Get-WindowsUpdate" -Verbose
Get-WindowsUpdate -Confirm:$false
Write-Verbose "Running Install-WindowsUpdate" -Verbose
Install-WindowsUpdate -Confirm:$false

## Flannel network setup
Set-Location c:\k
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Verbose "Downloading start.ps1 to c:\k ... ready for running command manually on server" -Verbose
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/flannel/start.ps1 -o c:\k\start.ps1
### Run this manually ####  .\start.ps1 -ManagementIP 192.168.10.31 -NetworkMode overlay -ClusterCIDR 10.244.0.0/16 -ServiceCIDR 10.96.0.0/12 -KubeDnsServiceIP 10.96.0.10 -InterfaceName Ethernet -LogDir c:\k -KubeletFeatureGates "WinOverlay=true"