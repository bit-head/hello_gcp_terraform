provider "google" {
  credentials = file("idm-challenge-424101-08d15a1468a7.json")
  project     = "idm-challenge-424101"
  region      = "us-west1"
}

resource "null_resource" "firestore_data" {

  provisioner "local-exec" {
    command = "/usr/bin/env python3 insert_message_data.py"
  }

  depends_on = [google_project_service.firestore]
}

resource "google_project_service" "firestore" {
  service = "firestore.googleapis.com"
}

/*
resource "google_container_cluster" "gke_cluster" {
  name     = "hello-cluster"
  location = "us-west-1"

  node_pool {
    name       = "hello-pool"
    node_count = 3

    node_config {
      machine_type = "e2-medium"
    }
  }
}
*/

