vagrant destroy -f
if ($null -eq $ENV:pw) {
    .\scripts\Set-Credentials.ps1
}
vagrant up m1
vagrant provision m1 --provision-with "copy-netplanfiletovagrant"
vagrant provision m1 --provision-with "copy-netplanfile"
vagrant provision m1 --provision-with "apply-netplan"

vagrant ssh m1

# vagrant provision m1 --provision-with "k8sinstall_all"
# vagrant provision m1 --provision-with "copy-k8ssetupfiles"
# vagrant provision m1 --provision-with "k8sinstall_master"
# vagrant ssh m1


#vagrant provision m1 --provision-with "k8sinstall_all"
#vagrant provision m1 --provision-with "k8sinstall_master"