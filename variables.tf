variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "AWS access Key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret Key"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_public_cidr" {
  description = "Subnet CIDR Block"
  type        = string
  default     = "10.1.1.0/24"
}

variable "subnet_private_cidr" {
  description = "Subnet CIDR Block"
  type        = string
  default     = "10.1.2.0/24"
}