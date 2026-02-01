resource "google_storage_bucket" "gcp_bucket" {
  name                        = "${var.project_id}-airflow-bucket"
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id  = "airflow_dataset"
  description = "GCP dataset"
  location    = var.location
}

resource "google_bigquery_table" "default" {

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "airflow_table"
  time_partitioning {
    type  = "DAY"
    field = "tpep_pickup_datetime"
  }
  clustering = ["VendorID", "PULocationID"]
  schema     = file("${path.module}/schemas/schema.json")
}

resource "google_compute_instance" "compute_instance" {
  name         = "airflow-instance"
  machine_type = "e2-standard-8"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
}
