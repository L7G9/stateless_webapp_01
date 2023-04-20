variable "name_tag" {
  type        = string
  description = "Value of AWS Name tag to give all resources created by this project"
  default     = "stateless_webapp_01"
}

variable "region" {
  type        = string
  description = "AWS region defined in main.tf"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone of subnet defined in network.tf"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr block defined in network.tf"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "Subnet cidr block defined in netowrk.tf"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  type        = string
  description = "Instance type for web app server defined in instance.tf"
  default     = "t2.micro"
}

variable "user_data_file" {
  type        = string
  description = "File path for user data of web app server defined in instance.tf"
}
