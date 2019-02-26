vagrant destroy -f
if ($null -eq $ENV:pw) {
    .\scripts\Set-Credentials.ps1
}

net share vagrant=$($pwd.Path) /grant:everyone,FULL
#tilføj og fjern file sharing

vagrant up m1 #--debug 2>&1 | Tee-Object -FilePath ".\vagrant.log"
vagrant provision m1 --provision-with "copy-netplanfiletovagrant"
vagrant provision m1 --provision-with "copy-netplanfile"
vagrant provision m1 --provision-with "apply-netplan"
$mountCommand = "sudo mount -t cifs -o vers=3.0,username=$($ENV:un),password=$($ENV:pw),uid=1000,gid=1000 //192.168.10.1/vagrant /vagrant"
vagrant ssh m1 -c "$mountCommand"
vagrant ssh m1

#mount -t cifs -o vers=3.0,credentials=/etc/smb_creds_vgt-fa8a1bae5c18f8b88d6ce2f75d504dea-6ad5fdbcbf2eaa93bd62f92333a2e6e5,uid=1000,gid=1000 //192.168.10.1/vgt-fa8a1bae5c18f8b88d6ce2f75d504dea-6ad5fdbcbf2eaa93bd62f92333a2e6e5 /vagrant

# vagrant provision m1 --provision-with "k8sinstall_all"
# vagrant provision m1 --provision-with "copy-k8ssetupfiles"
# vagrant provision m1 --provision-with "k8sinstall_master"
# vagrant ssh m1


#vagrant provision m1 --provision-with "k8sinstall_all"
#vagrant provision m1 --provision-with "k8sinstall_master"