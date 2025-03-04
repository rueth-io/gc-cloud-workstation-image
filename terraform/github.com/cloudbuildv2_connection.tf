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

resource "google_cloudbuildv2_connection" "gc_cloud_workstation_image" {
  location = var.region
  name     = "gc-cloud-workstation-image"
  project  = data.google_project.default.project_id

  github_config {
    app_installation_id = 62080949
    authorizer_credential {
      oauth_token_secret_version = "${data.google_secret_manager_secret.git_token.id}/versions/latest"
    }
  }
}

resource "google_cloudbuildv2_repository" "gc_cloud_workstation_image" {
  location          = var.region
  name              = "gc-cloud-workstation-image"
  parent_connection = google_cloudbuildv2_connection.gc_cloud_workstation_image.name
  project           = data.google_project.default.project_id
  remote_uri        = "https://${var.git_provider}/${var.git_namespace}/${var.git_repository}.git"
}
