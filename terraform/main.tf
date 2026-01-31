resource "google_storage_bucket" "gcp_bucket" {
  name = "${var.project_id}-airflow-bucket"
  location = var.location
  storage_class = "STANDARD"
  uniform_bucket_level_access = true 


  lifecycle_rule {
    condition {
      age = 1
    }
    action { 
      type = "AbortMultipartUpload"
  }
}
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "airflow_dataset"
  description = "GCP dataset"
  location  = var.location
}

resource "google_compute_instance" "compute_instance" {
  name         = "airflow-instance"
  machine_type = "n2-standard-4"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      disk_size_gb = 50

    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
}
