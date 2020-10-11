cd prod
terraform validate
terraform apply -auto-approve
terraform state list
terraform show -json
terraform graph
terraform graph | grep -v -e 'meta' -e 'close' -e 's3' -e 'vpc'
terraform destroy