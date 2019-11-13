terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.38, <4.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.38, <4.0.0"
    }
  }
  required_version = ">= 0.13"
}
