terraform {
  cloud {
    organization = "LukeGregory-dev"

    workspaces {
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
  region = var.region
}
