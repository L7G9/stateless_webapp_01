terraform {
  cloud {
    # variable
    organization = "LukeGregory-dev"
    workspaces {
      #variable
      name = "swa-01"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  # variable
  region = "eu-west-2"
}
