
###### BLUE GREEN deployment #####
locals {
  traffic_dist_map = {
    blue = {
      blue  = 100
      green = 0
    }
    blue-90 = {
      blue  = 90
      green = 10
    }
    split = {
      blue  = 50
      green = 50
    }
    green-90 = {
      blue  = 10
      green = 90
    }
    green = {
      blue  = 0
      green = 100
    }
  }
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
  default     = "blue" # Set a default value that matches a key in the traffic_dist_map
}
variable "enable_green_env" {
  description = "Enable green environment"
  type        = bool
  default     = yes
}

variable "green_instance_count" {
  description = "Number of instances in green environment"
  type        = number
  default     = 2
}
variable "enable_blue_env" {
  description = "Enable blue environment"
  type        = bool
  #OJO AQUI PARA HABILITAR EL DEPLOYMENT BLUE GREEN
  default = yes
}
variable "blue_instance_count" {
  description = "Number of instances in blue environment"
  type        = number
  default     = 3
}

###### Key pair #####
variable "key_pair_name" {
  description = "The name of the key pair to use for the EC2 instances"
  type        = string
  default     = "keys/la_maldita_llave"
}
variable "public_key_file" {
  description = "Path to the public key file"
  type        = string
  default     = "keys/la_maldita_llave.pub"
}
variable "private_key_file" {
  description = "Path to the private key file"
  type        = string
  default     = "keys/la_maldita_llave.pem"
}

variable "instance_name_prefix" {
  description = "Prefix for the instance name"
  type        = string
  default     = "frontend"
}
variable "instance_count_bootstrap" {
  description = "Number of instances to create at bo"
  type        = number
  default     = 1
}
variable "instance_count_autoscaling" {
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

