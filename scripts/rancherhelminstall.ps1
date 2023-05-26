helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo add jetstack https://charts.jetstack.io --kubeconfig='kube_config_cluster.yml'
helm repo update


#####  We need cert manager #########
# If you have installed the CRDs manually instead of with the `--set installCRDs=true` option added to your Helm install command, you should upgrade your CRD resources before upgrading the Helm chart:
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml --kubeconfig='kube_config_cluster.yml'
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.7.1  --kubeconfig='kube_config_cluster.yml'
#### CERT MANAGER END


## Rancher
#Add the zscaler root certificate
kubectl create namespace cattle-system --kubeconfig='kube_config_cluster.yml'
kubectl -n cattle-system create secret generic tls-ca-additional --from-file=ca-additional.pem=./ca-additional.pem --kubeconfig='kube_config_cluster.yml'

# --set additionalTrustedCAs=true makes the rancher pod look for the secret created above.
helm install rancher rancher-stable/rancher --namespace cattle-system  --set additionalTrustedCAs=true --set hostname=rancher --set bootstrapPassword=admin --set replicas=1 --kubeconfig='kube_config_cluster.yml'

helm uninstall rancher --namespace cattle-system --kubeconfig='kube_config_cluster.yml'



k get node --kubeconfig='kube_config_cluster.yml'