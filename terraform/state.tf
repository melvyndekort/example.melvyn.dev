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
    workspaces = {
      name = "cloudsetup"
    }
  }
}
