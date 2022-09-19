sudo curl -sfL https://get.rke2.io | sh -
cp ~/config.yaml /etc/rancher/rke2/config.yaml
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service


# sudo journalctl -u rke2-server -f

# sudo /var/lib/rancher/rke2/bin/kubectl get node --kubeconfig=/etc/rancher/rke2/rke2.yaml
# sudo cat /var/lib/rancher/rke2/server/node-token
# sudo /var/lib/rancher/rke2/bin/crictl
# sudo /var/lib/rancher/rke2/bin/ctr