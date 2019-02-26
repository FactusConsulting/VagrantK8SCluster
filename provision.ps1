vagrant destroy -f
if ($null -eq $ENV:pw) {
    .\scripts\Set-Credentials.ps1
}

if ($null -eq (Get-SmbShare -Name vagrant)) {
    & net share vagrant=$($pwd.Path) /grant:everyone, FULL
}
#tilføj og fjern file sharing

vagrant up m1 #--debug 2>&1 | Tee-Object -FilePath ".\vagrant.log"
vagrant provision m1 --provision-with "copy_netplanfiletovagrant","configure_guestnetwork","k8sinstall_all","k8sinstall_master"
# & vagrant provision m1 --provision-with "copy_netplanfiletovagrant"
# & vagrant provision m1 --provision-with "configure_guestnetwork"
# & vagrant provision m1 --provision-with "k8sinstall_all"
# & vagrant provision m1 --provision-with "k8sinstall_master"

vagrant up ln1
vagrant provision ln1 --provision-with "copy_netplanfiletovagrant","configure_guestnetwork","k8sinstall_all","k8sinstall_linuxnode"
