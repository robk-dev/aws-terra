cd prod
terraform apply -auto-approve
terraform state list
terraform show -json
terraform graph
# terraform destroy -auto-approve