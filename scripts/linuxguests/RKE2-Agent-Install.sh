curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE="agent" sh -
sudo systemctl enable rke2-agent.service
sudo systemctl start rke2-agent.service