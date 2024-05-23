provider "google" {
  credentials = file("idm-challenge-424101-08d15a1468a7.json")
  project     = "idm-challenge-424101"
  region      = "us-west1-a"
}

resource "null_resource" "firestore_data" {

  provisioner "local-exec" {
    command = "/usr/bin/env python3 app/insert_message_data.py"
  }

  depends_on = [google_project_service.firestore]
}

resource "google_project_service" "firestore" {
  service = "firestore.googleapis.com"
}

resource "google_container_cluster" "hello_world" {
  name     = "hello-cluster"
  location = "us-west1-a"
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
          image = "us-west1-docker.pkg.dev/idm-challenge-424101/copelandorama/idm_hello_world:latest"
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
