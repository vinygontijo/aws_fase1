# Amazon Day 3 Amazon Redshift

```sh
# terraform directory
cd day-3-serving/amazon-athena/terraform
```

change crawler delta tables s3 path and delta_connection physical_connection_requirements parameter values

```sh
# init terraform
terraform init

# see the execution plan
terraform plan

# When you run Terraform, it'll pick up the secrets automatically
terraform apply
```
