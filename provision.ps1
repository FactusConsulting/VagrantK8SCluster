vagrant destroy -f
vagrant up m1
vagrant provision m1 --provision-with "create-netplanfile"
vagrant provision m1 --provision-with "create-netplanfile"
vagrant provision m1 --provision-with "create-netplanfile"
vagrant provision m1 --provision-with "create-netplanfile"
vagrant ssh m1
#vagrant provision m1 --provision-with "k8sinstall_all"
#vagrant provision m1 --provision-with "k8sinstall_master"