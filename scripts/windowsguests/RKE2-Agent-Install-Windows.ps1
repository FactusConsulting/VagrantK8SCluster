Invoke-WebRequest -Uri https://raw.githubusercontent.com/rancher/rke2/master/install.ps1 -Outfile install.ps1

New-Item -Type Directory c:/etc/rancher/rke2 -Force

# Set-Content -Path c:/etc/rancher/rke2/config.yaml -Value @"
# server: https://<server>:9345
# token: <token from server node>
# "@

$env:PATH+=";c:\var\lib\rancher\rke2\bin;c:\usr\local\bin"

[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";c:\var\lib\rancher\rke2\bin;c:\usr\local\bin",
    [EnvironmentVariableTarget]::Machine)

./install.ps1
rke2.exe agent service --add
get-service rke2 | start-service
choco install vim -y

cp /home/vagrant/config.yaml /etc/rancher/rke2/config.yaml