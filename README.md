# VagrantK8S Cluster for testing out Rancher

This folder contains the infrastructure needed for testing and developing an automated setup of a Rancher kubernetes cluster.

## Design

This setup will spin up 3 control plane nodes a linux and a windows worker, using RKE2 from the stable channel.

This setup is based on Ubuntu 2204 or Rocky Linux 9.x. You decide which distributions to use by going to either the Ubuntu or Rocky Linux folder and running `vagrant up`.  Currently there are issues with the Rocky Linux installation, so use the Ubuntu one for testing.

This vagrant file will automatically install and configure RKE2 from the stable release branch. If you want to try and cofigure RKE2 manually, go to the vagrant file and comment out `# ....` lines 65 and 89  `cp.vm.provision "shell", path: "../scripts/linuxguests/RKE2-Server-Install.sh"` as they will otherwise install and configure RKE2 for you.

If you just want a working cluster to play with ... leave them in there.  If you want to do it yourself ... run the commands from those scripts to spin up your cluster.

Happy clustering!!!

## Prerequisites

First you must install Vagrant version 2.3.4 and the latest version of Virtualbox. At time of writing this is 7.0.6 but anything later is fine

[Vagrant](https://developer.hashicorp.com/vagrant/downloads)  or `choco install vagrant -y --version 2.3.4`

[Virtualbox](https://www.virtualbox.org/) or `choco install virtualbox -y`

## Quick start

To start up just one of the control plane nodes:

1. From a command prompt at the Ubuntu folder, run:

    ```shell
    vagrant up cp11
    ```

    or if you are brave or have the computer resources on your laptop, start all three controlplane nodes with `vagrant up cp11 cp12 cp13`

2. To start and add a Linux worker and the Windows node run:

    ```shell
    vagrant up lw21
    ```

3. Windows workers

If you want to add a windows node, run  `vagrant up ww31` but ensure you have enough memory and cpu resources available.

## Detailed setup and background

### Abbreviations

CP is short for control plane nodes, LW  Linux worker nodes,  WW Windows Worker Nodes

### Setup

`vagrant up`  will start all nodes

All machines will get an IP address in the 192.168.56.0 space.

|Machine type           |Machinenames  |IPAddress  |
|---------              |---------|---------|
| Control plane 1        |cp11       |192.168.56.11|
| Control Plane 2        |cp12    |192.168.56.12|
| Control Plane 3        |cp13    |192.168.56.13|
| Linux worker node     |lw21      |192.168.56.21|
| Windows worker node  |ww31       |192.168.56.31|

### After startup

#### Hosts file changes

To access the nodes from your local pc, you need to put the following into your hosts file

```shell
  192.168.56.11 vagrantcluster
  192.168.56.11 cp11
  192.168.56.12 cp12
  192.168.56.13 cp13
  192.168.56.21 lw21
  192.168.56.31 ww31
```

#### Kubeconfig file

The kubeconfig file will be copied to the Ubuntu folder as rke2vagrantconfig
Run this command to set the kubeconfig to this file for this powershell session  `$env:KUBECONFIG="rke2vagrantkubeconfig"`

Try running kubectl get node and see if you can see the new nodes and wait a few minutes untill they report a ready state.
When you have nodes reporting ready, you have a running cluster.

### Testing the windows node

The windows worker starts up with a Windows 2022 base image, so all containers running on that needs to be windows 2022 containers as the container kernel must match the base image kernel major version.  Eg. 2019->2019 and 2022->2022
The container network defined in the Controlplane nodes have been set to Calico as this is the only RKE2 overlay network that supports Windows worker nodes.

After starting the windows node, to see if windows nodes has a working network setup, you can deploy the test webserver fround in the scripts/windowsguests folder. This deploys a simple webserver listening on a nodeport on the cluster.
Check the kubernetes service to get the nodeport. In this example  `default   win-webserver   NodePort   10.43.215.179  80►30744` the nodeport in use is `30744`.  So go to any node on the cluster and query port 30744 to get a response from the webserver.  Like this:   `http://cp11:30744`  or `http://192.168.56.31:30744`.  You should get a simple https response as defined in the deployment.

Be patient with the deployment. The size of Windows Server Core containers measure in the Gb's compared to linux containers. It will take a few minutes to pull down that container image on the windows node.

### Usefull RKE2 commands

```shell
curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_CHANNEL=latest sh -
vagrant scp cp11:~/rke2vagrantkubeconfig rke2vagrantkubeconfig
k9s --kubeconfig .\rke2vagrantkubeconfig

#Troubleshooting
sudo journalctl -u rke2-server   #get logs from the rke2 service
sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig /etc/rancher/rke2/rke2.yaml
sudo /var/lib/rancher/rke2/bin/crictl -r unix:///var/run/k3s/containerd/containerd.sock   # get lowlevel container logs from containerd
cat /var/lib/rancher/rke2/agent/logs/kubelet.log   # read the kubelet log from servers and agents
sudo cat /var/lib/rancher/rke2/agent/containerd/containerd.log      # Get the containerd log itself
cat /var/lib/rancher/rke2/agent/kubelet.kubeconfig      # check the kubelet config
sudo cat /var/lib/rancher/rke2/agent/etc/containerd/config.toml     # and the containerd config
sudo /var/lib/rancher/rke2/bin/containerd config default            # if you need to change containerd default config
```

Get the RKE vagrant kubeconfig if not using shared folders from vagrant

```shell
vagrant plugin install vagrant-scp
vagrant scp cp11:~/rke2vagrantkubeconfig rke2vagrantkubeconfig
``
