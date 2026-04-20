# High Availability 3-Tier Web Architecture on AWS with Terraform

This project provisions a production-grade, highly available 3-Tier Web Architecture on AWS using Terraform. It uses a fully modular structure so the architecture can be deployed repeatably across multiple environments (dev, prod, etc.) with minimal configuration changes.

![Architecture Diagram](terraform_3_tier_web_app_aws.png)

## Architecture Overview

The infrastructure is designed for fault tolerance and security, distributed across **two Availability Zones (us-east-1a, us-east-1b)**.

### 1. Presentation Tier (Public)
* **External Application Load Balancer (ALB):** Distributes incoming HTTP traffic from the internet across the web servers.
* **Web Servers (Apache on Port 80):** Hosted in private web subnets. They act as a secure reverse proxy, forwarding traffic to the Internal ALB.
* **NAT Gateways:** Two NAT Gateways (one per AZ) provide outbound internet access for private instances without exposing them to inbound traffic.

### 2. Application Tier (Private)
* **Internal Application Load Balancer (ALB):** Takes traffic from the Web Tier and distributes it across the App Servers.
* **Node.js App Servers (Port 3000):** Hosted in private subnets. They run the core application and maintain the database connection.
* **Security:** Locked down to accept traffic only from the Internal ALB Security Group.

### 3. Data Tier (Private)
* **RDS MySQL (Multi-AZ):** A primary database instance with a synchronous standby replica in a second AZ for automatic failover.
* **Security:** Locked down to accept connections only from the Application Tier Security Group.

## Key Features

* **Modular Architecture:** Each infrastructure concern (networking, compute, database, etc.) is a self-contained Terraform module, making the stack repeatable across environments.
* **Keyless Access (SSM):** No SSH keys required. Instances are accessed securely via AWS Systems Manager Session Manager.
* **High Availability:** All layers (Web, App, DB, Network) are redundant across two Availability Zones.
* **Defense in Depth:** Security Group chaining ensures each tier only accepts traffic from the tier directly above it.
* **Dynamic Bootstrapping:** Terraform's `templatefile()` injects live infrastructure endpoints (Internal ALB DNS, RDS address) into EC2 user data scripts at apply time.
* **WAF Protection:** AWS WAF WebACL with managed rule groups (OWASP Common, SQLi, Known Bad Inputs, IP Reputation) attached to the external ALB.
* **Observability:** CloudWatch log groups, CPU-based scaling alarms, and SNS email notifications per environment.

## Prerequisites

* **Terraform:** v1.0+ installed locally.
* **AWS CLI:** Configured with valid credentials (`aws configure`).
* An SSH Key Pair is **not** required — access is managed via AWS SSM.

## Project Structure

```
terraform_3_tier_web_app_aws/
├── modules/
│   ├── networking/       # VPC, subnets, IGW, NAT gateways, route tables
│   ├── iam/              # SSM IAM role, policies, instance profile
│   ├── security_groups/  # All security groups and chained rules
│   ├── database/         # RDS MySQL instance and Secrets Manager entry
│   ├── load_balancing/   # External and internal ALBs, target groups, listeners
│   ├── compute/          # Web and app launch templates, ASGs, userdata scripts
│   ├── monitoring/       # CloudWatch logs, SNS, alarms, autoscaling policies
│   └── waf/              # WAF WebACL, logging, ALB association
└── environments/
    └── dev/              # Dev environment: main.tf, variables.tf, terraform.tfvars
```

Each module has three files:
* `main.tf` — resource definitions
* `variables.tf` — input variables
* `outputs.tf` — values exposed to the calling environment

## Deployment Instructions

All commands are run from the target environment directory.

**1. Navigate to the environment**
```bash
cd environments/dev
```

**2. Initialize Terraform**
```bash
terraform init
```

**3. Set the database password**

The `db_password` variable is sensitive and intentionally has no default. Pass it via an environment variable to avoid it appearing in shell history:
```bash
export TF_VAR_db_password="YourSecurePassword123"
```

**4. Update `terraform.tfvars`**

Edit [environments/dev/terraform.tfvars](environments/dev/terraform.tfvars) and set:
```hcl
alert_email = "your-email@example.com"
```

**5. Plan**
```bash
terraform plan
```

**6. Apply**
```bash
terraform apply
```

## Adding a New Environment

To deploy a `prod` environment using the same modules:

1. Copy the dev environment folder:
   ```bash
   cp -r environments/dev environments/prod
   ```
2. Update `environments/prod/terraform.tfvars` with prod-specific values (different CIDRs, larger instance counts, alert email, etc.).
3. Run `terraform init && terraform apply` from `environments/prod/`.

The modules are shared — no module code needs to change between environments.

## Security Notes

* `db_password` should never be committed to source control. Use `TF_VAR_db_password` or a secrets backend (e.g. AWS Secrets Manager, Terraform Cloud variable sets).
* `terraform.tfvars` contains non-sensitive defaults only. Add `terraform.tfvars` to `.gitignore` if it ever holds secrets.
* The RDS password is automatically stored in AWS Secrets Manager under `{environment}/db_credentials` by the database module, so application servers retrieve it at runtime rather than having it baked into AMIs.
