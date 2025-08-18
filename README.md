Tech Test

This repo contains then code and terraform scripts for deploy the infrastructure and the code.

The terraform scripts has the followinf variables:

| Variable name      | Description        | Default value |
|--------------------|--------------------|---------------|
| region             | AWS region         | us-east-1     |
| access_key         | AWS access Key     |               |
| secret_key         | AWS secret Key     |               |
| vpc_cidr           | VPC CIDR Block     | 10.1.0.0/16   |
| subnet_public_cidr | Subnet CIDR Block  | 10.1.1.0/24   |
| subnet_private_cidr| Subnet CIDR Block  | 10.1.2.0/24   |

To run the scripts you must create a file called terraform.tfvars to change these variables, for example: 
```
access_key = <your AWS access key>
secret_key = <your AWS secret key>
vpc_cidr   = "10.1.0.0/16"
```