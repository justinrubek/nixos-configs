terraform {
  cloud {
    organization = "justinrubek"
    hostname = "app.terraform.io"

    workspaces {
      name = "dns"
    }
  }

  required_providers {
    porkbun = {
      source = "cullenmcdermott/porkbun"
      version = "0.1.2"
    }
    vault = {
      source = "hashicorp/vault"
      version = "3.11.0"
    }
  }

  required_version = "~>1.6.0"
}
