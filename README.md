🚀 PROG8870 Final Project — AWS Infrastructure with Terraform & CloudFormation
This project provisions a basic AWS infrastructure using Terraform and includes CloudFormation templates as an alternative. The deployed services include:

✅ S3 Buckets

✅ EC2 Instance

✅ RDS (MySQL) Database

✅ VPC, Subnets, Internet Gateway, Route Tables, and Security Groups

📁 Folder Structure
bash
Final Project Cloud/
├── cloudformation/           # YAML files for optional CloudFormation templates
│   ├── ec2.yaml
│   ├── rds.yaml
│   └── s3.yaml
├── terraform/                # All Terraform configuration files
│   ├── main.tf               # Main infrastructure definition
│   ├── variables.tf          # All variable declarations
│   ├── terraform.tfvars      # Custom variable values (not committed)
│   ├── backend.tf            # Optional backend config
│   ├── outputs.tf            # Terraform output values(It's not in use)
│   ├── provider.tf           # AWS provider config
│   ├── .terraform.lock.hcl   # Provider dependency lock file
│   └── *.tfstate / backup    # State files (excluded from Git)
├── .gitignore
└── README.md

💡 What This Project Does
Creates 4 private S3 buckets with versioning enabled

Launches a VPC with two subnets (main & secondary)

Creates EC2 instance with SSH access via a security group

Sets up an RDS MySQL instance with proper subnet group and SG

Associates subnets with route tables & internet gateway

⚙️ How to Use the Terraform Code
1️⃣ Navigate to the Terraform directory
bash
cd terraform

2️⃣ Initialize Terraform
bash
terraform init

3️⃣ Preview the deployment plan
bash
terraform plan

4️⃣ Apply the configuration
bash
terraform apply

Enter yes when prompted.

🧾 Parameters Used from terraform.tfvars
This file contains values for sensitive and user-defined variables:

ami_id         = "ami-xxxxxxxx"         # AMI for EC2
instance_type  = "t2.micro"             # EC2 type
db_name        = "mydb"                 # RDS DB name
db_user        = "admin"                # RDS username
db_password    = "yourpassword"         # RDS password
project_suffix = "your-unique-id"       # Used for unique bucket naming
environment    = "dev"                  # Tag value

These values are stored securely in terraform.tfvars and excluded from version control via .gitignore.

🧾 Terraform Commands Used
Command	Purpose
terraform init	-Initialize provider and backend
terraform plan	-Review the changes to be applied
terraform apply	-Apply the changes to AWS infrastructure

🧱 CloudFormation Stack Details
1. S3 Stack
Stack name: s3-stack

Creates two private S3 buckets.

2. EC2 Stack
Stack name: ec2-stack

Creates a t2.micro instance

Uses key pair: final-project-key

3. RDS Stack
Stack name: rds-stack

Creates a MySQL database with:

Username: admin

Password: MySecurePassword123!

Allocated storage, instance class, and security group

## ☁️ Services Deployed

| Service | IaC Tool        | Description                                |
|--------|------------------|--------------------------------------------|
| S3     | CloudFormation   | Two private buckets                        |
| EC2    | CloudFormation   | t2.micro instance with key pair            |
| RDS    | CloudFormation   | MySQL DB instance with master credentials  |

🔒 Security & Access
Sensitive files like .tfvars, .terraform.lock.hcl, and terraform.tfstate are excluded via .gitignore.

EC2 key pairs are stored locally and not committed to GitHub.

RDS password meets AWS password policy.


📌 Author
Name: Archit Patel
Course: PROG8870 – Cloud Architectures and Infrastructure as Code
