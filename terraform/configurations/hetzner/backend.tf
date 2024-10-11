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
    minio = {
      source  = "aminueza/minio"
      version = "2.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }

  required_version = "~>1.8.0"
}
