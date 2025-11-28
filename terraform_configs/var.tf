
variable "aws_region" {   
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
  
}

variable "availability_zones" {    
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a"]
  
}

variable "ec2_ami" {    
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2 AMI in us-east-1
  
}

variable "key_name" {    
  description = "The name of the key pair"
  type        = string
  default     = "my-key-pair"
  
}

variable "environment" {    
  description = "The environment for the resources"
  type        = string
  default     = "dev"
  
}

variable "vpc_id" {    
  description = "The VPC for the resources"
  type        = string
  default     = "main-vpc"
  
}

# Defining CIDR blocks for VPCs
variable "vpc_cidrs" {
  description = "List of CIDR blocks for the VPCs"
  type        = list(string)
  default     = "10.0.0.0/16"
}

# Defining CIDR Block for 1st Subnet 
variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Defining CIDR Block for 2nd Subnet
variable "subnet_cidr_2" {
  description = "CIDR block for the second subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Defining CIDR Block for 3rd Subnet
variable "subnet_cidr_3" {
  description = "CIDR block for the third subnet"
  type        = string
  default     = "10.0.3.0/24"
}

# Defining CIDR Block for 4th Subnet
variable "subnet_cidr_4" {  
  description = "CIDR block for the fourth subnet"
  type        = string
  default     = "10.0.4.0/24"
}

# Defining CIDR Block for 5th Subnet
variable "subnet_cidr_5" {  
  description = "CIDR block for the fifth subnet"
  type        = string
  default     = "10.0.5.0/24"
}  

# Defining CIDR Block for 6th Subnet
variable "subnet_cidr_6" {  
  description = "CIDR block for the sixth subnet"
  type        = string
  default     = "10.0.6.0/24"
}  

