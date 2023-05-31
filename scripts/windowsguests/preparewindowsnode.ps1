install-WindowsFeature containers -IncludeAllSubFeature

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

Add-Content -Path c:\windows\system32\drivers\etc\hosts -Value "192.168.56.11 vagrantcluster"
Add-Content -Path c:\windows\system32\drivers\etc\hosts -Value "192.168.56.11 cp11"
Add-Content -Path c:\windows\system32\drivers\etc\hosts -Value "192.168.56.12 cp12"
Add-Content -Path c:\windows\system32\drivers\etc\hosts -Value "192.168.56.13 cp13"
Add-Content -Path c:\windows\system32\drivers\etc\hosts -Value "192.168.56.21 lw21"
Add-Content -Path c:\windows\system32\drivers\etc\hosts -Value "192.168.56.31 ww31"