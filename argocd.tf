provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Create the 'argocd' namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name = "argocd"
  # create_namespace = true       - not using this because the ns does not get deleted on destroy. Using kubernetes provider instead.
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.23"

  values = [
    <<-EOT
    server:
      service:
        type: NodePort
    configs:
      secret:
        argocdServerAdminPassword: "${var.argo_password_hash}"
    EOT
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Get NodePort for ArgoCD Server
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }

  depends_on = [helm_release.argocd]
}

# Output the connection info
output "argocd_access_url" {
  description = "URL to access ArgoCD Web UI"
  value       = "http://${var.remote_server_ip}:${data.kubernetes_service.argocd_server.spec.0.port.0.node_port}"
}
