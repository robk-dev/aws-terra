terraform init
terraform plan
terraform apply
mkdir ~/.kube/
terraform output kubeconfig>~/.kube/config
kubectl version
terraform output config_map_aws_auth > configmap.yml
kubectl apply -f configmap.yml
kubectl get nodes -o wide
echo "create service account & install helm"