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

  config.trigger.before [:up, :reload, :resume] do |trigger|
    trigger.info = "Running before up scripts"
    trigger.run = { path: "scripts/create-hypervhostnetwork.ps1" }
  end

  config.vm.network "private_network", bridge: "Default Switch"

  # Currently disabled due to problems on laptops with wwan adapters.
  config.vm.synced_folder ".", "/vagrant", type: "smb",
                                           disabled: true,  #Enable and set username pw if you dont want to get prompted for each machine up
                                           smb_password: ENV["PW"],
                                           smb_username: ENV["USERNAME"],
                                           mount_options: ["vers=3.0"]
  # Masters
  (1..3).each do |number|
    config.vm.define "m#{number}" do |node|
      node.vm.box = "bento/ubuntu-18.04"
      node.vm.hostname = "m#{number}"
      config.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_m1#{number}"
      end

      config.vm.provision :host_shell do |host_shell|
        host_shell.abort_on_nonzero = true
        host_shell.inline = "powershell.exe scripts/add-vmnetcard.ps1 vagrantk8s_m1#{number}"
      end
      node.vm.provision "copy_netplanfiletovagrant", type: "file", source: "scripts/networkconfig/1#{number}-01-netcfg.yaml", destination: "01-netcfg.yaml", run: "once"
      node.vm.provision "configure_guestnetwork", type: "shell", path: "scripts/configure-guestnetwork.sh", args: "#{ENV["USERNAME"]}, #{ENV["PW"]}", run: "always"
      node.vm.provision "k8sinstall_all", type: "shell", path: "scripts/k8sinstall_all.sh", run: "once"
      node.vm.provision "k8sinstall_master", type: "shell", path: "scripts/k8sinstall_master.sh", run: "never"
    end
  end

  # LinuxWorkers
  (1..3).each do |number|
    config.vm.define "ln#{number}" do |node|
      node.vm.box = "bento/ubuntu-18.04"
      node.vm.hostname = "ln#{number}"
      config.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_ln2#{number}"
      end

      config.vm.provision :host_shell do |host_shell|
        host_shell.abort_on_nonzero = true
        host_shell.inline = "powershell.exe scripts/add-vmnetcard.ps1 vagrantk8s_ln2#{number}"
      end
      node.vm.provision "copy_netplanfiletovagrant", type: "file", source: "scripts/networkconfig/2#{number}-01-netcfg.yaml", destination: "01-netcfg.yaml", run: "never"
      node.vm.provision "configure_guestnetwork", type: "shell", path: "scripts/configure-guestnetwork.sh", args: "#{ENV["USERNAME"]}, #{ENV["PW"]}", run: "never", sensitive: true
      node.vm.provision "k8sinstall_all", type: "shell", path: "scripts/k8sinstall_all.sh", run: "never"
      node.vm.provision "k8sinstall_linuxnode", type: "shell", path: "scripts/k8sinstall_node.sh", run: "never"
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

      config.vm.provision :host_shell do |host_shell|
        host_shell.abort_on_nonzero = true
        host_shell.inline = "powershell.exe scripts/create-hypervhostnetwork.ps1 vagrantk8s_wn3#{number}"
      end
      node.vm.provision "config_windowsclient", type: "file", source: "scripts/WindowsServerNodeSetup.ps1", destination: "c:/temp/WindowsServerNodeSetup.ps1"
      node.vm.provision "copy_daemon.json", type: "file", source: "daemon.json", destination: "c:/programdata/docker/config/daemon.json"
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

    node.trigger.after :up,
      name: "create hyperv host network",
      info: "create hyperv  host network",
      run: { path: "scripts/create-hypervhostnetwork.ps1", args: "vagrantk8s_dc" }

    node.trigger.after :up,
      name: "Running after up scripts",
      info: "Running after up scripts",
      run_remote: { path: "scripts/WindowsServerNodeSetup.ps1", args: "40" }
  end
end

#TODO:  set name of other servers in hostfile. Or set them up in the dc dns.
#TODO:  dns for dc?
#TODO:  enroll windows servers in domain
