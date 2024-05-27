provider "google" {
  credentials = file(var.google_creds)
  project     = "idm-challenge-424101"
  region      = var.location
}

resource "google_project_service" "firestore" {
  service = "firestore.googleapis.com"
}

resource "google_firestore_database" "default" {
  name        = "(default)"
  project     = google_project_service.firestore.project
  location_id = "us-west1"
  type        = "FIRESTORE_NATIVE"
  depends_on  = [google_project_service.firestore]
}

resource "null_resource" "firestore_data" {
  provisioner "local-exec" {
    command = "/usr/bin/env python3 local_exec/insert_message_data.py"
  }
  depends_on = [google_firestore_database.default]
}

resource "google_container_cluster" "hello_world" {
  name     = "hello-cluster"
  location = var.location
  deletion_protection = false

  node_pool {
    name       = "hello-pool"
    node_count = 3

    node_config {
      machine_type = "e2-medium"
    }
  }
}

provider "kubernetes" {
  host = "https://${google_container_cluster.hello_world.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.hello_world.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {}

resource "kubernetes_deployment" "hello-cluster" {
  metadata {
    name = "hello-app"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "hello-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-app"
        }
      }

      spec {
        container {
          image = "us-west1-docker.pkg.dev/idm-challenge-424101/copelandorama/demo_firestore:latest"
          name  = "hello-world"
          }
      }
    }
  }
}

resource "kubernetes_service" "hello-cluster" {
  metadata {
    name = "hello-app-service"
  }

  spec {
    selector = {
      app = "hello-app"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}

resource "google_project_service" "monitoring" {
  service = "monitoring.googleapis.com"
  disable_dependent_services=true  
}

output "public_ip" {
  value = kubernetes_service.hello-cluster.status.0.load_balancer.0.ingress.0.ip
}
