Get-WindowsFeature -Name Containers
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force -Confirm
Install-Package -Name docker -ProviderName DockerMsftProvider -Force