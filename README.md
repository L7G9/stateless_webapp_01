# Stateless WebApp #1

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white) 
The 1st part a series of projects deploying a stateless webapp on AWS using Terraform.

---

This project launches an EC2 instance hosting a web page then creates and attaches an Elastic IP address to it. The aim is to learn Terraform and the AWS provider and attempt to implement best practices for structure, naming and variables. To learn more from the project instead of using defult the VPC and SG it creates its own. 
[Stateless WebApp #2](https://github.com/L7G9/stateless_webapp_02) and [Stateless WebApp #3](https://github.com/L7G9/stateless_webapp_03) are available.  

---

## Getting Started

### Disclaimer
This project attempts to stay within the AWS free tier as much as possible but any charges incurred while using are not the responsibility of the Author.

### Requirements
- [Terraform & AWS CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build)

Clone Github repository and move into project directory.
```bash
git clone https://github.com/L7G9/stateless_webapp_01.git
cd stateless_webapp_01
```

Update terraform.auto.tfvars file in a text editor with your own values.  
```
region            = "eu-west-2"
availability_zone = "eu-west-2a"
user_data_file    = "/files/user-data.sh"
```

Initialize the directory.
```bash
terraform init
```

Apply the configuration.
```bash
terraform apply
```

Copy the address from the outputs into web browser.
```bash
eip_address = "3.10.109.17"
```

Clean up.
```bash
terraform destroy
```

---

## Author
[@L7G9](https://www.github.com/L7G9)

---

## Acknowledgements
All these resources were used to create this project.  Thank you to all those who took the time and effort to share.
- [Udemy Ultimate AWS Certified Solutions Architect Associate SAA-C03](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/)
- [Terraform AWS getting started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build)
- [terraform-best-practices.com](https://www.terraform-best-practices.com/)
- [Best practices for using Terraform](https://cloud.google.com/docs/terraform/best-practices-for-terraform)
- [Building an AWS Terraform VPC Step-by-Step](https://adamtheautomator.com/terraform-vpc/)

---

