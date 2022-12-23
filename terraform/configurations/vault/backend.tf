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
  }

  required_version = ">= 1.0"
}
