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

vagrant provision m1 --provision-with "k8sinstall_master"
# & vagrant provision m1 --provision-with "copy_netplanfiletovagrant"
# & vagrant provision m1 --provision-with "configure_guestnetwork"
# & vagrant provision m1 --provision-with "k8sinstall_all"
# & vagrant provision m1 --provision-with "k8sinstall_master"

vagrant up ln1
vagrant provision ln1 --provision-with "copy_netplanfiletovagrant","configure_guestnetwork","k8sinstall_all","k8sinstall_linuxnode"


vagrant up wn1
vagrant provision wn1 --provision-with "config_windowsclient","opy_daemon.json"


vagrant halt m1
vagrant snapshot save m1 before-kubeinit
vagrant up m1
vagrant provision m1 --provision-with "k8sinstall_master"

vagrant snapshot restore m1 before-kubeinit

vagrant halt ln1
vagrant snapshot save ln1 before-kubejoin
vagrant up ln1
vagrant provision m1 --provision-with "k8sinstall_node"

vagrant snapshot restore ln1 before-kubejoin

$v = get-vm -Name vagrantk8s_ln21
$v.VMId