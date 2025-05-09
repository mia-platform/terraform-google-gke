resource "google_service_account" "account" {
  project      = var.project_id
  account_id   = var.service_account
  display_name = var.sa_display_name
}

resource "google_project_iam_member" "node" {
  project = var.project_id
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.account.email}"
}
