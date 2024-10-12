terraform {
  cloud {
    organization = "justinrubek"
    hostname = "app.terraform.io"

    workspaces {
      name = "consul"
    }
  }

  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.11.0"
    }
    consul = {
      source = "hashicorp/consul"
      version = "2.20.0"
    }
    sops = {
      source = "carlpett/sops"
      version = "0.7.1"
    }
  }

  required_version = "~>1.8.0"
}
