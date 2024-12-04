###### Key pair #####
variable "key_pair_name" {
  description = "The name of the key pair to use for the EC2 instances"
  type        = string
  default     = "keys/las_llaves"
}
variable "public_key_file" {
  description = "Path to the public key file"
  type        = string
  default     = "keys/public-key-file.pub"
}
variable "private_key_file" {
  description = "Path to the private key file"
  type        = string
  default     = "keys/private-key-file.pem"
}
#variable "file_name" {
#  description = "Name of the key pair file"
#  type        = string
#  default     = "keyfile_default"
#}

variable "instance_name_prefix" {
  description = "Prefix for the instance name"
  type        = string
  default     = "webserverfrontend"
}
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

##### VPC CIDR Block
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC_cidr block"
  type        = string
}

####### Presentation Tier CIDR block 2 ####
variable "public-web-subnet-1-cidr" {
  default     = "10.0.1.0/24"
  description = "Public subnet 2 CIDR block"
  type        = string
}

variable "public-web-subnet-2-cidr" {
  default     = "10.0.2.0/24"
  description = "Public subnet 2 CIDR block"
  type        = string
}

####### App Tier CIDR block 1 ####
variable "private-app-subnet-1-cidr" {
  default     = "10.0.3.0/24"
  description = "Private subnet 1 CIDR block"
  type        = string
}

####### App Tier CIDR block 2 ####
variable "private-app-subnet-2-cidr" {
  default     = "10.0.4.0/24"
  description = "Private subnet 2 CIDR block"
  type        = string
}

####### DB Tier CIDR block 1 ####

variable "private-db-subnet-1-cidr" {
  default     = "10.0.5.0/24"
  description = "Private DB subnet 1 CIDR block"
  type        = string
}

####### DB Tier CIDR block 2 ####
variable "private-db-subnet-2-cidr" {
  default     = "10.0.6.0/24"
  description = "Private DB subnet 2 CIDR block"
  type        = string
}

####App Tier security group
variable "ssh-locate" {
  default     = "0.0.0.0/0"
  description = "IP address allowed to SSH"
  type        = string
}

###### DB Instance 
variable "db_instance_class" {
  default     = "db.t2.micro"
  description = "the  DataBase instance type"
  type        = string
}

### multi AZ 
variable "multi-az-deployment" {
  default     = "false"
  description = "Create a standby DB deployment"
  type        = bool
}

