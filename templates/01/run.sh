terraform init
terraform apply -auto-approve
terraform state list
terraform show -json
terraform graph | grep -v -e 'meta' -e 'close' -e 's3' -e 'vpc' -e 'var'
terraform graph | grep -v -e 'meta' -e 'close' -e 's3' -e 'vpc'
terraform graph
terraform destroy