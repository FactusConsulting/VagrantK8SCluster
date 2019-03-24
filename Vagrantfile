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

  config.vagrant.plugins = ["vagrant-host-shell", "vagrant-reload"]
  config.vagrant.sensitive = ["Sharepassword", ENV["PW"]]
  config.vm.network "private_network", bridge: "Default Switch"

  config.vm.synced_folder ".", "/vagrant", type: "smb",
                                           disabled: false,  #Enable and set username pw if you dont want to get prompted for each machine up
                                           smb_password: ENV["PW"],
                                           smb_username: ENV["USERNAME"],
                                           mount_options: ["vers=3.0"]

  config.trigger.before [:up, :reload] do |trigger|
    trigger.info = "Checking share creds are set"
    trigger.run = { path: "scripts/host/check-sharedcredentials.ps1" }
    trigger.on_error = :halt
  end
  config.trigger.before [:up, :reload] do |trigger|
    trigger.info = "Configuring Hyperv host network"
    trigger.run = { path: "scripts/host/create-hypervhostnetwork.ps1" }
  end

  # Masters
  (1..3).each do |number|
    config.vm.define "m#{number}" do |node|
      node.vm.box = "generic/ubuntu1804"
      node.vm.hostname = "m#{number}"
      node.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_m1#{number}"
      end

      config.trigger.after [:up, :reload] do |trigger|
        trigger.info = "Setting IPFixed to VagrantNatNetwork switch"
        trigger.run = { path: "scripts/host/Set-FixedIpVMSwitch.ps1", args: "vagrantk8s_m1#{number}" }
        trigger.only_on = "m#{number}"
      end

      config.trigger.after [:destroy] do |trigger|
        trigger.info = "Removing kubeconfig and join_cmd.sh leftover files"
        trigger.run = { inline: "remove-item -path kubeconfig,join_cmd.sh -InformationAction SilentlyContinue -ErrorAction Ignore" }
        trigger.only_on = "m#{number}"
        trigger.exit_codes = [0, 1]
      end

      node.vm.provision :host_shell do |host_shell|
        host_shell.abort_on_nonzero = true
        host_shell.inline = "powershell.exe -noprofile -file scripts/host/add-vmnetcard.ps1 vagrantk8s_m1#{number}"
      end
      node.vm.provision "copy_netplanfiletovagrant", type: "file", source: "resources/networkconfig/1#{number}-01-netcfg.yaml", destination: "01-netcfg.yaml", run: "once"
      node.vm.provision "configure_guestnetwork", type: "shell", path: "scripts/linuxguests/configure-guestnetwork.sh", args: "#{ENV["USERNAME"]} #{ENV["PW"]} >> provision.log 2>&1", run: "once", sensitive: true
      node.vm.provision "k8sinstall_all", type: "shell", path: "scripts/linuxguests/k8sinstall_all.sh", args: ">> provision.log 2>&1", run: "once"
      node.vm.provision :reload, run: "once"
      node.vm.provision "k8sinstall_master", type: "shell", path: "scripts/linuxguests/k8sinstall_master.sh", args: ">> provision.log 2>&1", run: "once"
    end
  end

  # LinuxWorkers
  (1..3).each do |number|
    config.vm.define "ln#{number}" do |node|
      node.vm.box = "generic/ubuntu1804"
      node.vm.hostname = "ln#{number}"
      node.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_ln2#{number}"
      end

      config.trigger.after [:up, :reload] do |trigger|
        trigger.info = "Setting FixedIp to VagrantNatNetwork switch"
        trigger.run = { path: "scripts/host/Set-FixedIpVMSwitch.ps1", args: "vagrantk8s_ln2#{number}" }
        trigger.only_on = "ln#{number}"
      end
      node.vm.provision :host_shell do |host_shell|
        host_shell.abort_on_nonzero = true
        host_shell.inline = "powershell.exe -noprofile -file scripts/host/add-vmnetcard.ps1 vagrantk8s_ln2#{number}"
        run = "once"
      end
      node.vm.provision "copy_netplanfiletovagrant", type: "file", source: "resources/networkconfig/2#{number}-01-netcfg.yaml", destination: "01-netcfg.yaml", run: "once"
      node.vm.provision "configure_guestnetwork", type: "shell", path: "scripts/linuxguests/configure-guestnetwork.sh", args: "#{ENV["USERNAME"]} #{ENV["PW"]} >> provision.log 2>&1", run: "once", sensitive: true
      node.vm.provision "k8sinstall_all", type: "shell", path: "scripts/linuxguests/k8sinstall_all.sh", args: ">> provision.log 2>&1", run: "once"
      node.vm.provision :reload, run: "once"
      node.vm.provision "k8sinstall_linuxnode", type: "shell", path: "scripts/linuxguests/k8sinstall_node.sh", args: ">> provision.log 2>&1", privileged: true, run: "once"
    end
  end

  # WindowsWorkers
  (1..3).each do |number|
    config.vm.define "wn#{number}" do |node|
      node.vm.box = "StefanScherer/windows_2019_docker"
      node.vm.communicator = "winrm"
      node.vm.guest = "windows"
      node.vm.hostname = "wn#{number}"
      node.vm.provider "hyperv" do |hv|
        hv.vmname = "vagrantk8s_wn3#{number}"
      end

      config.trigger.after [:up, :reload] do |trigger|
        trigger.info = "Setting FixedIp to VagrantNatNetwork switch"
        trigger.run = { path: "scripts/host/Set-FixedIpVMSwitch.ps1", args: "vagrantk8s_wn3#{number}" }
        trigger.only_on = "wn#{number}"
      end
      node.vm.provision :host_shell do |host_shell|
        host_shell.abort_on_nonzero = true
        host_shell.inline = "powershell.exe -noprofile -file scripts/host/add-vmnetcard.ps1 vagrantk8s_wn3#{number}"
        run = "once"
      end
      node.vm.provision "config_guestnetwork", type: "shell", path: "scripts/windowsguests/configure-guestnetwork.ps1", args: "3#{number} -verbose", run: "once"
      node.vm.provision "config_windowsnode", type: "shell", path: "scripts/windowsguests/WindowsServerNodeSetup.ps1", args: "#{ENV["USERNAME"]} #{ENV["PW"]}", run: "once", sensitive: true
      node.vm.provision :host_shell do |host_shell|
        host_shell.abort_on_nonzero = true
        host_shell.inline = "powershell.exe -noprofile -command {Restart-VM -Name vagrantk8s_wn3#{number} -Confirm:$false -Wait -Force}"
      end
    end
  end

  # Domain Controller
  config.vm.define "dc" do |node|
    # node.vm.box = "cdaf/WindowsServerDC"
    node.vm.box = "StefanScherer/windows_2019"
    node.vm.network "private_network", bridge: "Default Switch"
    node.vm.boot_timeout = 4800
    node.vm.communicator = "winrm"
    node.vm.hostname = "dc"
    node.vm.provider "hyperv" do |hv|
      hv.vmname = "vagrantk8s_DC"
    end
    # node.vm.hostname = "dc"

    node.trigger.after :up,
      name: "create hyperv host network",
      info: "create hyperv  host network",
      run: { path: "scripts/host/create-hypervhostnetwork.ps1", args: "vagrantk8s_dc" }

    node.trigger.after :up,
      name: "Running after up scripts",
      info: "Running after up scripts",
      run_remote: { path: "scripts/windowsguests/WindowsServerNodeSetup.ps1", args: "40" }
  end
end

#TODO:  set name of other servers in hostfile. Or set them up in the dc dns.
#TODO:  dns for dc?
#TODO:  enroll windows servers in domain
