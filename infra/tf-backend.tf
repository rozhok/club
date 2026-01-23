terraform {
  cloud {
    organization = "Devlify"

    workspaces {
      name = "club"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "devlify"
}
