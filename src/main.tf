provider "google" {
  project = var.project_id
  region = var.compute_region
  zone = var.compute_zone
}