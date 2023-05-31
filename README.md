# VagrantK8S Cluster for testing out Rancher

This folder contains the infrastructure needed for testing and developing an automated setup of a Rancher kubernetes cluster.

## Design

This setup will spin up 3 control plane nodes a linux and a windows worker, using RKE2 from the stable channel.

This setup is based on Ubuntu 2204 or Rocky Linux 9.x. You decide which distributions to use by going to either the Ubuntu or Rocky Linux folder and running `vagrant up`.  Currently there are issues with the Rocky Linux installation, so use the Ubuntu one for testing.


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

It is technically possible to add windows workers to the cluster built here, and it is included in the Vagrantfile, **but it is not currently supported and there are no guarantees this setup will run**
Thisfeature  will be tested and fixed in future versions.

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
