terraform {
  cloud {
    organization = "justinrubek"

    workspaces {
      name = "consul"
    }
  }

  required_providers {
    vault = {
      version = "3.11.0"
    }
    consul = {
    }
    sops = {
      source = "carlpett/sops"
      version = "0.7.1"
    }
  }

  required_version = ">= 1.0"
}
