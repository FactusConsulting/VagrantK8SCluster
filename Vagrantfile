# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider "hyperv" do |hv|
    hv.enable_virtualization_extensions = true
    hv.linked_clone = true
    hv.maxmemory = 6144
    hv.memory = 1024
    hv.cpus = 2
    hv.ip_address_timeout = 240
    hv.vm_integration_services = {
      guest_service_interface: true,  #<---------- this line enables Copy-VMFile
    }
  end

  config.vm.network "private_network", bridge: "Default Switch"
  config.vm.synced_folder ".", "/vagrant", disabled: false,  #Enable and set username pw if you dont want to get prompted for each machine up
                                           smb_password: ENV["PW"], smb_username: ENV["USERNAME"]
  # Masters
  (1..3).each do |number|
    config.vm.define "m#{number}" do |node|
      node.vm.box = "generic/ubuntu1804"
      node.vm.hostname = "m#{number}"
      config.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_m1#{number}"
      end
      # node.vm.provision "shell", path: "k8sinstall_all.sh", run: "once"
      # node.vm.provision "shell", path: "k8sinstall_master.sh", run: "once"

      node.trigger.after :up do |trigger|
        trigger.info = "Running after up scripts"
        trigger.run = { path: "scripts/create-hypervhostnetwork.ps1", args: "vagrantk8s_m1#{number}" }
        #Master nodes get IP address segments from 11 and up
        trigger.run_remote = { path: "scripts/configure-networking.sh", args: "1#{number}" }
      end
    end
  end

  # LinuxWorkers
  (1..3).each do |number|
    config.vm.define "ln#{number}" do |node|
      node.vm.box = "generic/ubuntu1804"
      node.vm.hostname = "ln#{number}"
      config.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_ln2#{number}"
      end

      #node.vm.provision "shell", path: "k8sinstall_all.sh", run: "once"
      #node.vm.provision "shell", path: "k8sinstall_node.sh", run: "once"

      node.trigger.after :up do |trigger|
        trigger.info = "Running after up scripts"
        trigger.run = { path: "scripts/create-hypervhostnetwork.ps1", args: "vagrantk8s_ln2#{number}" }
        #Linux nodes get IP address segments from 21 and up
        trigger.run_remote = { path: "scripts/configure-networking.sh", args: "2#{number}" }
      end
    end
  end

  # WindowsWorkers
  (1..3).each do |number|
    config.vm.define "wn#{number}" do |node|
      node.vm.box = "StefanScherer/windows_2019_docker"
      node.vm.boot_timeout = 4800   #Windows and winrm seems to be slower to respond.
      node.vm.communicator = "winrm"
      node.vm.hostname = "wn#{number}"
      config.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_wn3#{number}"
      end
      node.vm.provision "file", source: "WindowsServerNodeSetup.ps1", destination: "c:/temp/WindowsServerNodeSetup.ps1"
      node.vm.provision "file", source: "daemon.json", destination: "c:/programdata/docker/config/daemon.json"

      node.trigger.after :up do |trigger|
        trigger.info = "Running after up scripts"
        trigger.run = { path: "scripts/create-hypervhostnetwork.ps1", args: "vagrantk8s_wn3#{number}" }
        trigger.run_remote = { path: "scripts/create-hypervguestnetwork.ps1", args: "3#{number}" }  #Windows machines get IP address segments from 31 and up
      end
    end
  end

  # Domain Controller
  config.vm.define "dc" do |node|
    node.vm.box = "cdaf/WindowsServerDC"
    node.vm.boot_timeout = 4800
    node.vm.communicator = "winrm"
    config.vm.provider "hyperv" do |hv|
      hv.vmname = "vagrantk8s_DC"
    end
    # node.vm.hostname = "dc"
  end
end

#TODO:  set name of other servers in hostfile. Or set them up in the dc dns.
