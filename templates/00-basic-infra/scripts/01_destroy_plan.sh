# terraform needs state to manage infra
# if no local or remote state stored, it'll refresh state first & keep it in memory
# not gonna perform the action with plan

# can specifiy -out parameter to save plan and apply later
cd prod
terraform plan -destroy -out=destroy.plan
terraform show destroy.plan
terraform apply destroy.plan