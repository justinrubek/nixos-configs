terraform {
  cloud {
    organization = "justinrubek"

    workspaces {
      name = "vault"
    }
  }

  required_providers {
    vault = {
      version = "3.11.0"
    }
    consul = {
      version = "2.16.2"
    }
    sops = {
      source = "carlpett/sops"
      version = "0.7.1"
    }
  }

  required_version = ">= 1.0"
}