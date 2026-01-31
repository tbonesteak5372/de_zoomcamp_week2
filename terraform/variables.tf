variable "project_id" {
  type        = string
  description = "GCP project ID"
  default = "project-bb885080-1abb-4cf9-9a9"
}

variable "region" {
  type        = string
  description = "Default GCP region"
  default     = "us-east5"
}

variable "zone" {
  type        = string
  description = "GCP compute zone"
  default     = "us-east5-a"
}

variable "location" {
  type        = string
  description = "Location for GCS bucket and BigQuery dataset"
  default     = "US"
}

variable "service_account" {
  type        = string
  description =  "terraform@project-bb885080-1abb-4cf9-9a9.iam.gserviceaccount.com"
}
