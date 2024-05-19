terraform {
  cloud {
    organization = "justinrubek"
    hostname = "app.terraform.io"

    workspaces {
      name = "github"
    }
  }

  required_providers {
    github = {
      source = "integrations/github"
      version = "5.42.0"
     
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.23.0"
     
    }
  }

  required_version = "~>1.7.0"
}
