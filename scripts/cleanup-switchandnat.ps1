Get-NetNat | Remove-NetNat -Confirm:$false
Get-VMSwitch -Name "VagrantNatSwitch" | Remove-VMSwitch -Confirm:$false -Force