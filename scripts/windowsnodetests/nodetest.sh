wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/flannel/l2bridge/manifests/simpleweb.yml -O win-webserver.yaml
kubectl apply -f win-webserver.yaml



# see 2 containers per pod under docker ps command on the Windows node
sudo docker ps

# see 2 pods under a kubectl get pods command from the Linux master
kubectl get pods -o wide

# curl on the pod IPs on port 80 from the Linux master gets a web server response; this demonstrates proper node to pod communication across the network.
curl http://10.244.2.4
curl http://10.244.2.5

# ping between pods (including across hosts, if you have more than one Windows node) via docker exec; this demonstrates proper pod-to-pod communication
# ... missing test. How do I automate that ...

# curl the virtual service IP (seen under kubectl get services) from the Linux master and from individual pods; this demonstrates proper service to pod communication.
kubectl get services
curl http://10.100.239.73

# curl the service name with the Kubernetes default DNS suffix, demonstrating proper service discovery.
#https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#services
# ... Missing

# curl the NodePort from the Linux master or machines outside of the cluster; this demonstrates inbound connectivity.

# curl external IPs from inside the pod; this demonstrates outbound connectivity.




