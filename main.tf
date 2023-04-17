terraform {
    cloud {
        organization = "LukeGregory-dev"
        workspaces {
            name = "aws-stateless-webapp"
        }
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "eu-west-2"
}

# Create a VPC
resource "aws_vpc" "stateless-webapp-vpc" {
    cidr_block = "10.0.0.0/16"
}
