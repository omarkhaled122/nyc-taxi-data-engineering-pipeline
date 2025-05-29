variable "credentials" {
  description = "Path to the Credentials file"
  default     = "./GCP KEY/zoomcamp-taxi-kestra-2af1224fedf3.json"
}

variable "project_id" {
  description = "Project ID"
  default     = "zoomcamp-taxi-kestra"
}

variable "region" {
  description = "Region"
  default     = "me-central1"
}

variable "project_location" {
  description = "Project location"
  default     = "EU"
}

variable "google_bucket_id" {
  description = "Google Bucket ID"
  default     = "zoomcamp_kestra_gcp_taxi_bucket"
}

variable "bq_google_dataset_id" {
  description = "Bigquery Google's dataset ID"
  default     = "zoomcamp_kestra_gcp_taxi_bq_dataset"
}