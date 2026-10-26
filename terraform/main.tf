terraform {
  required_version = ">= 1.17.0, < 1.18.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

provider "docker" {}

resource "docker_compose" "renewgrid" {
  project_name      = "renewgrid-iac"
  project_directory = abspath("${path.module}/..")

  config_paths = [
    abspath("${path.module}/../compose.yaml")
  ]

  env_files = [
    abspath("${path.module}/../.env.compose")
  ]

  wait           = true
  wait_timeout   = "10m"
  remove_orphans = false
}

output "renewgrid_url" {
  description = "Local URL for the Terraform-managed RenewGrid application"
  value       = "http://127.0.0.1:8090"
}
