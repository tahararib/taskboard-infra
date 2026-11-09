# iac/opentofu/namespace-recette.tf — ILLUSTRATIF (démo MG708, lecture seule en séance).
# Décrit un environnement « recette » : namespace étiqueté + quota de ressources.
# Sera câblé au job infra-plan-apply par la passe Avancé (atelier 2).
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

resource "kubernetes_namespace" "recette" {
  metadata {
    name = "recette"
    labels = {
      environnement = "recette"
      gere-par      = "opentofu"
    }
  }
}

resource "kubernetes_resource_quota" "recette" {
  metadata {
    name      = "quota-recette"
    namespace = kubernetes_namespace.recette.metadata[0].name
  }
  spec {
    hard = {
      "requests.cpu"    = "2"
      "requests.memory" = "2Gi"
      "pods"            = "10"
    }
  }
}
