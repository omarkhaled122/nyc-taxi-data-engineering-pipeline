terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.34.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project_id
  region      = var.region
}

resource "google_storage_bucket" "zoomcamp-taxi-bucket" {
  name          = var.google_bucket_id
  location      = var.project_location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "zoomcamp-taxi-dataset" {
  dataset_id                 = var.bq_google_dataset_id
  location                   = var.project_location
  delete_contents_on_destroy = true
}