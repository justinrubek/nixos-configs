terraform {
  cloud {
    organization = "justinrubek"

    workspaces {
      name = "github"
    }
  }

  required_providers {
    nomad = {
      version = "1.4.19"
    }
  }

  required_version = ">= 1.0"
}
