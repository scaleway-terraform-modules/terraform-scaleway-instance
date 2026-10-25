terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.79.0"
    }
  }
  required_version = ">= 1.11"
}

provider "scaleway" {}
