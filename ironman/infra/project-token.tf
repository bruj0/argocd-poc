resource "argocd_project_token" "ironman" {
  project      = argocd_project.ironman.id
  role         = "argocd-dna"
  description  = "token for DNA"
  #expires_in   = "1h"
  #renew_before = "30m"
}

output "ironman-project-token" {
    value = argocd_project_token.ironman
    sensitive = true
}