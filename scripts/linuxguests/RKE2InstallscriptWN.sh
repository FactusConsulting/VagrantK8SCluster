curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE="agent" sh -

sudo systemctl enable rke2-agent.service
sudo systemctl start rke2-agent.service

sudo ln -s /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
echo 'export KUBECONFIG="/home/vagrant/.kube/config"' >> ~/.bashrc
echo "alias k='kubectl'" >> ~/.bashrc
sudo cp -i /etc/rancher/rke2/rke2.yaml /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config
