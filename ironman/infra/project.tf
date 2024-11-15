resource "argocd_project" "ironman" {
  metadata {
    name      = "ironman-project"
    namespace = "argocd"
    labels = {
      acceptance = "true"
    }
    annotations = {
      "team" = "DNA"
    }
  }

  spec {
    description = "Iron Project"

    source_namespaces = ["*"]
    source_repos      = ["https://github.com/bruj0/argocd-poc.git"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "ironman-ns"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }

    role {
      name = "argocd-dna"
      policies = [
        "p, proj:ironman-project:argocd-dna, applications, override, ironman-project/*, allow",
        "p, proj:ironman-project:argocd-dna, applications, sync, ironman-project/*, allow",
        "p, proj:ironman-project:argocd-dna, clusters, get, ironman-project/*, allow",
        "p, proj:ironman-project:argocd-dna, repositories, create, ironman-project/*, allow",
        "p, proj:ironman-project:argocd-dna, repositories, delete, ironman-project/*, allow",
        "p, proj:ironman-project:argocd-dna, repositories, update, ironman-project/*, allow",
        "p, proj:ironman-project:argocd-dna, logs, get, ironman-project/*, allow",
        "p, proj:ironman-project:argocd-dna, exec, create, ironman-project/*, allow",
      ]
    }
  }
}