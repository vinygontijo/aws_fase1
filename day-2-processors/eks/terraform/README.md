```sh
## init terraform
terraform init

## see the execution plan
terraform plan

## apply the configs
terraform apply

## variables environment
aws eks list-clusters --region us-east-2
## output
owshq-eCIxr4Kq

## update kubeconfig context
aws eks --region us-east-2 update-kubeconfig --name owshq-eCIxr4Kq

## see default pods
kubectl get pods -A
```