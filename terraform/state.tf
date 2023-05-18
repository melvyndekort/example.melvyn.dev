terraform {
  backend "s3" {
    bucket     = "mdekort.tfstate"
    key        = "example-melvyn-dev.tfstate"
    region     = "eu-west-1"
    encrypt    = "true"
    kms_key_id = "arn:aws:kms:eu-west-1:075673041815:alias/generic"
  }
}

data "terraform_remote_state" "convert_jwt" {
  backend = "s3"

  config = {
    bucket = "mdekort.tfstate"
    key    = "convert-jwt.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "cloudsetup" {
  backend = "remote"

  config = {
    organization = "melvyndekort"
    workspaces   = {
      name = "cloudsetup"
    }
  }
}
