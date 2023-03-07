terraform {
  cloud {
    organization = "justinrubek"

    workspaces {
      name = "github"
    }
  }

  required_providers {
    github = {
      version = "5.18.0"
    }
  }

  required_version = ">= 1.0"
}
