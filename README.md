# Stateless Web Application 01
## Deploy a stateless web application on to AWS using Terraform.  

This project launches an EC2 instance hosting a web page then creates and attaches a Elastic IP address to it. 
The aim is to learn Terraform and the AWS provider and attempt to implement best practices for structure, naming and variables. 
To learn more from the project instead of using defult the VPC and SG it creates its own.  

## Installation
AWS account & disclaimer
Terraform installation
Clone this repo

## Usage
Move into directory 
complete .auto.ftvars file
Terraform validate
Terraform apply
Output once completed will display the public IP address of the EIP attached to the EC2 instance. 
Enter http:// followed by the public IP address to view the web page on the instance.

## Lessons Learned

### Public Subnets
Unlike the default VPC some set up is required to give a Subnet on a user defined VPC it access to the Internet. 
A Route Table containing a route to the Internet Gateway must be accociated with the Subnet to do this. 

### Finding AMI names

## Credits
udemy course
Terraform best practices 
link subnet articles



## Licence

## Badges
