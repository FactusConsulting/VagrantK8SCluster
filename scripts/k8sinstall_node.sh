#!/usr/bin/env bash
sudo swapoff -a
sudo sysctl net.bridge.bridge-nf-call-iptables=1

. /vagrant/join_cmd.sh



