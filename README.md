# VagrantK8SCluster

An opinionated Vagrant based setup for testing Kubernetes across Linux and Windows on Hyper-v

## Background

As a windows based developer doing windows docker, I missed having a setup where I could have a Kubernetes setup in Vagrant on top of Hyper-v, instead of having to juggle Hyper-v and Virtual Box.

As of now, the windows node is not automatically joined to the cluster. Work is ongoing to build a domain controller and join the windows node to the domain, to test windows based GMSA access to resources.

## Quick start

### Prerequisites

Run this on a windows 10 1709, windows server 2016 or later.
Install the Hyper-v feature
Install latest version of Vagrant (2.2.4 or later)

### Setup

Clone the repository and run these commands in a powershell admin prompt:

Host credentials are needed to share the root of the vagrant folder with the guest machines. This prompted once and set in an environment variable in the active session. Make sure to close the powershell session when the setup is complete to remove the variable.

`.\scripts\host\set-credentials.ps1`

This command creates a single Master, one linux worker node and one windows worker node. The linux node is automatically joined, while work is outstanding to get the windows node joined.

`vagrant up m1 ln1 wn1`

All machines will get an IP address in the 192.168.10.0 space.

|Machine type           |Machinenames  |IPAddress  |
|---------              |---------|---------|
| Master                |M1       |192.162.10.11|
| Linux worker node     |LN1      |192.162.10.21|
| Windows worker node  |WN1       |192.162.10.31|
| Windows Domain controller|DC    |192.162.10.40|

The Vagrant file supports 3 of each type of machine, and one domain controller for testing failover and scaling scenarios.

## Future features not yet implemented

* Domain controller setup and joining the windows nodes to the dc for testing GMSA based access from pods.
* More masters and joining masters as master nodes
* More automated and robust setup of Windows nodes
* When Virtual Box 6 on windows gets their hyper-v usage issues ironed out, this might be migrated to using Virtual Box.
* Migrate scripts from just raw scripts to using vagrant. Preferably vagrant running in a linux docker on windows with the microsoft/ansible container.