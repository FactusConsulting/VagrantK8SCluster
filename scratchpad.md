
Get the RKE vagrant kubeconfig
vagrant plugin install vagrant-scp
vagrant scp cp11:~/rke2vagrantkubeconfig rke2vagrantkubeconfig








# Docker

curl https://releases.rancher.com/install-docker/20.10.sh | sh
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
sudo reboot


?????
sudo modprobe ip_tables
sudo echo 'ip_tables' >> /etc/modules-load.d/rancher.conf
sudo reboot


docker run -d --restart=unless-stopped \
  --name rancher-server \
  -p 8080:80 -p 8443:443 \
  -v /opt/rancher:/var/lib/rancher \
  -e AUDIT_LEVEL=1 \
  --privileged \
  rancher/rancher:stable


docker run -d --restart=unless-stopped \
  --name rancher-server \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:stable


docker run -d --restart=unless-stopped \
  --name rancher-server \
  -p 80:80 -p 443:443 \
  -v /opt/rancher:/var/lib/rancher \
  -e AUDIT_LEVEL=1 \
  --privileged \
  rancher/rancher


  docker run -d --restart=unless-stopped \
  --name rancher-server \
  -p 8080:80 -p 8443:443 \
  -e AUDIT_LEVEL=1 \
  -e CATTLE_SYSTEM_CATALOG=bundled  \
  --privileged \
  rancher/rancher:stable


# Version v2.4.9

  sudo docker run -d --restart=unless-stopped   --name rancher-server   -p 8080:80 -p 8443:443   -e AUDIT_LEVEL=1   -e CATTLE_SYSTEM_CATALOG=bundled    --privileged   rancher/rancher:v2.4.1

  https://stackoverflow.com/questions/49822594/vagrant-how-to-specify-the-disk-size

  https://www.cyberithub.com/how-to-install-and-use-snapd-on-rhel-centos-7-8-using-10-easy-steps/

  https://ubuntu.com/tutorials/getting-started-with-kubernetes-ha#3-install-microk8s



echo 'net.bridge.bridge-nf-call-iptables=1' | sudo tee -a /etc/sysctl.conf










IPTABLES

sudo modprobe iptable-nat