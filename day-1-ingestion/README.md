# Amazon Day 1 Ingestion

Create Ingestion infrastructure on AWS with a lambda function to insert data into an MySQL RDS, an Data Migration Service to retrieve the data and write it to an S3 Bucket and a Kinesis Firehose to get CloudWatch Logs and write it to another S3 Bucket using terraform.

### Installing or updating the latest version of the AWS CLI
<https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>

## Linux

---

```sh
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

$ aws --version
$ aws-cli/2.4.27 Python/3.8.8 Linux/5.10.16.3-microsoft-standard-WSL2 exe/x86_64.ubuntu.20 prompt/off
```

## MacOS

### <https://formulae.brew.sh/formula/awscli>

---

```sh
brew install awscli
```

## Windows

---

### Download and run the AWS CLI MSI installer for Windows (64-bit)
<https://awscli.amazonaws.com/AWSCLIV2.msi>

---

## Alternatively, you can run the msiexec command to run the MSI installer

```sh
C:\> msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# To confirm the installation, open the Start menu, search for cmd to open a command prompt window, and at the command prompt use the aws --version command.
C:\> aws --version
aws-cli/2.4.5 Python/3.8.8 Windows/10 exe/AMD64 prompt/off
```

### After installing aws cli configure your login credentials and configure a profile

[Create Credentials Access Keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
---

```sh
$ aws configure --profile <profile_name>

AWS Access Key ID [None]: <access_key_id>
AWS Secret Access Key [None]: <secret_access_key>
Default region name [None]: <region_name>
Default output format [None]: <text/json>
```

```sh
$ cat ~/.aws/credentials

[<profile_name>]
aws_access_key_id = <access_key_id>
aws_secret_access_key = <secret_access_key>

$ cat ~/.aws/config

[profile <profile_name>]
region = <region_name>
output = <text/json>
```

## Specify the default profile (Linux & MacOS)

```sh
$ export AWS_PROFILE=<profile_name>
$ echo $AWS_PROFILE

# expected output
<profile_name>
```

## Specify the default profile (Windows)

```sh
$ Set-Variable -Name "AWS_PROFILE" -Value "<profile_name>"
$ Get-Variable -Name "AWS_PROFILE"
# expected output
Name                           Value
----                           -----
AWS_PROFILE                    <profile_name>
```

```sh
# working directory
cd trn-cc-bg-aws/day-1-ingestion

# create aws lambda
pip3 install -r functions/insert_into_mysql/requirements.txt -t lambda_layer/python
zip -r lambda_layer/python.zip lambda_layer/python

# delete folder python 
rm -rf lambda_layer/python

# terraform directory
cd terraform

# init terraform
terraform init

# see the execution plan
terraform plan

# When you run Terraform, it'll pick up the secrets automatically
terraform apply

# Variables for MySQL RDS Terraform
export TF_VAR_username="admin"
export TF_VAR_password="admin123"
```

