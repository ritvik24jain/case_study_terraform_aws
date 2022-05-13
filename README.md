# Case study elasticbeanstalk with custom vpc
## Prerequisite:
 1. Create a role with any name that should be assumed by the user of account
 2. the role should have permission on Ec2, elasticbeanstalk, Cloudformation, S3, iam.
 3. To store the state file infomation in s3 with versioning enabled, please create bucket.
 4. for locking create a dynamodb table 
 5. Prepare the terraform.tfvars file and keep in root directory, with below content:
    ```
    vpc_cidr = "10.0.0.0/24"
    private_subnet_cidrs=["10.0.0.0/27", "10.0.0.32/27"]
    public_subnet_cidrs=["10.0.0.64/27", "10.0.0.96/27"]
    vpc_name=<vpc_name>
    region = <region>
    account_id=<replace the account in which the role that need to be assumed exists>
    role_name = <step 1 role name>
    ```

 ## Run the terraform command to create the infra
1. Run terraform init

```terraform init -backend-config=bucket=<bucket-name in step 3(prerequisite)> -backend-config=key=<key-name> -backend-config=region=<aws-region> -backend-config=dynamodb_table=<dynamodbtable name created in step 4(prerequisite)>```

2. Run terraform plan

```terraform plan```

3. Run terraform apply

```terraform apply -auto-approve```
