#!/usr/bin/env bash
sudo sysctl net.bridge.bridge-nf-call-iptables=1

echo "Running join as workernode command"
. /vagrant/join_cmd.sh



