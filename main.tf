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
