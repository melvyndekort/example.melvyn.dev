terraform {
  required_version = "~> 1.6.0"

  backend "s3" {
    bucket = "mdekort.tfstate"
    key    = "example-melvyn-dev.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "useast1"
}

provider "cloudflare" {
  api_token = data.terraform_remote_state.cloudsetup.outputs.api_token_example
}
