terraform {
  cloud {
    organization = "justinrubek"
    hostname = "app.terraform.io"

    workspaces {
      name = "hetzner"
    }
  }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.36.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }

  required_version = "1.6.0"
}
