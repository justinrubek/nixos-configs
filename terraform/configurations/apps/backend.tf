terraform {
  cloud {
    organization = "justinrubek"
    hostname = "app.terraform.io"

    workspaces {
      name = "apps"
    }
  }

  required_providers {
    nomad = {
      source = "hashicorp/nomad"
      version = "1.4.19"
    }
  }

  required_version = "1.6.0"
}
