curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE="agent" sh -

sudo systemctl enable rke2-agent.service
sudo systemctl start rke2-agent.service
sudo ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl


# sudo journalctl -u rke2-agent -f

# sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig=/etc/rancher/rke2/rke2.yaml
# sudo cat /var/lib/rancher/rke2/server/node-token
# sudo /var/lib/rancher/rke2/bin/crictl
# sudo /var/lib/rancher/rke2/bin/ctr