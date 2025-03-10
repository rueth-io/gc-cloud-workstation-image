# Copyright 2025 Aaron Rueth <aaron@rueth.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  cloudbuild_builds_creator_role_id   = "cloudbuild.builds.creator"
  cloudbuild_builds_creator_role_name = "projects/${var.project_id}/roles/${local.cloudbuild_builds_creator_role_id}"
}

data "google_project" "default" {
  project_id = var.project_id
}

resource "google_project_iam_custom_role" "cloudbuild_builds_creator" {
  description = "Grants permissions to create Cloud Builds"
  permissions = ["cloudbuild.builds.create"]
  project     = data.google_project.default.project_id
  role_id     = local.cloudbuild_builds_creator_role_id
  title       = "Cloud Build Builds Creator"
}

# Grant IAM permissions to the image build service account
resource "google_project_iam_member" "gccwsi_build" {
  for_each = toset(
    [
      "roles/artifactregistry.createOnPushWriter",
      "roles/logging.logWriter",
      "roles/storage.objectAdmin",
    ]
  )

  member  = google_service_account.gccwsi_build.member
  project = data.google_project.default.project_id
  role    = each.value
}

# Grant IAM permissions to the image scheduler service account
resource "google_project_iam_member" "gccwsi_sched" {
  for_each = toset(
    [
      local.cloudbuild_builds_creator_role_name,
      "roles/iam.serviceAccountUser",
    ]
  )

  member  = google_service_account.gccwsi_sched.member
  project = data.google_project.default.project_id
  role    = each.value
}

# Grant IAM permissions to the image Terraform service account
resource "google_project_iam_member" "gccwsi_iac" {
  for_each = toset(
    [
      "roles/owner",
    ]
  )

  member  = google_service_account.gccwsi_iac.member
  project = data.google_project.default.project_id
  role    = each.value
}
