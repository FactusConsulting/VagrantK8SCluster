# VagrantK8S Cluster for testing out Rancher

This folder contains the infrastructure needed for testing and developing an automated setup of a Rancher kubernetes cluster.

## Design

This setup will spin up a control plane, install RKE kubernetes on there and install Rancher from a HELM chart.

Then it will deploy a new Rancher RKE kubernetes cluster across 1 Control PLane, 1 linux worker node and one windows 2019 worker node.

This setup is based on rocky linux 8.5, but can and should be tested on ubuntu 20.04 as well.

## Quick start

From a command prompt at the RancherDev folder, run:

```
vagrant up cp11
rke up
```
### Prerequisites

Install vagrant.   `choco install vagrant -y`
Install RKE for windows   `choco install rke -y`

### Setup and background

#### Abbreviations:
CP control plane nodes, LW  Linux worker nodes,  WW Windows Worker Nodes

#### Setup

`vagrant up`  will start all nodes

All machines will get an IP address in the 192.168.56.0 space.

|Machine type           |Machinenames  |IPAddress  |
|---------              |---------|---------|
| Rancher Server        |cp11       |192.168.56.11|
| Control Plane         |cp12    |192.168.56.12|
| Linux worker node     |lw21      |192.168.56.21|
| Windows worker node  |ww31       |192.168.56.31|

The Vagrant file supports 3 of each type of machine, and one domain controller for testing failover and scaling scenarios.

## RKE2 commands

```shell
curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_CHANNEL=latest sh -
vagrant scp cp11:~/rke2vagrantkubeconfig rke2vagrantkubeconfig
k9s --kubeconfig .\rke2vagrantkubeconfig

#Troubleshooting
sudo nano /etc/rancher/rke2/config.yaml
sudo journalctl -u rke2-server
sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig /etc/rancher/rke2/rke2.yaml
sudo /var/lib/rancher/rke2/bin/crictl -r unix:///var/run/k3s/containerd/containerd.sock
cat /var/lib/rancher/rke2/agent/logs/kubelet.log
sudo cat /var/lib/rancher/rke2/agent/containerd/containerd.log
cat /var/lib/rancher/rke2/agent/kubelet.kubeconfig
sudo cat /var/lib/rancher/rke2/agent/etc/containerd/config.toml

sudo /var/lib/rancher/rke2/bin/containerd config default
```


## Adding to Rancher

curl --insecure -sfL https://rd.local/v3/import/lfshmb22wprlrk7ltxmfrlbcrk2lp5jphqp8slzcxzms2fmrpr2jt9_c-m-7zg9kv2s.yaml | sudo /var/lib/rancher/rke2/bin/kubectl apply -f -  --kubeconfig /etc/rancher/rke2/rke2.yaml
 sudo /var/lib/rancher/rke2/bin/kubectl get deployment --all-namespaces --kubeconfig /etc/rancher/rke2/rke2.yaml
 sudo /var/lib/rancher/rke2/bin/kubectl edit deployment cattle-cluster-agent -n cattle-system --kubeconfig /etc/rancher/rke2/rke2.yaml

sudo /var/lib/rancher/rke2/bin/kubectl logs cattle-cluster-agent-7f86bff4cc-kkblv -n cattle-system --kubeconfig /etc/rancher/rke2/rke2.yaml


hostAliases:
  - ip: "172.23.4.7"
    hostnames:
    - "rd.local"