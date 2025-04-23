variable "remote_server_ip" {
  description = "The IP of the remote server"
}

variable "argo_password_hash" {
  description = "Admin password hash for argocd"
  type        = string
  sensitive   = true
}
