terraform {
  required_providers {
    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.0.3"
    }
  }
}

provider "argocd" {
  # Configuration options
  use_local_config = true
}