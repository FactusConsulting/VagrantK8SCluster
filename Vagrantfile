# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  config.vagrant.plugins = ["vagrant-disksize", "vagrant-reload"]

  config.vm.provider "virtualbox" do |vb|
      vb.linked_clone = true
      vb.memory = 2048
      vb.cpus = 1
      # vb.gui = true
  end


    # Linux control plane nodes   Ubuntu ... not using Ubuntu atm
    (1..2).each do |number|
      config.vm.define "cp1#{number}" do |cp|
        # cp.vm.box = "ubuntu/focal64"
        cp.vm.box = "rockylinux/8"
        cp.disksize.size = '50GB'  # if rocky linux
        cp.vm.hostname = "cp1#{number}"
        cp.vm.network "private_network", ip: "192.168.56.1#{number}", hostname: true
        cp.vm.provider "virtualbox" do |vb|
          vb.name = "vagrantk8s_cp1#{number}"
          vb.memory = 4096
          vb.cpus = 1
          #vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]             #if ubuntu
          #vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]   #if ubuntu
        end
        cp.vm.synced_folder ".", type: "smb", disabled: true
        cp.vm.provision "file", source: "./scripts/zscalerroot.cer", destination: "~/zscalerroot.cer"
        cp.vm.provision "shell", inline: <<-SHELL    #if rocky linux ... copy zscaler root cert to here
          cp /home/vagrant/zscalerroot.cer /etc/pki/ca-trust/source/anchors
          update-ca-trust
        SHELL
        cp.vm.provision "shell", inline: <<-SHELL    #if rocky linux ... make the disk larger
          dnf install -y cloud-utils-growpart
          growpart /dev/sda 1
          xfs_growfs /dev/sda1
        SHELL
        cp.vm.provision "shell", inline: <<-SHELL    #add entries to the hostfile
          # echo "192.168.56.11 rancher" | tee -a /etc/hosts
          echo "192.168.56.11 cp11" | tee -a /etc/hosts
          echo "192.168.56.12 cp12" | tee -a /etc/hosts
          echo "192.168.56.21 lw21" | tee -a /etc/hosts
          echo "192.168.56.31 ww31" | tee -a /etc/hosts
        SHELL
        cp.vm.provision "shell", path: "scripts/linuxguests/nodeprereq.sh"
        cp.vm.provision :reload
      end
    end # Control plane end

    # LinuxWorkers
    (1..1).each do |number|
      config.vm.define "lw2#{number}" do |lw|
        lw.vm.box = "rockylinux/8"
        lw.disksize.size = '50GB'
        lw.vm.hostname = "lw2#{number}"
        lw.vm.network "private_network", ip: "192.168.56.2#{number}", hostname: true
        lw.vm.synced_folder ".", type: "smb", disabled: true
        lw.vm.provider "virtualbox" do |vb|
          vb.name = "vagrantk8s_lw2#{number}"
        end
        lw.vm.provision "file", source: "./scripts/zscalerroot.cer", destination: "~/zscalerroot.cer"
        lw.vm.provision "shell", inline: <<-SHELL    #if rocky linux ... copy zscaler root cert to here
          cp /home/vagrant/zscalerroot.cer /etc/pki/ca-trust/source/anchors
          update-ca-trust
        SHELL
        lw.vm.provision "shell", inline: <<-SHELL
          dnf install -y cloud-utils-growpart
          growpart /dev/sda 1
          xfs_growfs /dev/sda1
        SHELL
        lw.vm.provision "shell", inline: <<-SHELL    #add entries to the hostfile
          # echo "192.168.56.11 rancher" | tee -a /etc/hosts
          echo "192.168.56.11 cp11" | tee -a /etc/hosts
          echo "192.168.56.12 cp12" | tee -a /etc/hosts
          echo "192.168.56.21 lw21" | tee -a /etc/hosts
          echo "192.168.56.31 ww31" | tee -a /etc/hosts
        SHELL
        lw.vm.provision "shell", path: "scripts/linuxguests/nodeprereq.sh"
        lw.vm.provision :reload
      end
    end  #Linuxworkers end

    # WindowsWorkers
    (1..1).each do |number|
      config.vm.define "ww3#{number}" do |ww|
        ww.vm.box = "gusztavvargadr/windows-server-core"
        ww.vm.box_version = "1809.0.2207"
        ww.vm.communicator = "winrm"
        ww.vm.guest = "windows"
        ww.vm.hostname = "ww3#{number}"
        ww.vm.network "private_network", ip: "192.168.56.3#{number}"
        ww.vm.provider "virtualbox" do |vb|
          vb.name = "vagrantk8s_ww3#{number}"
          vb.memory = 8048
          vb.cpus = 2
        end
      end
    end # Windows workers end

  end  #Final config end.
