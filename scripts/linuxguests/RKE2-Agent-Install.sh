curl -sfL https://get.rke2.io | sudo INSTALL_RKE2_TYPE="agent" sh -

if grep -q 'Rocky Linux' /etc/os-release; then
  echo "This is a Rocky Linux machine."
  sudo cp -f /usr/share/rke2/rke2-cis-sysctl.conf /etc/sysctl.d/60-rke2-cis.conf
  sudo systemctl restart systemd-sysctl
else
  echo "This is not a Rocky Linux machine."
fi

sudo systemctl enable rke2-agent.service
sudo systemctl start rke2-agent.service