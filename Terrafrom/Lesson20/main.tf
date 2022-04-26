#------------------------------
# Task: Using Google Provider
# 
# Created by Kevin Shindel
#------------------------------

variable "google_creds" {
  default = "~/google-credential-key.json"
  type = string
  description = "Google Credentials path"
}

provider "google" {
  credentials = file(var.google_creds)
  project = "quickstart-1567428720926"
  region = "us-west1"
  zone = "us-west1-b"
}

resource "google_compute_instance" "server" {
  name = "my-gcp-server"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    network = "default"
  }

}

