data "terraform_remote_state" "get_cookies" {
  backend = "s3"

  config = {
    bucket = "mdekort.tfstate"
    key    = "get-cookies.tfstate"
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
