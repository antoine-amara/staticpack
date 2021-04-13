terraform {
  required_version = ">= 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.60.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "2.1.2"
    }
  }
}
