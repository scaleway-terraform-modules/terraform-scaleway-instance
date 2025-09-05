terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.59"
    }
  }
  required_version = "~> 1.10"
}

provider "scaleway" {}
