# Amazon Day 2 Amazon Elastic Map Reduce

```sh
# terraform directory
cd day-2-processors/src/terraform

# init terraform
terraform init

# see the execution plan
terraform plan

# When you run Terraform, it'll pick up the secrets automatically
terraform apply

# working directory
cd ../../emr/

# create aws lambda
pip3 install -r functions/add-emr-step/requirements.txt -t lambda_layer/python
zip -r lambda_layer/python.zip lambda_layer/python

# delete folder python 
rm -rf lambda_layer/python

cd terraform

# init terraform
terraform init

# see the execution plan
terraform plan

# When you run Terraform, it'll pick up the secrets automatically
terraform apply

# remember create ssh key in management console
chmod 400 owshq-emr-key-777696598735.pem
ssh -i owshq-emr-key-777696598735.pem hadoop@18.119.14.91
```
